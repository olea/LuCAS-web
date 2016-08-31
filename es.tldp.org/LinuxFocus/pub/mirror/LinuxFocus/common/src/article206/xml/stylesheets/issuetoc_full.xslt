<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="current"/>

<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" encoding="ISO-8859-1"/>

<xsl:variable name="englishdb" select="document('../db/lfdb.en.xml')"/>
<xsl:variable name="persondb" select="document('../db/lfdb.persons.xml')"/>
<xsl:variable name="db" select="/"/>

<xsl:variable name="version" select="0.1"/>

<xsl:template match="/">
  <p>
  <center><h3>De Artikelen</h3></center>
  <b>Vertaald</b>
  <ul><xsl:text>  </xsl:text>
  <xsl:for-each select="$englishdb/database/articles/article[issueref/@href=$current]">
    <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
    <xsl:if test="$db/database/articles/article[@id=$id]/translation/finished">
      <xsl:if test="substring($id,1,3)!='cov'">
        <li type="circle"><img src="../../common/images/frame.gif" alt="point" align="middle" />
          <xsl:element name="a">
            <xsl:choose>
              <xsl:when test="$db/database/articles/article[@id=$id]/file[@xml:lang='nl' and not(@type='meta')]">
                <xsl:attribute name="href"><xsl:text>../../</xsl:text>
                  <xsl:value-of select="$db/database/articles/article[@id=$id]/file[@xml:lang='nl']"/>
                </xsl:attribute>
              </xsl:when>
              <xsl:when test="$englishdb/database/articles/article[@id=$id]/file[@xml:lang='en' and not(@type='meta')]">
                <xsl:attribute name="href"><xsl:text>../../</xsl:text>
                  <xsl:value-of select="$englishdb/database/articles/article[@id=$id]/file[@xml:lang='en']"/>
                </xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="href"><xsl:value-of select="$id"/>.shtml</xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="$db/database/articles/article[@id=$id]/title[@xml:lang='nl']"/>
          </xsl:element><xsl:text> , door </xsl:text>
          <xsl:for-each select="personref">
            <xsl:variable name="pid"><xsl:value-of select="@href"/></xsl:variable>
            <xsl:value-of select="$persondb/database/persons/person[@id=$pid]/name"/><xsl:text> </xsl:text>
          </xsl:for-each>
          <xsl:for-each select="themeref">
            <xsl:variable name="th"><xsl:value-of select="@href"/></xsl:variable>
            (<em><xsl:value-of select="$db/database/themes/theme[@id=$th]/title[@xml:lang='nl']"/></em>)
          </xsl:for-each>
          <br /><xsl:value-of select="$db/database/articles/article[@id=$id]/abstract[@xml:lang='nl']"/><br /><br />
        </li>
      </xsl:if>
    </xsl:if>
  </xsl:for-each>
  </ul>
  <p/><b>Onvertaald</b><ul>
  <xsl:for-each select="$englishdb/database/articles/article[issueref/@href=$current]">
    <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
    <xsl:if test="not($db/database/articles/article[@id=$id]/translation/finished)">
      <xsl:if test="substring($id,1,3)!='cov'">
        <li type="circle"><img src="../../common/images/frame.gif" alt="point" align="middle"/>
          <xsl:element name="a">
            <xsl:choose>
              <xsl:when test="$englishdb/database/articles/article[@id=$id]/file[@xml:lang='en' and not(@type='meta')]">
                <xsl:attribute name="href"><xsl:text>../../</xsl:text>
                  <xsl:value-of select="$englishdb/database/articles/article[@id=$id]/file[@xml:lang='en' and not(@type='meta')]"/>
                </xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="href">
                  <xsl:text>../../English/</xsl:text>
                  <xsl:value-of select="$current"/>
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="$id"/>
                  <xsl:text>.shtml</xsl:text>
                </xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="title[@xml:lang='en']"/>
          </xsl:element><xsl:text> , door </xsl:text>
          <xsl:for-each select="personref">
            <xsl:variable name="pid"><xsl:value-of select="@href"/></xsl:variable>
            <xsl:value-of select="$persondb/database/persons/person[@id=$pid]/name"/><xsl:text> </xsl:text>
          </xsl:for-each>
          <xsl:for-each select="themeref">
            <xsl:variable name="th"><xsl:value-of select="@href"/></xsl:variable>
            (<em><xsl:value-of select="$db/database/themes/theme[@id=$th]/title[@xml:lang='nl']"/></em>)
          </xsl:for-each>
          <xsl:choose>
            <xsl:when test="$db/database/articles/article[@id=$id]/abstract[@xml:lang='nl']">
              <br /><xsl:value-of select="$db/database/articles/article[@id=$id]/abstract[@xml:lang='nl']"/><br /><br />
            </xsl:when>
            <xsl:otherwise>
              <br /><xsl:value-of select="abstract"/><br /><br />
            </xsl:otherwise>
          </xsl:choose>
        </li>
      </xsl:if>
    </xsl:if>
  </xsl:for-each>
  </ul>
  </p>
</xsl:template>

</xsl:stylesheet>




