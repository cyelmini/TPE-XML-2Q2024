#!/bin/bash

# Verificamos que se haya pasado el parámetro congress_number
if [ -z "$1" ]; then
  echo "Error: No congress_number provided."
  echo "Usage: ./tpe.sh <congress_number>"
  exit 1
fi

# Guardamos el congress_number en una variable y vemos que sea válido
congress_number=$1

if ((congress_number < 1 || congress_number > 118)); then
  echo "Error: congress_number must be between 1 and 118."
  exit 1
fi

# Obtenemos congress_info.xml usando el parámetro congress_number
curl -X GET "https://api.congress.gov/v3/congress/$congress_number?format=xml&api_key=$CONGRESS_API" \
-H "accept: application/xml" -o congress_info.xml

# Obtenemos congress_members_info.xml usando el parámetro congress_number
curl -X GET "https://api.congress.gov/v3/member/congress/$congress_number?format=xml&currentMember=false&limit=500&api_key=$CONGRESS_API" \
-H "accept: application/xml" -o congress_members_info.xml

echo "Archivos congress_info.xml y congress_members_info.xml generados para el Congreso $congress_number"
