<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" encoding="ISO-8859-1"/>

<xsl:variable name="englishdb" select="document('../db/lfdb.en.xml')"/>
<xsl:variable name="localdb" select="document('../db/lfdb.nl.xml')"/>

<xsl:variable name="stylesheetname" select="'vertaald.xslt'"/>
<xsl:variable name="version" select="'0.3'"/>
<xsl:variable name="lfroot" select="''"/>

<xsl:include href="header.nl.xslt"/>

<xsl:template match="/">
  <HTML>
    <HEAD>
      <META http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
      <TITLE>LinuxFocus Index</TITLE>
    </HEAD>
 
    <BODY bgcolor="#ffffff"  text="#000000" alink="#336633" link="#336633" >
 

<xsl:call-template name="header"/>

      <CENTER>
        <H1>Vertaalde artikelen</H1>
      </CENTER>

      <xsl:for-each select="$englishdb/database/issues/issue">
        <xsl:sort select="@code" data-type="number"
                order="descending"/>
        <xsl:if test="published">
          <xsl:apply-templates select="."/>
        </xsl:if>
      </xsl:for-each>

<xsl:call-template name="footer"/>

    </BODY>
  </HTML>
</xsl:template>

<xsl:template match="issue">
  <xsl:variable name="issueid"><xsl:value-of select="@id"/></xsl:variable>
  
  <h3><xsl:value-of select="title"/></h3>
  <ul>
  <xsl:for-each select="$englishdb/database/articles/article/issueref[@href=$issueid]">
    <xsl:sort select="../@id" data-type="number" order="descending"/>
    <xsl:variable name="id" select="../@id"/>
    <xsl:apply-templates select="$localdb/database/articles/article[@id=$id]">
        <xsl:with-param name="issueid" select="$issueid"/>
    </xsl:apply-templates>
  </xsl:for-each>
  </ul>
</xsl:template>

<xsl:template match="article">
  <xsl:param name="issueid"/>
  <xsl:variable name="artid"><xsl:value-of select="@id"/></xsl:variable>
  <xsl:variable name="artlang"><xsl:value-of select="$englishdb/database/articles/article[@id=$artid]/xml:lang"/></xsl:variable>
  <xsl:if test="not(substring($artid,1,3)='cov') and (translation/finished or $artlang='nl')">
  <li>
    <xsl:choose>
      <xsl:when test="not(nohtml)">
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:text>../</xsl:text>
            <xsl:choose>
              <xsl:when test="file[@xml:lang='nl' and not(@type='meta')]">
                <xsl:value-of select="file[@xml:lang='nl' and not(@type='meta')]"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>Nederlands/</xsl:text>
                <xsl:value-of select="$issueid"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="$artid"/>
                <xsl:text>.shtml</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:value-of select="title"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="title"/></xsl:otherwise>
    </xsl:choose>
    <xsl:if test="abstract[@xml:lang='nl']">
      <br/><xsl:value-of select="abstract[@xml:lang='nl']"/>
    </xsl:if>
  </li>
  </xsl:if>
  <xsl:text>  </xsl:text>

</xsl:template>

</xsl:stylesheet>
