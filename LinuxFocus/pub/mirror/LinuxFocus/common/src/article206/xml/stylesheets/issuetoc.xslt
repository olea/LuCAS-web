<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" encoding="ISO-8859-1"/>

<xsl:variable name="englishdb" select="document('../db/lfdb.en.xml')"/>
<xsl:variable name="db" select="/"/>

<xsl:variable name="version" select="'0.2'"/>
<xsl:variable name="stylesheetname" select="'issuestoc.xslt'"/>
<xsl:variable name="lfroot" select="''"/>

<xsl:template match="/">
  <xsl:variable name="current"><xsl:value-of select="$englishdb/database/issues/issue/current/../@id"/></xsl:variable>
  <xsl:choose>
    <xsl:when test="$db/database/issues/issue[@id=$current]/title[@xml:lang='nl']">
      <h3><xsl:value-of select="$db/database/issues/issue[@id=$current]/title[@xml:lang='nl']"/></h3>
    </xsl:when>
    <xsl:otherwise>
      <h3><xsl:value-of select="$englishdb/database/issues/issue[@id=$current]/title[@xml:lang='nl']"/></h3>
    </xsl:otherwise>
  </xsl:choose>
  <ul>
  <b>Vertaald</b>
  <xsl:for-each select="$englishdb/database/articles/article[issueref/@href=$current]">
    <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
    <xsl:if test="$db/database/articles/article[@id=$id]/translation/finished">
      <li>
      <xsl:choose>
        <xsl:when test="substring($id,1,3)='cov'">
          <xsl:choose>
            <xsl:when test="$db/database/articles/article[@id=$id]/file[@xml:lang='nl']">
              <xsl:variable name="artfilename"><xsl:value-of select="$db/database/articles/article[@id=$id]/file[@xml:lang='nl']"/></xsl:variable>
              <a href="../{$artfilename}">Titelpagina</a>
            </xsl:when>
            <xsl:otherwise>
              <a href="../Nederlands/{$current}/index.html">Titelpagina</a>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <a href="../Nederlands/{$current}/{$id}.shtml">
          <xsl:value-of select="$db/database/articles/article[@id=$id]/title[@xml:lang='nl']"/></a>
        </xsl:otherwise>
      </xsl:choose>
      </li>
    </xsl:if>
  </xsl:for-each>
  <p /><b>Onvertaald</b>
  <xsl:for-each select="$englishdb/database/articles//article[issueref/@href=$current]">
    <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
    <xsl:if test="not($db/database/articles/article[@id=$id]/translation/finished)">
      <li>
      <xsl:choose>
        <xsl:when test="substring($id,1,3)='cov'">
          <a href="../English/{$current}/">
          <xsl:value-of select="title"/></a>
          <xsl:text> </xsl:text><i>(Engels)</i>
        </xsl:when>
        <xsl:otherwise>
          <a href="../English/{$current}/{$id}.shtml">
          <xsl:value-of select="title"/></a>
          <xsl:text> </xsl:text><i>(Engels)</i>
        </xsl:otherwise>
      </xsl:choose>
      </li>
    </xsl:if>
  </xsl:for-each>
  </ul>
</xsl:template>

</xsl:stylesheet>

