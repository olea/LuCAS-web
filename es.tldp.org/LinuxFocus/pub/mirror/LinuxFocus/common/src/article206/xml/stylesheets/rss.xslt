<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="ISO-8859-1"/>

<xsl:variable name="englishdb" select="document('../db/lfdb.en.xml')"/>
<xsl:variable name="localdb" select="document('../db/lfdb.en.xml')"/>

<xsl:variable name="version" select="0.2"/>

<xsl:template match="/">
  <rdf:RDF
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns="http://purl.org/rss/1.0/"
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:syn="http://purl.org/rss/1.0/modules/syndication/"
  >
 
  <channel rdf:about="http://www.linuxfocus.org/Nederlands/">
    <title>LinuxFocus - NL</title>
    <link>http://www.linuxfocus.org/Nederlands/</link>
    <description>Nederlandstalige ezine over Linux</description>
    <dc:language>nl</dc:language>
    <dc:date>2001-05-11, 19:51</dc:date>
    <items>
      <rdf:Seq>
  <xsl:for-each select="/database/articles//article">
    <xsl:sort select="translation/finished" order="descending"/>
    <xsl:if test="position() &lt;= 10">
      <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
      <xsl:element name="rdf:li">
        <xsl:attribute name="rdf:resource">http://www.linuxfocus.org/Nederlands/<xsl:value-of select="$englishdb/database/articles/article[@id=$id]/issueref/@href"/>/<xsl:value-of select="@id"/>.shtml</xsl:attribute>
      </xsl:element>
    </xsl:if>
  </xsl:for-each>
      </rdf:Seq>
    </items>
  </channel>

  <xsl:for-each select="/database/articles//article">
    <xsl:sort select="translation/finished" order="descending"/>
    <xsl:if test="position() &lt;= 10">
      <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
      <xsl:variable name="link">http://www.linuxfocus.org/Nederlands/<xsl:value-of select="$englishdb/database/articles/article[@id=$id]/issueref/@href"/>/<xsl:value-of select="@id"/>.shtml</xsl:variable>
      <xsl:element name="item">
        <xsl:attribute name="rdf:about">
          <xsl:value-of select="$link"/>
        </xsl:attribute>
        <title>LinuxFocus, nieuw vertaald: <xsl:value-of select="title[@xml:lang='nl']"/></title>
        <link><xsl:value-of select="$link"/></link>
        <xsl:if test="abstract[@xml:lang='nl']">
          <description><xsl:value-of select="abstract[@xml:lang='nl']"/></description>
        </xsl:if>
      </xsl:element>
    </xsl:if>
  </xsl:for-each>


</rdf:RDF>
</xsl:template>

</xsl:stylesheet>
