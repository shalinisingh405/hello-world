<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.intel.com/soae/protocolMetadata-2007a.xsd" xmlns:md="http://www.intel.com/soae/protocolMetadata-2007a.xsd" xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing" exclude-result-prefixes="md wsa">
	<xsl:template match="md:protocol">
		<protocol>ftp</protocol>
	</xsl:template>
	<xsl:template match="wsa:EndpointReference">
		<xsl:comment>wsa:EndpointReference removed</xsl:comment>
	</xsl:template>
	<xsl:template match="md:sftpMessage">
		<ftpMessage>
			<xsl:apply-templates/>
		</ftpMessage>
	</xsl:template>
	<xsl:template match="md:sftpMessage/md:transport">
		<transport>
			<xsl:if test="md:command">
				<xsl:choose>
					<xsl:when test="md:command/md:login">
						<user>
							<xsl:value-of select="md:command/md:login/md:user/text()"/>
						</user>
						<password>
							<xsl:value-of select="md:command/md:login/md:password/text()"/>
						</password>
						<xsl:call-template name="ftpCommandElement">
							<xsl:with-param name="name">LOGIN</xsl:with-param>
							<xsl:with-param name="sessionId" select="md:command/@sessionid"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="md:command/md:quit">
						<xsl:call-template name="ftpCommandElement">
							<xsl:with-param name="name">QUIT</xsl:with-param>
							<xsl:with-param name="sessionId" select="md:command/@sessionid"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="md:command/md:cd">
						<xsl:call-template name="ftpCommandElement">
							<xsl:with-param name="name">CWD</xsl:with-param>
							<xsl:with-param name="arg" select="md:command/md:cd/@path"/>
							<xsl:with-param name="sessionId" select="md:command/@sessionid"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="md:command/md:get">
						<xsl:call-template name="ftpCommandElement">
							<xsl:with-param name="name">RETR</xsl:with-param>
							<xsl:with-param name="arg" select="md:command/md:get/@path"/>
							<xsl:with-param name="sessionId" select="md:command/@sessionid"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="md:command/md:ls">
						<xsl:call-template name="ftpCommandElement">
							<xsl:with-param name="name">LIST</xsl:with-param>
							<xsl:with-param name="arg" select="md:command/md:ls/@path"/>
							<xsl:with-param name="sessionId" select="md:command/@sessionid"/>
							<xsl:with-param name="respondInXML">true</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="md:command/md:mkdir">
						<xsl:call-template name="ftpCommandElement">
							<xsl:with-param name="name">MKD</xsl:with-param>
							<xsl:with-param name="arg" select="md:command/md:mkdir/@path"/>
							<xsl:with-param name="sessionId" select="md:command/@sessionid"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="md:command/md:put">
						<xsl:call-template name="ftpCommandElement">
							<xsl:with-param name="name">STOR</xsl:with-param>
							<xsl:with-param name="arg" select="md:command/md:put/@path"/>
							<xsl:with-param name="sessionId" select="md:command/@sessionid"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="md:command/md:pwd">
						<xsl:call-template name="ftpCommandElement">
							<xsl:with-param name="name">PWD</xsl:with-param>
							<xsl:with-param name="sessionId" select="md:command/@sessionid"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="md:command/md:realpath">
						<xsl:call-template name="ftpCommandElement">
							<xsl:with-param name="name">REALPATH</xsl:with-param>
							<xsl:with-param name="arg" select="md:command/md:realpath/@path"/>
							<xsl:with-param name="sessionId" select="md:command/@sessionid"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="md:command/md:rename">
						<xsl:call-template name="ftpCommandElement">
							<xsl:with-param name="name">RENAME</xsl:with-param>
							<xsl:with-param name="arg" select="md:command/md:rename/@path"/>
							<xsl:with-param name="arg2" select="md:command/md:rename/@newPath"/>
							<xsl:with-param name="sessionId" select="md:command/@sessionid"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="md:command/md:rm">
						<xsl:call-template name="ftpCommandElement">
							<xsl:with-param name="name">DELE</xsl:with-param>
							<xsl:with-param name="arg" select="md:command/md:rm/@path"/>
							<xsl:with-param name="lenient">true</xsl:with-param>
							<xsl:with-param name="sessionId" select="md:command/@sessionid"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="md:command/md:stat">
						<xsl:call-template name="ftpCommandElement">
							<xsl:with-param name="name">STAT</xsl:with-param>
							<xsl:with-param name="arg" select="md:command/md:stat/@path"/>
							<xsl:with-param name="sessionId" select="md:command/@sessionid"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:message terminate="yes">SFTP Command <xsl:value-of select="name(md:command/*)"/> cannot be proxied to FTP.
						</xsl:message>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</transport>
	</xsl:template>
	<xsl:template name="ftpCommandElement">
		<xsl:param name="name"/>
		<xsl:param name="arg"/>
		<xsl:param name="arg2"/>
		<xsl:param name="sessionId"/>
		<xsl:param name="respondInXML"/>
		<xsl:param name="lenient"/>
		<command>
			<xsl:if test="$respondInXML">
				<xsl:attribute name="respondInXML"><xsl:value-of select="$respondInXML"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="$lenient">
				<xsl:attribute name="lenient"><xsl:value-of select="$lenient"/></xsl:attribute>
			</xsl:if>
			<name>
				<xsl:value-of select="$name"/>
			</name>
			<xsl:if test="$arg">
				<arg>
					<xsl:value-of select="$arg"/>
				</arg>
			</xsl:if>
			<xsl:if test="$arg2">
				<arg>
					<xsl:value-of select="$arg2"/>
				</arg>
			</xsl:if>
			<sessionId>
				<xsl:value-of select="$sessionId"/>
			</sessionId>
		</command>
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
