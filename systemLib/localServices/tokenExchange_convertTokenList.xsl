<xsl:stylesheet 
  <xsl:template match="tkn:GetTokensByPanReply">
    <tknx:tokens>
      <xsl:apply-templates/>
    </tknx:tokens>  
  </xsl:template>
  <xsl:template match="tkn:token">
    <tknx:token><xsl:value-of select="."/></tknx:token>
  </xsl:template>
</xsl:stylesheet>