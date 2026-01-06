const diagnosticModel = require('../models/diagnostic.model');
const categoryModel = require('../models/category.model');

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
    return categoryModel.findBySlug(normalizeCategory(categorySlug));
  }
  return null;
};

const createDiagnostic = async ({ userId, categoryId, categorySlug, inputText, imageUrl }) => {
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

  const id = await diagnosticModel.create({
    user_id: userId || null,
    category_id: categoryRecord.id,
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

  return record;
};

module.exports = {
  createDiagnostic
};
