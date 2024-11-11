
(: Cargar los documentos XML :)
let $congressInfo := doc("congress_info.xml")/api-root/congress
let $membersInfo := doc("congress_members_info.xml")/api-root/members/member

(: Variables para el nombre, número y periodo :)
let $congressName := normalize-space($congressInfo/name)
let $congressNumber := normalize-space($congressInfo/number)
let $startYear := normalize-space($congressInfo/startYear)
let $endYear := normalize-space($congressInfo/endYear)
let $congressUrl := normalize-space($congressInfo/url)

(: Generar el XML de salida :)
return
<data>
    <congress>
        <!-- Nombre del Congreso -->
        <name number="{$congressNumber}">{$congressName}</name>

        <!-- Período de duración del Congreso -->
        <period from="{$startYear}" to="{$endYear}" />

        <!-- URL del Congreso -->
        <url>{$congressUrl}</url>

        <!-- Cámaras del Congreso -->
        <chambers>
            {
                for $chamber in distinct-values($congressInfo/sessions/item/chamber)
                return
                <chamber>
                    <name>{normalize-space($chamber)}</name>
                    
                    <!-- Lista de miembros de la Cámara -->
                    <members>
                        {
                            for $member in $membersInfo
                            for $term in $member/terms/item/item
                            where normalize-space($term/chamber) = normalize-space($chamber)
                            return
                            <member bioguideId="{normalize-space($member/bioguideId)}">
                                <name>{normalize-space($member/name)}</name>
                                <state>{normalize-space($member/state)}</state>
                                <party>{normalize-space($member/partyName)}</party>
                                <image_url>{normalize-space($member/depiction/imageUrl)}</image_url>
                                <period from="{normalize-space($term/startYear)}" to="{if ($term/endYear) then normalize-space($term/endYear) else ''}" />
                            </member>
                        }
                    </members>

                    <!-- Lista de sesiones de la Cámara -->
                    <sessions>
                        {
                            for $session in $congressInfo/sessions/item
                            where normalize-space($session/chamber) = normalize-space($chamber)
                            order by xs:integer($session/number)
                            return
                            <session>
                                <number>{normalize-space($session/number)}</number>
                                <type>{normalize-space($session/type)}</type>
                                <period from="{normalize-space($session/startDate)}" to="{normalize-space($session/endDate)}" />
                            </session>
                        }
                    </sessions>
                </chamber>
            }
        </chambers>
    </congress>
</data>
