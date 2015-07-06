<xsl:stylesheet   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:sql="urn:soae.intel.com/sql"   xmlns:tknx="http://www.intel.com/soae/localServices/tokenExchange-2010a/actions"  xmlns:tkn="urn:pcidss.tokenbroker.esg.intel.com"  version="1.0">
  <xsl:template match="tkn:GetTokensByPanReply">
    <tknx:tokens>
      <xsl:apply-templates/>
    </tknx:tokens>  
  </xsl:template>
  <xsl:template match="tkn:token">
    <tknx:token><xsl:value-of select="."/></tknx:token>
  </xsl:template>
</xsl:stylesheet>
