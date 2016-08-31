<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="*">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="text()"/>

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

</xsl:stylesheet>
