<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:bpws="http://docs.oasis-open.org/wsbpel/2.0/process/executable"
	xmlns:icap="http://www.intel.com/soae/localService/icap-2010a/"
	xmlns:soae-ab="urn:com.intel.ssg.cbr.ide.actionbuilder"><xsl:output method="text"/><xsl:template match="/registrationInfo">{ 
"access_token_id":"<xsl:value-of select="access_token_id"/>",
"access_expiration_time":"<xsl:value-of select="access_token_expiration_time"/>",
"access_token_scope":"<xsl:value-of select="access_token_scope"/>",
"client_id":"<xsl:value-of select="client_id"/>"<xsl:if test="count(resource_owner)>0">,
"resource_owner":"<xsl:value-of select="resource_owner"/>"</xsl:if>,
"applicationSpecificRegistrationOptions":"<xsl:value-of select="applicationSpecificRegistrationOptions"/>"<xsl:if test="count(redirect_uri)>0">,
"redirect_uri":"<xsl:value-of select="redirect_uri"/>"</xsl:if><xsl:if test="count(refresh_token_id)">,
"refresh_token_id":"<xsl:value-of select="refresh_token_id"/>"</xsl:if><xsl:if test="count(refresh_expiration_time)>0">,
"refresh_expiration_time":"<xsl:value-of select="refresh_expiration_time"/>"</xsl:if><xsl:if test="count(refresh_scope)>0">,
"refresh_scope":"<xsl:value-of select="refresh_scope"/>"</xsl:if>
}</xsl:template>	
</xsl:stylesheet>