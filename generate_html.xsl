<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- Establecer el output en HTML -->
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/data">
        <!-- Verificar si hay un error -->
        <html>
            <head>
                <title>Congress Information</title>
            </head>
            <body>
                <xsl:choose>
                    <xsl:when test="error">
                        <h1 style="text-align: center; color: red;">
                            <xsl:value-of select="error"/>
                        </h1>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Encabezado del Congreso -->
                        <h1 align="center">
                            <xsl:value-of select="congress/name"/>
                        </h1>
                        <h3 align="center">
                            From <xsl:value-of select="congress/period/@from"/> to <xsl:value-of select="congress/period/@to"/>
                        </h3>
                        <hr/>

                        <!-- Cámaras y Miembros -->
                        <xsl:for-each select="congress/chambers/chamber">
                            <h2 align="center">
                                <xsl:value-of select="name"/>
                            </h2>
                            <h4 align="center">Members</h4>
                            <table border="1" frame="box" align="center">
                                <thead bgcolor="grey">
                                    <tr>
                                        <th>Image</th>
                                        <th>Name</th>
                                        <th>State</th>
                                        <th>Party</th>
                                        <th>Period</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <xsl:for-each select="members/member">
                                        <tr>
                                            <td>
                                                <img height="50" width="50">
                                                    <xsl:attribute name="src">
                                                        <xsl:value-of select="image_url"/>
                                                    </xsl:attribute>
                                                </img>
                                            </td>
                                            <td><xsl:value-of select="name"/></td>
                                            <td><xsl:value-of select="state"/></td>
                                            <td><xsl:value-of select="party"/></td>
                                            <td>From <xsl:value-of select="period/@from"/> to <xsl:value-of select="period/@to"/></td>
                                        </tr>
                                    </xsl:for-each>
                                </tbody>
                            </table>

                            <!-- Sesiones -->
                            <h4 align="center">Sessions</h4>
                            <table border="1" frame="box" align="center">
                                <thead bgcolor="grey">
                                    <tr>
                                        <th>Number</th>
                                        <th>Type</th>
                                        <th>Period</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <xsl:for-each select="sessions/session">
                                        <tr>
                                            <td><xsl:value-of select="number"/></td>
                                            <td><xsl:value-of select="type"/></td>
                                            <td>From <xsl:value-of select="period/@from"/> to <xsl:value-of select="period/@to"/></td>
                                        </tr>
                                    </xsl:for-each>
                                </tbody>
                            </table>
                            <hr/>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
