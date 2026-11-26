#!/usr/bin/env bash
# Genera el PDF de cada hoja de vida a partir de su HTML, en la misma carpeta y con el mismo nombre.
#
#   scripts/generar-pdf.sh                                  # todas las hojas de vida
#   scripts/generar-pdf.sh hojas-de-vida/empresas/pragma     # solo una carpeta
#   scripts/generar-pdf.sh ruta/al/archivo.html              # solo un archivo
set -euo pipefail

raiz="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$raiz"

chrome="${CHROME:-}"
if [[ -z "$chrome" ]]; then
  for candidato in google-chrome google-chrome-stable chromium chromium-browser \
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"; do
    if command -v "$candidato" >/dev/null 2>&1; then chrome="$candidato"; break; fi
  done
fi
if [[ -z "$chrome" ]]; then
  echo "No encontré Chrome ni Chromium. Instálalo o indica la ruta con CHROME=/ruta/al/chrome." >&2
  exit 1
fi

objetivos=("${@:-hojas-de-vida}")
htmls=()
for objetivo in "${objetivos[@]}"; do
  if [[ -f "$objetivo" ]]; then
    htmls+=("$objetivo")
  else
    while IFS= read -r archivo; do htmls+=("$archivo"); done \
      < <(find "$objetivo" -name '*.html' -not -path '*/_plantilla/*' | sort)
  fi
done

perfil="$(mktemp -d)"
trap 'rm -rf "$perfil"' EXIT

for html in "${htmls[@]}"; do
  pdf="${html%.html}.pdf"
  salida="$perfil/salida.pdf"
  rm -f "$salida"
  # En algunos entornos Chrome escribe el PDF pero no termina, así que se espera el archivo y se cierra.
  "$chrome" --headless --disable-gpu --no-sandbox --no-pdf-header-footer \
    --user-data-dir="$perfil/chrome" --print-to-pdf="$salida" "file://$raiz/$html" >/dev/null 2>&1 &
  pid=$!
  for _ in $(seq 1 120); do
    if ! kill -0 "$pid" 2>/dev/null; then break; fi
    if [[ -s "$salida" ]] && sleep 1 && [[ -s "$salida" ]]; then break; fi
    sleep 0.5
  done
  kill "$pid" 2>/dev/null || true
  wait "$pid" 2>/dev/null || true
  if [[ ! -s "$salida" ]]; then
    echo "No se pudo generar $pdf" >&2
    exit 1
  fi
  mv "$salida" "$raiz/$pdf"
  echo "Generado: $pdf"
done
