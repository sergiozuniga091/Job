# Agente de hojas de vida — Sergio Zúñiga Galíndez

Este repositorio guarda las hojas de vida de Sergio Zúñiga Galíndez, arquitecto de soluciones. El agente que trabaje aquí organiza, mejora y personaliza esas hojas de vida. Responde siempre en español, salvo que Sergio pida otra cosa.

## Estructura

```
hojas-de-vida/
  estilos/hoja-de-vida.css      diseño común de todas las hojas de vida (A4, 4 páginas)
  general/
    es/                         hoja de vida general en español (base para empresas en español)
    en/                         hoja de vida general en inglés (base para empresas en inglés)
  empresas/
    _plantilla/vacante.md       plantilla de la ficha de vacante
    <empresa>/                  una carpeta por empresa
      vacante.md                requisitos, enfoque, cambios y brechas de esa postulación
      <nombre>.html             fuente editable de la hoja personalizada
      <nombre>.pdf              PDF generado a partir del HTML
scripts/generar-pdf.sh          genera los PDF a partir de los HTML
```

Cada hoja de vida tiene su propio HTML y se edita por separado. El PDF siempre se genera desde el HTML con el script y nunca se edita a mano.

## Reglas de contenido

1. **No inventar.** Solo se usa experiencia, cifras, fechas, certificaciones y niveles que ya estén en la hoja general o que Sergio confirme. Si una vacante pide algo que no está, se anota en la sección "Brechas" de `vacante.md` y se le dice a Sergio.
2. **La hoja general es la fuente de verdad.** Un dato nuevo (un proyecto, una certificación, un cambio de cargo) se agrega primero en `general/es` y en `general/en`, y después en las versiones por empresa que lo necesiten.
3. **Español e inglés van sincronizados.** Todo cambio de contenido en `general/es` se refleja en `general/en`, y al revés.
4. **Personalizar es reordenar y reenfocar, no agregar hechos.** En una versión por empresa se puede reescribir el perfil, cambiar el orden de habilidades y proyectos, ajustar el título y el énfasis de los logros, y quitar lo que no aporta a la vacante.
5. **Mantener 4 páginas como máximo** y el diseño de `estilos/hoja-de-vida.css`. Si una versión necesita un ajuste de diseño propio, se hace con un `<style>` dentro de su HTML, no en el CSS común.
6. **Datos que no cambian sin confirmación de Sergio:** nombre, correo, teléfono, ciudad, fechas de cada cargo, certificaciones, títulos académicos y niveles de idioma. Excepción ya acordada: en versiones para vacantes que pidan inglés B2, el inglés se muestra como B2.

## Estilo de redacción

- Arquitecto de soluciones con enfoque en decisiones, impacto y responsabilidad técnica.
- Logros en primera persona y en pasado ("Diseñé", "Lideré"), con cifras reales cuando existan.
- Frases directas. Evitar adjetivos vacíos ("sólido", "robusto") cuando no aportan información.
- Vocabulario de la vacante cuando coincide con experiencia real (por ejemplo, si piden AWS primero, AWS va antes que Azure).

## Flujos de trabajo

### Crear una versión para una empresa

1. Crear la carpeta `hojas-de-vida/empresas/<empresa>/` (minúsculas, sin tildes, con guiones).
2. Copiar `empresas/_plantilla/vacante.md` y completarlo con la vacante que entregue Sergio.
3. Copiar el HTML base según el idioma de la vacante: `general/es/...html` o `general/en/...html`. Nombres de archivo:
   - Español: `HV_Sergio_Zuniga_<año>_ES_<Empresa>[_<Enfoque>].html`
   - Inglés: `Sergio_Zuniga_CV_<año>_EN_<Empresa>[_<Enfoque>].html`
4. Comparar la vacante con la hoja base: qué requisitos se cubren, cuáles se pueden destacar mejor y cuáles son brechas.
5. Personalizar el HTML siguiendo las reglas de contenido y registrar los cambios en `vacante.md`.
6. Generar el PDF y revisarlo (ver abajo).
7. Agregar la nueva versión a la tabla del `README.md`.

### Mejorar la hoja general

1. Proponer los cambios a Sergio antes de reescribir secciones completas.
2. Aplicar el cambio en `general/es` y `general/en`.
3. Preguntar si el cambio también debe llegar a las versiones por empresa.

### Generar y revisar los PDF

```bash
scripts/generar-pdf.sh                               # todas las hojas de vida
scripts/generar-pdf.sh hojas-de-vida/empresas/pragma  # solo una carpeta
```

Necesita Google Chrome o Chromium (se puede indicar la ruta con `CHROME=/ruta`). Después de generar, revisar que el PDF tenga 4 páginas o menos, que ningún proyecto quede partido entre páginas y que no haya texto cortado.
