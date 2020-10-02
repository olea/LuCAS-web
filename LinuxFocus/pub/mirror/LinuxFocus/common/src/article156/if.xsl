<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="*">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="text()"/>

  <xsl:template match="Summary">
    <h2>Summary</h2>
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="Item">
    <b><xsl:value-of select="./name"/></b>: <i><xsl:value-of select="./val-string"/></i><br />
  </xsl:template>

  <xsl:template match="/">
    <html>
      <head>
        <title>Summary Gnumeric File</title>
      </head>
      <body bgcolor="white">
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="Sheets">
    <xsl:for-each select="Sheet">
      <h2><xsl:value-of select="Name"/></h2>
      <ul>
        Rows: <xsl:value-of select="MaxRow"/><br />
        Cols: <xsl:value-of select="MaxCol"/><br />
        <xsl:apply-templates select="Cells"/><br />
      </ul>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="Cells">
    Content of Col 3:
    <xsl:for-each select="Cell">
      <xsl:if test="@Col='3'">
        <xsl:value-of select="Content"/><xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
