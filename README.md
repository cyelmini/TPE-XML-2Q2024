# Trabajo Práctico Especial - Diseño y Procesamiento de Documentos XML

Este proyecto se centra en la extracción, transformación y visualización de datos provenientes del Congreso de EE.UU., utilizando técnicas de procesamiento XML y herramientas de XQuery, XSLT y Bash.

## Integrantes
- **Catalina Yelmini** (64133)
- **Francisco Trivelloni** (64141)
- **Mateo Lopez Badias** (64022)

## Docentes a Cargo
- **Valeria Inés Soliani**
- **Teresa Natalia Fontanella De Santis**

## Descripción General
Este proyecto automatiza la descarga y el procesamiento de datos del Congreso de EE.UU. mediante la API de Congress.gov. Incluye la validación de argumentos, transformación de datos en HTML y manejo de errores, de forma que los archivos resultantes cumplan con un esquema XML predefinido.

## Estructura del Proyecto
- **`extract_congress_data.xq`**: Script en XQuery que procesa los datos descargados en formato XML. Aplica consultas a la estructura XML del Congreso para extraer y organizar la información para su posterior manipulación.

- **`generate_html.xsl`**: Archivo de transformación XSLT que convierte el archivo XML procesado en un documento HTML, presentando la información en un formato legible y estructurado para la visualización web.

- **`tpe.sh`**: Script principal en Bash que coordina el flujo de trabajo completo. Realiza las siguientes tareas:
  - Verifica la existencia de una clave de API (`CONGRESS_API`) necesaria para acceder a los datos del Congreso.
  - Valida los argumentos proporcionados, como el número de congreso.
  - Llama a `aux_functions.sh` para la ejecución de funciones auxiliares.
  - Descarga archivos desde la API de Congress.gov y ejecuta el archivo XQuery.
  - Genera el archivo HTML final y maneja los errores si ocurren.

- **`aux_functions.sh`**: Contiene funciones auxiliares reutilizables que organizan el flujo en `tpe.sh`.
  
## Requisitos
- **Clave de API**: Es necesario exportar la clave de la API de Congress.gov como una variable de entorno `CONGRESS_API` antes de ejecutar el script.
- **Java**: Para ejecutar XQuery y las transformaciones XSLT.
- **Curl**: Para descargar archivos de la API.
- **Archivo `.xsd`**: Para la validación del XML generado.

## Uso
1. Configurar la variable de entorno `CONGRESS_API` con la clave de la API de Congress.gov:
   ```bash
   export CONGRESS_API="tu_clave_aqui"
