<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" encoding="ISO-8859-1"/>

<xsl:variable name="englishdb" select="document('../db/lfdb.en.xml')"/>
<xsl:variable name="db" select="document('../db/lfdb.nl.xml')"/>

<xsl:variable name="version" select="0.1"/>

<xsl:template match="/">
  <h3>Recent vertaald</h3>
  <ul>
  <xsl:for-each select="/database/articles/article">
    <xsl:sort select="translation/finished" order="descending"/>
    <xsl:if test="position() &lt;= 10">
      <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
      <xsl:variable name="theme"><xsl:value-of select="$englishdb/database/articles/article[@id=$id]/themeref/@href"/></xsl:variable>
      <li><xsl:value-of select="translation/finished"/>: 
        <xsl:choose>
          <xsl:when test="$db/database/articles/article[@id=$id]/file[@xml:lang='nl' and not(@type='meta')]">
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:text>../</xsl:text>
                <xsl:value-of select="$db/database/articles/article[@id=$id]/file[@xml:lang='nl' and not(@type='meta')]"/>
              </xsl:attribute>
              <xsl:value-of select="title[@xml:lang='nl']"/>
            </xsl:element>
            (<xsl:value-of select="@id"/>, 
            <xsl:value-of select="/database/themes/theme[@id=$theme]/title"/>)
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="$englishdb/database/articles/article[@id=$id]/issueref/@href"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="@id"/>
                <xsl:text>.shtml</xsl:text>
              </xsl:attribute>
              <xsl:value-of select="title[@xml:lang='nl']"/>
            </xsl:element>
            (<xsl:value-of select="@id"/>, 
            <xsl:value-of select="/database/themes/theme[@id=$theme]/title"/>)
          </xsl:otherwise>
        </xsl:choose>
      </li>
    </xsl:if>
  </xsl:for-each>
  </ul>
</xsl:template>

</xsl:stylesheet>


