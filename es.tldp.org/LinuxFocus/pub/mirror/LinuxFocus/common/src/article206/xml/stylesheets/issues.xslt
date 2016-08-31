<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" encoding="ISO-8859-1"/>

<xsl:variable name="englishdb" select="document('../db/lfdb.en.xml')"/>
<xsl:variable name="localdb" select="document('../db/lfdb.nl.xml')"/>

<xsl:variable name="version" select="'0.3'"/>
<xsl:variable name="stylesheetname" select="'issues.xslt'"/>
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
        <H1>Overzicht per LinuxFocus nummer</H1>
      </CENTER>
      <BLOCKQUOTE>
        Dit is een overzicht van alle LinuxFocus artikelen, gesorteerd per nummer.<br />
        De niet vertaalde artikelen leiden naar de Engelse versies.
      </BLOCKQUOTE>

      <xsl:for-each select="$englishdb/database/issues/issue">
        <xsl:sort select="@code" data-type="number" order="descending"/>
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
  
  <h3><xsl:value-of select="$localdb/database/issues/issue[@id=$issueid]/title"/></h3>
  <ul>
  <xsl:for-each select="$englishdb/database/articles/article/issueref[@href=$issueid]">
    <xsl:sort select="@id" data-type="number" order="descending"/>
    <xsl:variable name="id" select="@id"/>
    <xsl:apply-templates select="..">
        <xsl:with-param name="issueid" select="$issueid"/>
    </xsl:apply-templates>
  </xsl:for-each>
  <xsl:text>   </xsl:text>
  </ul>
</xsl:template>

<xsl:template match="article">
  <xsl:param name="issueid"/>
  <xsl:variable name="artid"><xsl:value-of select="@id"/></xsl:variable>
  <xsl:variable name="artlang"><xsl:value-of select="$englishdb/database/articles/article[@id=$artid]/xml:lang"/></xsl:variable>
  <xsl:variable name="article" select="$localdb/database/articles/article[@id=$artid]"/>
  <li>
      <xsl:choose>
        <xsl:when test="substring(@id,1,3)='cov'">
          <xsl:choose>
            <xsl:when test="$article/file[@xml:lang='nl']">
              <xsl:variable name="artfilename"><xsl:value-of select="$article/file[@xml:lang='nl']"/></xsl:variable>
              <a href="../{$artfilename}"><xsl:value-of select="$article/title"/></a>
            </xsl:when>
            <xsl:otherwise>
              <a href="../Nederlands/{$issueid}/index.html"><xsl:value-of select="$article/title"/></a>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$article/translation/finished or $artlang='nl'">
          <xsl:choose>
            <xsl:when test="not(nohtml)">
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:text>../</xsl:text>
                  <xsl:choose>
                    <xsl:when test="$article/file[@xml:lang='nl' and not(@type='meta')]">
                      <xsl:value-of select="$article/file[@xml:lang='nl' and not(@type='meta')]"/>
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
                <xsl:choose>
                  <xsl:when test="$article/title[@xml:lang='nl']">
                    <xsl:value-of select="$article/title[@xml:lang='nl']"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="title"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$article/title"/></xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="not(nohtml)">
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:text>../</xsl:text>
                  <xsl:choose>
                    <xsl:when test="file[@xml:lang='en' and not(@type='meta')]">
                      <xsl:value-of select="file[@xml:lang='en' and not(@type='meta')]"/>
                    </xsl:when>
                    <xsl:when test="file[@xml:lang=$artlang and not(@type='meta')]">
                      <xsl:value-of select="file[@xml:lang=$artlang and not(@type='meta')]"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>English/</xsl:text>
                      <xsl:value-of select="$issueid"/>
                      <xsl:text>/</xsl:text>
                      <xsl:value-of select="$artid"/>
                      <xsl:text>.shtml</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="title"/>
              </xsl:element> 
              <b> (</b><i>niet vertaald</i><b>)</b>               
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="title"/></xsl:otherwise>
          </xsl:choose>

        </xsl:otherwise>        
      </xsl:choose>
      <xsl:if test="$article/abstract[@xml:lang='nl']">
        <br/><xsl:value-of select="$article/abstract[@xml:lang='nl']"/>
      </xsl:if>
  </li>

</xsl:template>

</xsl:stylesheet>

