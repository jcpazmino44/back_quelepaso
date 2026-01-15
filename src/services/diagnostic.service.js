const diagnosticModel = require('../models/diagnostic.model');
const categoryModel = require('../models/category.model');
const guideModel = require('../models/guide.model');
const historyService = require('./history.service');

const normalizeText = (value) =>
  String(value || '')
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .trim();

const normalizeCategory = (value) => {
  const key = normalizeText(value);
  if (key === 'electro') return 'electrodomesticos';
  if (key === 'electrodomesticos' || key === 'electrodomestico') return 'electrodomesticos';
  if (key === 'electricidad' || key === 'electrico') return 'electricidad';
  if (key === 'plomeria' || key === 'fontaneria') return 'plomeria';
  if (key === 'otro') return 'general';
  if (key.startsWith('electricidad')) return 'electricidad';
  if (key.startsWith('plomeria') || key.startsWith('fontaneria') || key.startsWith('griferia')) {
    return 'plomeria';
  }
  if (
    key.startsWith('electro') ||
    key === 'nevera' ||
    key === 'lavadora' ||
    key === 'ventilador'
  ) {
    return 'electrodomesticos';
  }
  if (key.startsWith('internet') || key.startsWith('wifi')) return 'internet';
  return key;
};

const DIAGNOSTIC_RULES = {
  plomeria: [
    {
      keywords: ['fuga', 'gotea', 'gotera'],
      riskLevel: 'medio',
      cause: 'Fuga en union o empaque deteriorado.'
    },
    {
      keywords: ['fuga leve'],
      riskLevel: 'bajo',
      cause: 'Fuga menor o sello con desgaste leve.'
    },
    {
      keywords: ['no sale agua', 'baja presion'],
      riskLevel: 'medio',
      cause: 'Obstruccion parcial o valvula cerrada.'
    },
    {
      keywords: ['revento', 'inundacion'],
      riskLevel: 'alto',
      cause: 'Fuga mayor en tuberia principal.'
    },
    {
      keywords: ['humedad', 'moho'],
      riskLevel: 'medio',
      cause: 'Filtracion persistente en pared.'
    }
  ],
  electricidad: [
    {
      keywords: ['chispa', 'corto', 'quemado'],
      riskLevel: 'alto',
      cause: 'Posible cortocircuito o cable expuesto.'
    },
    {
      keywords: ['sin luz', 'apagon'],
      riskLevel: 'medio',
      cause: 'Interruptor o disyuntor disparado.'
    },
    {
      keywords: ['toma caliente'],
      riskLevel: 'alto',
      cause: 'Sobrecarga o mala conexion.'
    },
    {
      keywords: ['parpadea'],
      riskLevel: 'medio',
      cause: 'Conexion floja o caida de voltaje.'
    }
  ],
  electrodomesticos: [
    {
      keywords: ['no enciende'],
      riskLevel: 'medio',
      cause: 'Falla de energia o componente interno.'
    },
    {
      keywords: ['olor a quemado'],
      riskLevel: 'alto',
      cause: 'Sobrecalentamiento interno.'
    },
    {
      keywords: ['ruido fuerte'],
      riskLevel: 'medio',
      cause: 'Pieza suelta o desgaste.'
    },
    {
      keywords: ['fuga de agua'],
      riskLevel: 'medio',
      cause: 'Manguera o sello danado.'
    }
  ],
  internet: [
    {
      keywords: ['sin internet'],
      riskLevel: 'bajo',
      cause: 'Router sin conexion o ISP caido.'
    },
    {
      keywords: ['wifi lento', 'wi fi lento'],
      riskLevel: 'bajo',
      cause: 'Congestion o mala senal.'
    },
    {
      keywords: ['router reinicia'],
      riskLevel: 'medio',
      cause: 'Sobrecalentamiento o fuente inestable.'
    }
  ],
  general: [
    {
      keywords: ['gas', 'fuga de gas'],
      riskLevel: 'alto',
      cause: 'Posible fuga de gas.'
    },
    {
      keywords: ['incendio', 'humo'],
      riskLevel: 'alto',
      cause: 'Riesgo de incendio.'
    }
  ]
};

const RISK_MAP = {
  bajo: {
    label: 'Riesgo bajo',
    detail: 'Puedes intentar resolverlo con cuidado.'
  },
  medio: {
    label: 'Riesgo medio',
    detail: 'El problema requiere atencion para evitar danos mayores.'
  },
  alto: {
    label: 'Riesgo alto',
    detail: 'No intervengas. Lo mas seguro es contactar a un tecnico.'
  }
};

