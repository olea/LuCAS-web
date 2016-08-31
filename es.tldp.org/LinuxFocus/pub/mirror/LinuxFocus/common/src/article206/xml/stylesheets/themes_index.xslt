<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" encoding="ISO-8859-1"/>

<xsl:variable name="englishdb" select="document('../db/lfdb.en.xml')"/>
<xsl:variable name="localdb" select="document('../db/lfdb.nl.xml')"/>

<xsl:variable name="version" select="'0.2'"/>
<xsl:variable name="stylesheetname" select="'themes_index.xslt'"/>
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
 
<center><H1>Linux<FONT color="#ff0000">Focus</FONT>Thema's Index</H1></center>
<blockquote>Artkelen die niet vertaald zijn, leiden naar de Engelse versies.</blockquote>

<ul>
  <xsl:for-each select="$englishdb/database/themes/theme">
    <xsl:variable name="id" select="@id"/>
    <xsl:variable name="theme" select="$localdb/database/themes/theme[@id=$id]"/>
    <li>
      <a href="{@id}.html"><xsl:value-of select="$theme/title"/></a>
      <br/>
      <xsl:value-of select="$theme/abstract"/>
    </li>
  </xsl:for-each>
</ul>

<xsl:call-template name="footer"/>

</BODY></HTML>

</xsl:template>

</xsl:stylesheet>

