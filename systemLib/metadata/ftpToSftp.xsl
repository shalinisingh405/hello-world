<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.intel.com/soae/protocolMetadata-2007a.xsd" xmlns:md="http://www.intel.com/soae/protocolMetadata-2007a.xsd" xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing" exclude-result-prefixes="md">
	<xsl:template match="md:protocol">
		<protocol>sftp</protocol>
	</xsl:template>
	<xsl:template match="wsa:EndpointReference">
		<xsl:comment>wsa:EndpointReference removed</xsl:comment>
	</xsl:template>
	<xsl:template match="md:ftpMessage">
		<sftpMessage>
			<xsl:apply-templates/>
		</sftpMessage>
	</xsl:template>
	<xsl:template match="md:transport">
		<transport>
			<xsl:apply-templates select="md:response"/>
		</transport>
	</xsl:template>
	<xsl:template match="md:transport/md:response">
		<reply>
			<xsl:attribute name="sessionid"><xsl:value-of select="@sessionId"/></xsl:attribute>
			<xsl:attribute name="status"><xsl:choose><xsl:when test="number(md:code) &gt;= 200 and number(md:code) &lt;= 299"><!-- SSH_FX_OK -->0</xsl:when><xsl:when test="number(md:code) = 550"><!-- SSH_FX_NO_SUCH_PATH -->10</xsl:when><xsl:otherwise><!-- SSH_FX_FAILURE -->4</xsl:otherwise></xsl:choose></xsl:attribute>
			<xsl:if test="md:message">
				<xsl:attribute name="message"><xsl:value-of select="md:message/text()"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="../md:path">
				<xsl:attribute name="path"><xsl:value-of select="../md:path"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="md:attributes"/>
		</reply>
	</xsl:template>
	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="@*|comment()|text()">
		<xsl:copy/>
	</xsl:template>
</xsl:stylesheet>
