#!/bin/bash

# Ensure an API key is available in the environment
if [[ -z "$CONGRESS_API" ]]; then
  echo "Error: API key not set. Please export CONGRESS_API environment variable."
  exit 1
fi

# Retrieve congress number from input and validate it
congress_number=$1
if [[ -z "$congress_number" || "$congress_number" -lt 1 || "$congress_number" -gt 118 ]]; then
  echo "Error: congress_number must be between 1 and 118."
  exit 1
fi

# Fetch congress information and member data
echo "Fetching congress information for Congress number $congress_number..."
curl -X GET "https://api.congress.gov/v3/congress/$congress_number?format=xml&api_key=${CONGRESS_API}" \
     -H "accept: application/xml" -o congress_info.xml

curl -X GET "https://api.congress.gov/v3/member/congress/$congress_number?format=xml&currentMember=false&limit=500&api_key=${CONGRESS_API}" \
     -H "accept: application/xml" -o congress_members_info.xml

# Check if both files were downloaded successfully
if [[ ! -f "congress_info.xml" || ! -f "congress_members_info.xml" ]]; then
  echo "<data><error>Failed to retrieve XML data for Congress number $congress_number</error></data>" > congress_data.xml
  echo "Error: Failed to retrieve XML data."
  exit 1
fi

# Run the XQuery script to generate congress_data.xml
echo "Processing XML data with XQuery..."
xquery -q extract_congress_data.xq -o congress_data.xml
if [[ $? -ne 0 ]]; then
  echo "<data><error>Error in XQuery processing</error></data>" > congress_data.xml
  echo "Error: XQuery processing failed."
  exit 1
fi

# Transform congress_data.xml into congress_page.html with XSLT
echo "Generating HTML with XSLT..."
xsltproc generate_html.xsl congress_data.xml -o congress_page.html
if [[ $? -ne 0 ]]; then
  echo "<data><error>Error in XSLT transformation</error></data>" > congress_data.xml
  echo "Error: XSLT transformation failed."
  exit 1
fi

# Success message
echo "HTML page successfully generated: congress_page.html"
