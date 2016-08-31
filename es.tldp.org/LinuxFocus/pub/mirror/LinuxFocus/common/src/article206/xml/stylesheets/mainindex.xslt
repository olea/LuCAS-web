<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" encoding="ISO-8859-1"/>

<xsl:variable name="persondb" select="document('../db/lfdb.persons.xml')"/>
<xsl:variable name="englishdb" select="document('../db/lfdb.en.xml')"/>
<xsl:variable name="localdb" select="document('../db/lfdb.nl.xml')"/>

<xsl:variable name="version" select="'0.3'"/>
<xsl:variable name="stylesheetname" select="'mainindex.xslt'"/>
<xsl:variable name="lfroot" select="''"/>

<xsl:include href="header.nl.xslt"/>

<xsl:template match="/">
<html>
  <head>
    <title>LinuxFocus - Nederlandse Mainindex</title>
  </head>
<body bgcolor="#ffffff" text="#000000" alink="#336633" link="#336699">

<xsl:call-template name="header"/>

<H1>LinuxFocus Overzicht</H1>
<P>Dit is een overzicht van alle LinuxFocus artikels. Artikels die al
vertaald zijn, hebben een witte achtergrond. Een grijze achtergrond
betekent 'nog niet vertaald' en artikels met een blauwe achtergrond
zijn reeds gereserveerd voor vertaling, maar nog niet afgewerkt.</P>

<P><B>U kan <FONT COLOR="#BB1100">LinuxFocus</FONT> helpen!</B>
Als je een artikel ziet dat nog niet vertaald is en
je graag zelf zou vertalen, reserveer het dan voor u door een e-mail te
sturen naar de Nederlandse mailing list op 
<A href="mailto:dutch@linuxfocus.org">dutch@linuxfocus.org</A>.
</P>

<H1>LinuxFocus translators page</H1>

<P>This is an index of all LinuxFocus articles. Already translated
articles are shown with white background. Articles that are grayed
are not translated yet and articles with blue background are reserved
for translation but not yet ready.</P>

<P><B>You can help <FONT COLOR="#BB1100">LinuxFocus</FONT>!</B> 
If you see an article that is not yet 
translated and you would like to translate it then reserve it for
you by sending an e-mail to the person mentioned as maintainer
at the end of this page.</P>

    <table bgcolor="grey">
    <th bgcolor="black">
      <td bgcolor="black"><font color="white">titel</font></td>
      <td bgcolor="black"><font color="white">vertaald?</font></td>
      <td bgcolor="black"><font color="white">gecontroleerd?</font></td>
    </th>
    <xsl:for-each select="database/issues/issue">
      <xsl:sort select="@code" data-type="number" 
                order="descending"/>
        <xsl:apply-templates select="."/>
    </xsl:for-each>
    </table>

<xsl:call-template name="footer"/>
  </body>
</html>
</xsl:template>

<xsl:template match="issue">
  <xsl:param name="issueid"><xsl:value-of select="@id"/></xsl:param>
  <tr bgcolor="black">
    <td colspan="4"><font color="white"><xsl:value-of select="title"/></font></td>
  </tr>
  <xsl:for-each select="$englishdb/database/articles/article/issueref[@href=$issueid]">
    <xsl:sort select="@id" data-type="number" order="descending"/>
    <xsl:variable name="id" select="@id"/>
    <xsl:apply-templates select="..">
        <xsl:with-param name="issueid" select="$issueid"/>
    </xsl:apply-templates>
  </xsl:for-each>
</xsl:template>

