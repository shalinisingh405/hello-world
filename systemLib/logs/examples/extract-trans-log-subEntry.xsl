<!--
  Simple stylesheet to extract subEntry records of a given type from
  a transaction log file. 

  It does not care whether the top-level element (<log>) has the
  proper namespace or not since it uses only the local-name() for
  comparision.  However, the output will have the proper namespace:

      http://www.intel.com/soae/logSchema-2007a.xsd

  The option command line argument is a list of subEntry names
  separated by spaces (or commas - the separator is not important).

  Output is a well-formed transaction log with only those logEntry
  records that contain the specified subEntry, and only the subEntry
  of the specified type.

  The default is to extract wflDetails subEntry records.

  Command line example 1:

    /opt/scr/bin/napa2 extract-subEntry.xsl trans-log.xml

      Extracts the wflDetails subEntry records.

  Command line example 2:

    /opt/scr/bin/napa2 extract-subEntry.xsl trans-log.xml subEntry="wflDetails,inputServerSummary"

      Extracts the wflDetails and the inputServerSummary subEntry records.

  Also works with xerces-j, but does not work with /opt/scr/bin/napa1cmdd at this time 
  because of the use of a variable in the match expression.

-->

<xsl:stylesheet 
        version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:lg="http://www.intel.com/soae/logSchema-2007a.xsd"
>

<xsl:param name="subEntry" select="'wflDetails'" />

<xsl:output method="xml" omit-xml-declaration="yes" />

<xsl:template match="*[local-name() = 'log']">
   <lg:log>
      <xsl:apply-templates select="*|@*" />
   </lg:log>
</xsl:template>

<xsl:template match="*" >
   <xsl:apply-templates select="*" />
</xsl:template>

<xsl:template match="@*|comment()|text()|processing-instruction()" >
   <xsl:copy-of select="." />
</xsl:template>

<xsl:template match="logEntry[body/subEntry/body/*[contains($subEntry,local-name())]]" >
  <xsl:copy> 
    <xsl:copy-of select="header" />
    <xsl:for-each select="body" >
       <xsl:copy>
          <xsl:for-each select="subEntry[body/*[contains($subEntry,local-name())]]" >
             <xsl:copy-of select="." />
          </xsl:for-each>
       </xsl:copy>
    </xsl:for-each> 
    <xsl:copy-of select="completionTime" />
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>