const DEFAULT_NOTE = 'Este diagnostico es orientativo y no reemplaza a un tecnico.';

const resolveDiagnostic = (category, inputText) => {
  const rules = DIAGNOSTIC_RULES[category] || [];
  const text = normalizeText(inputText);

  for (const rule of rules) {
    if (rule.keywords.some((keyword) => text.includes(normalizeText(keyword)))) {
      return { riskLevel: rule.riskLevel, possibleCause: rule.cause };
    }
  }

  return {
    riskLevel: 'medio',
    possibleCause: `Diagnostico preliminar para categoria: ${category}`
  };
};

const resolveCategory = async ({ categoryId, categorySlug }) => {
  if (categoryId) {
    return categoryModel.findById(categoryId);
  }
  if (categorySlug) {
    const directMatch = await categoryModel.findBySlug(categorySlug);
    if (directMatch) {
      return directMatch;
    }
    return categoryModel.findBySlug(normalizeCategory(categorySlug));
  }
  return null;
};

const resolveGuide = async ({ guideId, guideSlug, categorySlug }) => {
  if (guideId) {
    return { id: guideId };
  }
  if (guideSlug) {
    const normalizedGuideSlug = String(guideSlug).trim().toLowerCase();
    if (normalizedGuideSlug === 'otro') {
      if (!categorySlug) {
        return null;
      }
      const guide = await guideModel.findMostCompleteByCategorySlug(categorySlug);
      return guide ? { id: guide.id, slug: guide.slug } : null;
    }
    const guide = await guideModel.findBySlug({ slug: guideSlug, isActive: true });
    return guide ? { id: guide.id, slug: guide.slug } : null;
  }
  return null;
};

const createDiagnostic = async ({
  userId,
  categoryId,
  categorySlug,
  inputText,
  imageUrl,
  guideId,
  guideSlug
}) => {
  const categoryRecord = await resolveCategory({ categoryId, categorySlug });
  if (!categoryRecord) {
    const error = new Error('category is required');
    error.status = 400;
    throw error;
  }

  if (categoryRecord.is_active === false) {
    const error = new Error('category is inactive');
    error.status = 400;
    throw error;
  }

  const normalizedCategory = normalizeCategory(categoryRecord.slug);
  if (!DIAGNOSTIC_RULES[normalizedCategory]) {
    const error = new Error('category is invalid');
    error.status = 400;
    throw error;
  }

  const { riskLevel, possibleCause } = resolveDiagnostic(normalizedCategory, inputText);

  const guideRecord = await resolveGuide({
    guideId,
    guideSlug,
    categorySlug: categoryRecord.slug
  });
  if ((guideId || guideSlug) && !guideRecord) {
    const error = new Error('guide is invalid');
    error.status = 400;
    throw error;
  }

  const id = await diagnosticModel.create({
    user_id: userId || null,
    category_id: categoryRecord.id,
    guide_id: guideRecord ? guideRecord.id : null,
    input_text: inputText || null,
    image_url: imageUrl || null,
    possible_cause: possibleCause,
    risk_level: riskLevel
  });

  const record = await diagnosticModel.findById(id);
  if (!record) {
    const error = new Error('diagnostic not found after create');
    error.status = 500;
    throw error;
  }

  const trimmedInput = String(inputText || '').trim();
  let summaryImageUrl = categoryRecord.image_url || null;
  if (!summaryImageUrl && normalizedCategory && normalizedCategory !== categoryRecord.slug) {
    const fallbackCategory = await categoryModel.findBySlug(normalizedCategory);
    if (fallbackCategory?.image_url) {
      summaryImageUrl = fallbackCategory.image_url;
    }
  }
  const summaryTitle = trimmedInput || `Problema de ${categoryRecord.name}`;
  const riskInfo = RISK_MAP[riskLevel] || {
    label: 'Riesgo medio',
    detail: 'El problema requiere atencion para evitar danos mayores.'
  };

  await historyService.createHistory({
    userId: userId || null,
    diagnosticId: record.id,
    title: summaryTitle,
    categoryId: categoryRecord.id,
    deviceId: null
  });

  return {
    ...record,
    category_slug: categoryRecord.slug,
    category_info: categoryRecord,
    guide_slug: guideRecord ? guideRecord.slug : record.guide_slug || null,
    risk_label: riskInfo.label,
    risk_detail: riskInfo.detail,
    summary_title: summaryTitle,
    summary_tag: categoryRecord.name,
    summary_image_url: summaryImageUrl,
    note: DEFAULT_NOTE
  };
};

module.exports = {
  createDiagnostic
};
