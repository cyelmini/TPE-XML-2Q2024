<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <!-- Plantilla principal -->
    <xsl:template match="/data/congress">
        <html>
            <head>
                <title><xsl:value-of select="name"/></title>
            </head>
            <body>

                <!-- Encabezado con el nombre del Congreso y el período -->
                <h1 align="center"><xsl:value-of select="name"/></h1>
                <h3 align="center">
                    <xsl:text>from </xsl:text>
                    <xsl:value-of select="period/@from"/>
                    <xsl:text> to </xsl:text>
                    <xsl:value-of select="period/@to"/>
                </h3>
                <hr/>

                <!-- Iterar sobre cada cámara -->
                <xsl:for-each select="chambers/chamber">
                    <h2 align="center"><xsl:value-of select="name"/></h2>
                    <h4 align="center">Members</h4>

                    <!-- Tabla de miembros -->
                    <table border="1" frame="1" align="center">
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
                                        <xsl:if test="image_url != ''">
                                            <img height="50" width="50">
                                                <xsl:attribute name="src">
                                                    <xsl:value-of select="image_url"/>
                                                </xsl:attribute>
                                            </img>
                                        </xsl:if>
                                    </td>
                                    <td><xsl:value-of select="name"/></td>
                                    <td><xsl:value-of select="state"/></td>
                                    <td><xsl:value-of select="party"/></td>
                                    <td>
                                        <xsl:text>From </xsl:text>
                                        <xsl:value-of select="period/@from"/>
                                        <xsl:if test="period/@to != ''">
                                            <xsl:text> to </xsl:text>
                                            <xsl:value-of select="period/@to"/>
                                        </xsl:if>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>

                    <h4 align="center">Sessions</h4>

                    <!-- Tabla de sesiones -->
                    <table border="1" frame="1" align="center">
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
                                    <td>
                                        <xsl:text>From </xsl:text>
                                        <xsl:value-of select="period/@from"/>
                                        <xsl:if test="period/@to != ''">
                                            <xsl:text> to </xsl:text>
                                            <xsl:value-of select="period/@to"/>
                                        </xsl:if>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>

                    <hr/>
                </xsl:for-each>
            </body>
        </html>
    </xsl:template>

    <!-- Manejo de errores -->
    <xsl:template match="/data/error">
        <html>
            <body>
                <h1 align="center">Error</h1>
                <p align="center"><xsl:value-of select="."/></p>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>