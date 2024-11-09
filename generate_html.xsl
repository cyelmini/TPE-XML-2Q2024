<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes">
<xsl:template match="/data">
    <html>
        <head>Congress Infromation</head>
        <body>
        <h1 align="center"><xsl:value-of select="congress/name"/></h1>
        <h3>from <xsl:value-of select="congress/period/@from"/> to <xsl:value-of select="congress/period/to"/></h3>
        ------------------------------------------
        <xsl:for-each select="congress/chambers/chameber">
            <h2 align="center"><xsl:value-of="name"/></h2>
            <h4 align="center">Members</h4>
            <table border="1" align="center">
                <tr bgcolor="grey">
                    <th>Image</th>
                    <th>Name</th>
                    <th>State</th>
                    <th>Party</th>
                    <th>Period</th>
                </tr>
                <xsl:for-each select="members/member">
                    <tr>
                        <td>
                            <img height="50" width="50">
                                <xsl:attribute name="src">
                                    <xsl:value-of select="image"/>
                                </xsl:attribute>
                            </img>
                        </td>
                        <td><xsl:value-of select="name"/></td>
                        <td><xsl:value-of select="party"/></td>
                        <td><xsl:value-of select="state"/></td>
                        <td>From <xsl:value-of select="period/@from"/> to <xsl:value-of select="period/to"/></td>
                    </tr>
                </xsl:for-each>
            </table>
        </for-each>
        </body>
    </html>
</template>