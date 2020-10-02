<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" encoding="ISO-8859-1"/>

<xsl:variable name="englishdb" select="document('../db/lfdb.en.xml')"/>
<xsl:variable name="db" select="/"/>

<xsl:variable name="version" select="0.1"/>

<xsl:template match="/">
  <xsl:for-each select="$englishdb/database/issues/issue">
    <xsl:sort select="@code" data-type="number" order="descending"/>
    <xsl:variable name="issueid"><xsl:value-of select="@id"/></xsl:variable>
    <xsl:if test="published">
      <xsl:for-each select="$englishdb/database/articles/article">
        <xsl:if test="issueref[@href=$issueid]">
          <xsl:variable name="artid"><xsl:value-of select="@id"/></xsl:variable>
          <xsl:if test="substring($artid,1,3)='cov'">
            <xsl:choose>
              <xsl:when test="$db/database/articles/article[@id=$artid]/file[@xml:lang='nl']">
                <xsl:variable name="artfile"><xsl:value-of select="$db/database/articles/article[@id=$artid]/file[@xml:lang='nl']"/></xsl:variable>
                <A href="../{$artfile}"><xsl:value-of select="$db/database/issues/issue[@id=$issueid]/title"/></A><br />
              </xsl:when>
              <xsl:otherwise>
                <a href="{$issueid}/index.html"><xsl:value-of select="$db/database/issues/issue[@id=$issueid]/title"/></a><br />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:if>

      </xsl:for-each>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>


