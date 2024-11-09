declare variable $congress-info := doc("congress_info.xml")/api-root/congress;
declare variable $members-info := doc("congress_members_info.xml")/api-root/members/member;

<data>
    {
        (: Verificar si hay un error :)
        if (empty($congress-info) or empty($members-info)) then
            <error>Failed to load congress or members data</error>
        else
            <congress>
                <name number="{data($congress-info/number)}">
                    {data($congress-info/name)}
                </name>
                
                <period from="{data($congress-info/startYear)}" to="{data($congress-info/endYear)}"/>
                
                <url>{data($congress-info/url)}</url>
                
                <chambers>
                    {
                        for $chamber in distinct-values($congress-info/sessions/item/chamber)
                        return
                            <chamber>
                                <name>{$chamber}</name>
                                <members>
                                    {
                                        for $member in $members-info
                                        where $member/terms/item/chamber = $chamber
                                        return
                                            <member bioguideId="{data($member/bioguideId)}">
                                                <name>{data($member/name)}</name>
                                                <state>{data($member/state)}</state>
                                                <party>{data($member/partyName)}</party>
                                                <image_url>{data($member/depiction/imageUrl)}</image_url>
                                                <period from="{data($member/terms/item/startYear)}"
                                                        to="{data($member/terms/item/endYear)}"/>
                                            </member>
                                    }
                                </members>
                                
                                <sessions>
                                    {
                                        for $session in $congress-info/sessions/item
                                        where $session/chamber = $chamber
                                        order by $session/number ascending
                                        return
                                            <session>
                                                <number>{data($session/number)}</number>
                                                <type>{data($session/type)}</type>
                                                <period from="{data($session/startDate)}"
                                                        to="{data($session/endDate)}"/>
                                            </session>
                                    }
                                </sessions>
                            </chamber>
                    }
                </chambers>
            </congress>
    }
</data>
