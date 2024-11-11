#!/bin/bash

# Verificar que se haya proporcionado un número de congreso como parámetro
if [ -z "$1" ]; then
  echo "Usage: $0 <congress_number>"
  echo "Please provide the congress number as a parameter."
  exit 1
fi

# Número de congreso proporcionado como primer argumento
CONGRESS_NUMBER="$1"

# Verificar que la variable de entorno CONGRESS_API esté definida
if [ -z "$CONGRESS_API" ]; then
  echo "Error: The environment variable CONGRESS_API is not set."
  echo "Please set the API key with: export CONGRESS_API='<your_api_key>'"
  exit 1
fi

# Archivos de salida
OUTPUT_XML="congress_data.xml"
OUTPUT_HTML="congress_page.html"

# Paso 1: Obtener congress_info.xml desde la API
echo "Fetching congress_info.xml from Congress.gov API..."
curl -X GET "https://api.congress.gov/v3/congress/${CONGRESS_NUMBER}?format=xml&api_key=${CONGRESS_API}" \
     -H "accept: application/xml" -o congress_info.xml

if [[ $? -ne 0 ]]; then
  echo "Error: Failed to fetch congress_info.xml."
  exit 1
fi

echo "Archivo congress_info.xml obtenido correctamente."

# Paso 2: Obtener congress_members_info.xml desde la API
echo "Fetching congress_members_info.xml from Congress.gov API..."
curl -X GET "https://api.congress.gov/v3/member/congress/${CONGRESS_NUMBER}?format=xml&currentMember=false&limit=500&api_key=${CONGRESS_API}" \
     -H "accept: application/xml" -o congress_members_info.xml

if [[ $? -ne 0 ]]; then
  echo "Error: Failed to fetch congress_members_info.xml."
  exit 1
fi

echo "Archivo congress_members_info.xml obtenido correctamente."

# Paso 3: Ejecutar la consulta XQuery para generar el archivo XML
echo "Ejecutando XQuery para generar $OUTPUT_XML..."
java net.sf.saxon.Query -q:extract_congress_data.xq -o:"$OUTPUT_XML" congressNumber="$CONGRESS_NUMBER"

if [[ $? -ne 0 ]]; then
  echo "Error: La ejecución de XQuery falló."
  exit 1
fi

echo "Archivo $OUTPUT_XML generado correctamente."

# Paso 4: Ejecutar la transformación XSLT para generar el archivo HTML
echo "Ejecutando XSLT para generar $OUTPUT_HTML..."
java net.sf.saxon.Transform -s:"$OUTPUT_XML" -xsl:generate_html.xsl -o:"$OUTPUT_HTML"

if [[ $? -ne 0 ]]; then
  echo "Error: La ejecución de XSLT falló."
  exit 1
fi

echo "Archivo $OUTPUT_HTML generado correctamente."

# Mensaje final
echo "Proceso completado. Revisa $OUTPUT_HTML para ver el resultado en formato HTML."
