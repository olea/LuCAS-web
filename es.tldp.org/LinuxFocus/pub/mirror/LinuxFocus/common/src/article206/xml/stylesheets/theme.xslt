<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="theme"/>
<xsl:param name="localized"/>

<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" encoding="ISO-8859-1"/>

<xsl:variable name="englishdb" select="document('../db/lfdb.en.xml')"/>
<xsl:variable name="localdb" select="document('../db/lfdb.nl.xml')"/>

<xsl:variable name="version" select="'0.2'"/>
<xsl:variable name="stylesheetname" select="'theme.xslt'"/>
<xsl:variable name="lfroot" select="'../'"/>

<xsl:include href="header.nl.xslt"/>

<xsl:template match="/">
<HTML>
<HEAD>
  <META http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
  <TITLE>LinuxFocus Index</TITLE>
</HEAD>
<BODY bgcolor="#ffffff"  text="#000000" alink="#336633" link="#336633" >
 
<xsl:call-template name="header"/>

<xsl:apply-templates select="/database/themes/theme[@id=$theme]"/>

</BODY></HTML>

</xsl:template>

<xsl:template match="theme">
<CENTER>
<h1><xsl:value-of select="title"/></h1>
</CENTER>
<TABLE  align="center" width="75%"  cellspacing="0" cellpadding="15" border="0">
<TR>
<TD>
<xsl:if test="img">
  <IMG src="../../common/images/{img/@src}" alt="[Illustratie]" width="200" height="200"/>
</xsl:if>
</TD>
<TD>
<xsl:value-of select="abstract"/>
</TD>
</TR>
</TABLE>
<HR noshade="noshade" size="2"/>

<ul>
  <xsl:for-each select="$englishdb/database/articles/article[themeref/@href=$theme]">
    <xsl:sort select="@id" data-type="number" order="descending"/>
    <xsl:variable name="artid" select="@id"/>
    <xsl:variable name="article" select="$localdb/database/articles/article[@id=$artid]"/>
    <xsl:variable name="artlang" select="@xml:lang"/>
    <xsl:variable name="issueid" select="issueref/@href"/>
    <xsl:variable name="issue" select="$englishdb/database/issues/issue[@id=$issueid]"/>
    <xsl:if test="$issue/published">
    <li>
      <xsl:choose>
        <!-- use this priority list:

             1. Title pages -> direct to subdir directly 
             2. Translation -> a. check <no[html|meta]>
                               b. try <file> first
                               c. use default
             3. 'Original'  -> a. try english original/translation first:
                                  I.   check <no[html|meta]>
                                  II.  try <file>
                               b. try 'real' original (if applicable)
                                  I.   check <no[html|meta]>
                                  II.  try <file>
                                  III. use default
        
          -->
        
        <!-- option 1 -->
        <xsl:when test="substring(@id,1,3)='cov'">
          <a href="../Nederlands/{$issueid}/index.html"><xsl:value-of select="$article/title"/></a>
        </xsl:when>
        <!-- option 2 -->
        <xsl:when test="$article/translation/finished or $artlang='nl'">
          <xsl:choose>
            <xsl:when test="not($article/nohtml)">
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:text>../../</xsl:text>
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
                <xsl:value-of select="$article/title"/>
              </xsl:element>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$article/title"/></xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <!-- option 3 -->
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="not(nohtml)">
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:text>../../</xsl:text>
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
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="title"/></xsl:otherwise>
          </xsl:choose>
          <b> (</b><I>niet vertaald</I><b>)</b>
        </xsl:otherwise>        
      </xsl:choose>
 
      <br/>
      <xsl:value-of select="$article/abstract"/>
    </li>
    </xsl:if>
  </xsl:for-each>
</ul>

</xsl:template>

</xsl:stylesheet>


