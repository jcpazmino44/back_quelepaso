# Uso de imagen en diagnosticos

Estado actual
- La API solo guarda el valor de `imageUrl` en `diagnostics.image_url`.
- No hay procesamiento, validacion ni subida de archivos en el backend.

Posibles usos futuros

1) Mostrarla en historial
- Aporta contexto visual del problema junto al diagnostico.
- Se usa en la lista y el detalle de diagnosticos.
- Requiere solo consumir y renderizar `diagnostics.image_url`.

2) Enviarla al tecnico
- Permite que el tecnico tenga contexto antes de la visita.
- Se usa en la ficha del tecnico o en el mensaje de contacto.
- Requiere incluir `image_url` en el payload y definir reglas de privacidad y expiracion.

3) Flujo de revision
- Facilita revision humana o semiautomatica de diagnosticos.
- Se usa en una cola de revision con estados (pendiente/aprobado) y comentarios.
- Requiere endpoints para listar diagnósticos con imagen y registrar decisiones.
