<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"><xsl:output method="text"/><xsl:template match="/*">{ 
"token_id":"<xsl:value-of select="token_id"/>",
"client_id":"<xsl:value-of select="client_id"/>"
}</xsl:template>	
</xsl:stylesheet>