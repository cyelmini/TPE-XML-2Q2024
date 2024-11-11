#!/bin/bash

# Verificamos que se pasen congress_number y api_key como parametros
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Error: Faltan parámetros."
  echo "Usage: ./tpe.sh <congress_number> <api_key>"
  exit 1
fi

# Guardamos los valores en variables y vemos que el numero de congreso sea válido
congress_number=$1
api_key=$2

# Verificamos que el número de congreso esté dentro del rango permitido (1 a 118)
if ((congress_number < 1 || congress_number > 118)); then
  echo "Error: congress_number must be between 1 and 118."
  exit 1
fi

# Obtenemos congress_info.xml llamando al método GET
curl -X GET "https://api.congress.gov/v3/congress/$congress_number?format=xml&api_key=$api_key" \
-H "accept: application/xml" -o congress_info.xml

# Obtenemos congress_members_info.xml llamando al método GET
curl -X GET "https://api.congress.gov/v3/member/congress/$congress_number?format=xml&currentMember=false&limit=500&api_key=$api_key" \
-H "accept: application/xml" -o congress_members_info.xml

echo "Archivos congress_info.xml y congress_members_info.xml generados para el Congreso $congress_number"
