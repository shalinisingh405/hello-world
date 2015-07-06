<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:md="http://www.intel.com/soae/protocolMetadata-2007a.xsd" version="1.0">

    <xsl:output method="xml" indent="yes"/>

    <xsl:param name="augDoc"/>

    <!-- Compares header nodes and returns 'true' for nodes only if name attribute values are equal. -->
    <xsl:template name="equalHeaders">
        <xsl:param name="node1"/>
        <xsl:param name="node2"/>

        <xsl:choose>
            <xsl:when
                test="
            local-name($node1)=local-name($node2) and 
            namespace-uri($node1) = namespace-uri($node2) and 
            local-name($node1)='header' and 
            namespace-uri($node1)='http://www.intel.com/soae/protocolMetadata-2007a.xsd' and 
            $node1/@name=$node2/@name"
                >true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!-- Returns 'true' if element schema allows multiple child occurences -->
    <xsl:template name="isMultipleChildOccurrence">
        <xsl:param name="node"/>
        <xsl:choose>
            <xsl:when
                test="local-name($node)='headers' and 
             namespace-uri($node)='http://www.intel.com/soae/protocolMetadata-2007a.xsd'"
                >true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!-- Compares all child nodes of Headers with 'header' node. -->
    <xsl:template name="equalHeaderExists">
        <xsl:param name="header"/>
        <xsl:param name="headers"/>

        <xsl:for-each select="$headers/child::*">
            <xsl:variable name="test">
                <xsl:call-template name="equalHeaders">
                    <xsl:with-param name="node1" select="."/>
                    <xsl:with-param name="node2" select="$header"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:if test="contains($test, 'true')"> true </xsl:if>
        </xsl:for-each>

    </xsl:template>

    <!-- Merges template node with user's node recursively -->
    <xsl:template name="merge-nodeset">

        <xsl:param name="augment_doc"/>

        <!-- xsl:message>Merging nodeset <xsl:value-of select="name(.)"/></xsl:message -->

        <xsl:variable name="isMultipleChildOccurrence">
            <xsl:call-template name="isMultipleChildOccurrence">
                <xsl:with-param name="node" select="."/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:message>start element '<xsl:value-of select="name(.)"/>', aug='<xsl:value-of select="name($augment_doc)"/>'</xsl:message>

        <xsl:choose>

            <!-- Augment has no the same node -->
            <xsl:when test="count($augment_doc)=0">

                <xsl:copy-of select="."/>

            </xsl:when>

            <!-- md:Headers's children should be merged  -->
            <xsl:when test="contains($isMultipleChildOccurrence, 'true')">

                <xsl:message>Starting element '<xsl:value-of select="name(.)"/>'</xsl:message>
                <xsl:copy>

                    <!-- Copy both nodesets comparing nodes-->

                    <xsl:for-each select="$augment_doc/child::*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>

                    <xsl:for-each select="child::*">
                        <xsl:variable name="equal">
                            <xsl:call-template name="equalHeaderExists">
                                <xsl:with-param name="header" select="."/>
                                <xsl:with-param name="headers" select="$augment_doc"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:if test="contains($equal, 'true')=false">
                            <xsl:copy-of select="."/>
                        </xsl:if>
                    </xsl:for-each>

                    <xsl:message>end of element '<xsl:value-of select="name(.)"/>'</xsl:message>
                </xsl:copy>

            </xsl:when>

            <!-- Augment has the same node and it is a leaf -->
            <xsl:when test="count($augment_doc/child::*)=0">

                <xsl:copy-of select="$augment_doc"/>

            </xsl:when>

            <!-- Call the merge nodeset for every child and every attribute -->
            <xsl:otherwise>
                
                <xsl:copy>

                    <!-- copy all attributes -->
                    <xsl:for-each select="attribute::*">
                        <xsl:copy/>
                    </xsl:for-each>

                    <!-- copy all children -->
                    <xsl:for-each select="child::*">
                        <xsl:variable name="childName" select="name(.)"/>
                        <xsl:call-template name="merge-nodeset">                            
                            <xsl:with-param name="augment_doc"
                                select="$augment_doc/child::*[name()=$childName]"/>
                        </xsl:call-template>
                    </xsl:for-each>

                    <xsl:message>end of element <xsl:value-of select="name(.)"/></xsl:message>
                </xsl:copy>

            </xsl:otherwise>

        </xsl:choose>
    </xsl:template>

    <!-- Calls merge-node for every node recursively -->
    <xsl:template match="/">
        <xsl:for-each select="child::*">
            <xsl:call-template name="merge-nodeset">
                <xsl:with-param name="augment_doc" select="$augDoc/child::*[name()=name(.)]"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

</xsl:transform>
