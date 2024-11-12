#!/bin/bash
# tpe.sh

echo "Trabajo práctico especial - Diseño y procesamiento de documentos XML - Congreso de EE.UU."
echo "Iniciando..."
source aux_functions.sh

# Verificar que la API KEY esté definida
if [ -z "$CONGRESS_API" ]; then
    echo '¡Error! La clave de la API no está definida.'
    ERROR='<error>API KEY not defined.</error>'
    create_error_file "$ERROR" "1"
fi

# Verificar que se proporcionó el número de congreso como argumento
if [ $# -ne 1 ]; then
    echo "¡Cantidad de argumentos inválida! Por favor ingrese únicamente el número de congreso."
    ERROR='<error>Invalid number of arguments.</error>'
    create_error_file "$ERROR" "2"
fi

# Definir la variable del número de congreso
CONGRESS_NUMBER=$1

# Validar que el número de congreso esté en el rango 1-118
check_congress_range "$CONGRESS_NUMBER"
if [ $? -ne 0 ]; then
    echo "¡Número de congreso fuera de rango! Debe estar entre 1 y 118."
    ERROR='<error>Congress number out of range (1-118).</error>'
    create_error_file "$ERROR" "3"
fi

# Descargar los archivos XML necesarios
echo "Descargando archivos de Congress.gov API..."
URL_INFO="https://api.congress.gov/v3/congress/${CONGRESS_NUMBER}?format=xml&api_key=${CONGRESS_API}"
URL_MEMBERS="https://api.congress.gov/v3/member/congress/${CONGRESS_NUMBER}?format=xml&currentMember=false&limit=500&api_key=${CONGRESS_API}"

download_file "congress_info.xml" "$URL_INFO"
if [ $? -ne 0 ]; then
    echo "¡Error al descargar congress_info.xml!"
    ERROR='<error>Failed to download congress_info.xml</error>'
    create_error_file "$ERROR" "4"
fi

download_file "congress_members_info.xml" "$URL_MEMBERS"
if [ $? -ne 0 ]; then
    echo "¡Error al descargar congress_members_info.xml!"
    ERROR='<error>Failed to download congress_members_info.xml</error>'
    create_error_file "$ERROR" "5"
fi

# Extraer el rango de fechas del congreso
START_YEAR=$(xmllint --xpath 'string(/api-root/congress/startYear)' congress_info.xml)
END_YEAR=$(xmllint --xpath 'string(/api-root/congress/endYear)' congress_info.xml)

# Ejecutar el XQuery para generar el archivo XML
echo "Ejecutando XQuery para procesar los datos..."
query "extract_congress_data.xq" "congress_data.xml" "$CONGRESS_NUMBER"
if [ $? -ne 0 ]; then
    echo "¡Error al ejecutar XQuery!"
    ERROR='<error>Failed to execute XQuery</error>'
    create_error_file "$ERROR" "6"
fi

# Ejecutar la transformación XSLT para generar el archivo HTML
echo "Generando archivo HTML..."
generate_html "congress_data.xml" "generate_html.xsl" "congress_page.html"
if [ $? -ne 0 ]; then
    echo "¡Error al generar HTML!"
    ERROR='<error>Failed to generate HTML</error>'
    create_error_file "$ERROR" "7"
fi

echo "Proceso completado. Revisa congress_page.html para ver el resultado."
