<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <xsl:output method="xml" indent="no"/>
   	
	<xsl:template match="/">
	  <base64EncodedStrings>
	    <xsl:apply-templates select="@*|node()"/>
	  </base64EncodedStrings>
	</xsl:template>
    
    <xsl:template match="@*|node()">

        <!-- 
             The standard stylesheet validation tool may falsely report 
             an invalid xpath expression.  This is because it does not
             know about matches() function which is not part of xsl 1.0.
        -->

        <xsl:if test="string-length(.)>=20 and matches(.,'^([a-zA-Z0-9+/=#xA#xD])+$')">
		  <item><xsl:value-of select="."/></item>
        </xsl:if>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:template>
</xsl:stylesheet>
