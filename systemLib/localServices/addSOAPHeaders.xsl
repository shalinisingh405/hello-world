<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:soap11="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
    
    <!-- Don't use indenting as it could corrupt the signature of some security 
         token, e.g. SAML assertion with signature. -->
    <xsl:output method="xml" indent="no"/>
    
    <xsl:param name="headers" select="self::node()[false()]"/>
    <!--xsl:param name="headers" select="/soap12:Envelope/soap12:Body/*"/-->
    
    <xsl:variable name="soap11" select="'http://schemas.xmlsoap.org/soap/envelope/'"/>
    <xsl:variable name="soap12" select="'http://www.w3.org/2003/05/soap-envelope'"/>
    
    <xsl:template 
        match="/*[translate(local-name(),'ENVELOPE','envelope') = 'envelope' and 
        (namespace-uri() = 'http://schemas.xmlsoap.org/soap/envelope/' or 
         namespace-uri() = 'http://www.w3.org/2003/05/soap-envelope')]">
        
        <xsl:variable name="header" 
            select="./*[translate(local-name(),'HEADER','header') = 'header' 
            and (namespace-uri() = $soap11 or namespace-uri() = $soap12)]"/>
        
        <xsl:copy>
            <xsl:element name="Header" namespace="{namespace-uri(.)}">
                <xsl:apply-templates select="$header/@*|$header/node()"/>                
                <xsl:copy-of select="$headers"/>
            </xsl:element>
            <xsl:apply-templates select="@*[translate(local-name(),'HEADER','header') != 'header']|node()[translate(local-name(),'HEADER','header') != 'header']"/>                
        </xsl:copy>                
    </xsl:template>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
