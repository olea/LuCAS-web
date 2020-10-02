<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="*">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="text()"/>

  <xsl:template match="Item">
    <xsl:value-of select="./name"/> : <xsl:value-of select="./val-string"/>
  </xsl:template>

</xsl:stylesheet>