<xsl:template match="article">
  <xsl:param name="issueid"/>
  <xsl:variable name="artid"><xsl:value-of select="@id"/></xsl:variable>
  <xsl:variable name="article" select="$localdb/database/articles/article[@id=$artid]"/>
  <xsl:variable name="artlang"><xsl:value-of select="@xml:lang"/></xsl:variable>
  <xsl:element name="tr">
    <xsl:choose>
      <xsl:when test="$article/translation/finished or @xml:lang='nl'">
        <xsl:attribute name="bgcolor">white</xsl:attribute>
      </xsl:when>
      <xsl:when test="$article/translation/reserved">
        <xsl:attribute name="bgcolor">#AAAAFF</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="bgcolor">#C2C2C2</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <td>
      <xsl:value-of select="$artid"/> (<xsl:value-of select="$artlang"/>)
    </td>
    <td>
      <xsl:choose>
        <!-- use this priority list: (modified by FLO : use <file> also in cat. 1 )

             1. Title pages -> a. try <file>
                               b. link to subdir/index.html directly 
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
          <xsl:choose>
            <xsl:when test="not($article/nohtml)">
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
            <xsl:otherwise>
              <xsl:value-of select="$article/title"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <!-- option 2 -->
        <xsl:when test="$article/translation/finished or $artlang='nl'">
          <xsl:choose>
            <xsl:when test="not($article/nohtml)">
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
                <xsl:value-of select="$article/title"/>
              </xsl:element>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$article/title"/></xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="not($article/nometa)">
              (<xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:text>../</xsl:text>
                  <xsl:choose>
                    <xsl:when test="$article/file[@xml:lang='nl' and @type='meta']">
                      <xsl:value-of select="$article/file[@xml:lang='nl' and @type='meta']"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>Nederlands/</xsl:text>
                      <xsl:value-of select="$issueid"/>
                      <xsl:text>/</xsl:text>
                      <xsl:value-of select="$artid"/>
                      <xsl:text>.meta.shtml</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:text>meta</xsl:text>
              </xsl:element>)
            </xsl:when>
            <xsl:otherwise>(no meta)</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <!-- option 3 -->
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
                <xsl:value-of select="title[@xml:lang='en']"/>
              </xsl:element>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="title"/></xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="not(nometa)">
              (<xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:text>../</xsl:text>
                  <xsl:choose>
                    <xsl:when test="file[@xml:lang='en' and @type='meta']">
                      <xsl:value-of select="file[@xml:lang='en' and @type='meta']"/>
                    </xsl:when>
                    <xsl:when test="file[@xml:lang=$artlang and @type='meta']">
                      <xsl:value-of select="file[@xml:lang=$artlang and @type='meta']"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>English/</xsl:text>
                      <xsl:value-of select="$issueid"/>
                      <xsl:text>/</xsl:text>
                      <xsl:value-of select="$artid"/>
                      <xsl:text>.meta.shtml</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:text>meta</xsl:text>
              </xsl:element>)
            </xsl:when>
            <xsl:otherwise>(no meta)</xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>        
      </xsl:choose>
    </td>
    <td>
    <xsl:choose>
      <xsl:when test="$article/translation/finished">
        <font color="black">
        <xsl:choose>
          <xsl:when test="$article/translation[@to='nl']/personref">
            <xsl:apply-templates select="$article/translation/personref"/>
          </xsl:when>
          <xsl:otherwise>
            (de auteur)
          </xsl:otherwise>
        </xsl:choose>
        </font>
      </xsl:when>
      <xsl:when test="$article/translation/reserved">
        <font color="black">
          <xsl:apply-templates select="$article/translation/personref"/>
        </font>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>  
    </td>
    <td>
    <xsl:choose>
      <xsl:when test="$article/translation/proofread/finished">
        <font color="black">
          <xsl:apply-templates select="$article/translation/proofread/personref"/>
        </font>
      </xsl:when>
      <xsl:when test="$article/translation/proofread/reserved">
        <font color="black">
          <xsl:apply-templates select="$article/translation/proofread/personref"/>
        </font>
      </xsl:when>
      <xsl:otherwise>
        <font color="black">
          <xsl:apply-templates select="$article/translation/proofread/personref"/>
        </font>
      </xsl:otherwise>
    </xsl:choose>  
    </td>
  </xsl:element>
</xsl:template>

<xsl:template match="personref">
  <xsl:variable name="code"><xsl:value-of select="@href"/></xsl:variable>
  <xsl:value-of select="$persondb/database/persons/person[@id=$code]/name"/>
</xsl:template>

</xsl:stylesheet>




