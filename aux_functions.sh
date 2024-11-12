#/!/bin/bash

check_congress_range() {
    # Verificar que el número de congreso esté en el rango 1-118
    if [[ $1 -lt 1 || $1 -gt 118 ]]; then
        return 1
    else
        return 0
    fi
}

download_file() {
    # Descargar archivo desde la URL especificada
    curl -s -o "$1" "$2"
    return $?
}

query() {
    # Ejecutar la consulta XQuery
    java net.sf.saxon.Query -q:"$1" -o:"$2" congressNumber="$3"
    return $?
}

generate_html() {
    # Generar el archivo HTML con XSLT
    java net.sf.saxon.Transform -s:"$1" -xsl:"$2" -o:"$3"
    return $?
}

create_error_file(){
    # Se crea el archivo de error XML con el esquema correspondiente
    echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <data xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
       xsi:noNamespaceSchemaLocation=\"congress_data.xsd\">
       ${1}
    </data>" > congress_data.xml

    # Generar también un archivo HTML con el mensaje de error
    echo "<html><body><h1>Error</h1><p>${1}</p></body></html>" > congress_page.html

    # Finalizar el script con el código de error proporcionado
    exit ${2}
}






