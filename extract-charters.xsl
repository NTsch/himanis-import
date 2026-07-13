<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="https://heuristnetwork.org"
    xmlns:cei="http://www.monasterium.net/NS/cei"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <xsl:variable name="image-zones" select="//record[type/text()='Image zone']"/>
    
    <xsl:template match="/">
        <cei:cei>
            <cei:teiHeader>
                <cei:fileDesc>
                    <cei:titleStmt>
                        <cei:title></cei:title>
                        <cei:p></cei:p>
                    </cei:titleStmt>
                    <cei:publicationStmt>
                        <cei:publisher></cei:publisher>
                        <cei:pubPlace></cei:pubPlace>
                    </cei:publicationStmt>
                </cei:fileDesc>
            </cei:teiHeader>
            <cei:text>
                <cei:group>
                    <xsl:apply-templates select='hml/records/record[type/text()="Act"]'/>
                </cei:group>
            </cei:text>
        </cei:cei>
    </xsl:template>
    
    <xsl:template match='record[type/text()="Act"]'>
        <cei:text type="charter">
            <cei:body>
                <xsl:apply-templates select="id"/>
                <cei:chDesc>
                    <xsl:apply-templates select="detail[@conceptID='1624-1113'] | detail[@conceptID='1624-1338']"/>
                    <xsl:apply-templates select="detail[@conceptID='1624-1112']"/>
                    <!--<cei:diplomaticAnalysis>
                        <xsl:apply-templates select="detail[@conceptID='2-3']"/>
                    </cei:diplomaticAnalysis>-->
                </cei:chDesc>
                <cei:witnessOrig>
                    <xsl:apply-templates select="title"/>
                    <xsl:call-template name="images">
                        <xsl:with-param name="id" select="id/text()"/>
                    </xsl:call-template>
                </cei:witnessOrig>
                <cei:issued>
                    <xsl:apply-templates select="detail[@conceptID='2-9']"/>
                </cei:issued>
            </cei:body>
        </cei:text>
    </xsl:template>
    
    <xsl:template match="id">
        <cei:idno id="{text()}">
            <xsl:apply-templates/>
        </cei:idno>
    </xsl:template>
    
    <xsl:template match="detail[@conceptID='1624-1113'] | detail[@conceptID='1624-1338']">
        <cei:abstract>
            <xsl:apply-templates/>
        </cei:abstract>
    </xsl:template>
    
    <xsl:template match="detail[@conceptID='1624-1112']">
        <cei:lang_MOM>
            <xsl:apply-templates/>
        </cei:lang_MOM>
    </xsl:template>
    
    <xsl:template match="detail[@conceptID='1624-1108']">
        <cei:idno type="Teklia Arkindex">
            <xsl:apply-templates/>
        </cei:idno>
    </xsl:template>
    
    <xsl:template match="detail[@conceptID='1624-1114']">
        <cei:idno type="Inventory reference">
            <xsl:apply-templates/>
        </cei:idno>
    </xsl:template>
    
    <xsl:template match="detail[@conceptID='2-3']">
        <cei:p>
            <xsl:apply-templates/>
        </cei:p>
    </xsl:template>
    
    <xsl:template match="title">
        <xsl:variable name="title-parts" select="tokenize(text(), ', ')"/>
        <xsl:variable name="folio">
            <xsl:if test="../detail[@conceptID='1624-1110']">
                <xsl:value-of select="../detail[@conceptID='1624-1110']"/>
            </xsl:if>
            <xsl:if test="../detail[@conceptID='1624-1111']">
                <xsl:value-of select="concat(' - ', ../detail[@conceptID='1624-1111'])"/>
            </xsl:if>
        </xsl:variable>
        <cei:archIdentifier>
            <cei:idno>
                <xsl:choose>
                    <xsl:when test="../detail[@conceptID='1624-1110']">
                        <xsl:value-of select="concat($title-parts[last()], ' (', $folio, ')')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$title-parts[last()]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </cei:idno>
            <cei:archFond>
                <xsl:value-of select="$title-parts[3]"/>
            </cei:archFond>
            <cei:arch>
                <xsl:value-of select="$title-parts[2]"/>
            </cei:arch>
            <cei:settlement>
                <xsl:value-of select="$title-parts[1]"/>
            </cei:settlement>
            <cei:ref>
                <xsl:value-of select="../citeAs/text()"/>
            </cei:ref>
            <xsl:apply-templates select="../detail[@conceptID='1624-1108']"/>
            <xsl:apply-templates select="../detail[@conceptID='1624-1114']"/>
        </cei:archIdentifier>
    </xsl:template>
    
    <xsl:template match="detail[@conceptID='2-9' and not(temporal)]">
        <xsl:variable name="year">
            <xsl:choose>
                <xsl:when test="year/text()">
                    <xsl:value-of select="year/text()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>9999</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="month">
            <xsl:choose>
                <xsl:when test="month/text()">
                    <xsl:value-of select="substring(concat('0', month/text()), -1)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>99</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="day">
            <xsl:choose>
                <xsl:when test="day/text()">
                    <xsl:value-of select="substring(concat('0', day/text()), -1)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>99</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="dateval" select="concat($year, $month, $day)"/>
        <cei:date value="{$dateval}">
            <xsl:value-of select="concat($day, '-', $month, '-', $year)"/>
        </cei:date>
    </xsl:template>
    
    <xsl:template match="detail[@conceptID='2-9' and temporal]">
        <xsl:variable name="from" select="replace(temporal/date[1]/raw/normalize-space(), '-', '')"/>
        <xsl:variable name="to" select="replace(temporal/date[2]/raw/normalize-space(), '-', '')"/>
        <cei:dateRange from="{$from}" to="{$to}">
            <xsl:value-of select="concat(temporal/date[1]/raw, ' - ', temporal/date[2]/raw)"/>
        </cei:dateRange>
    </xsl:template>
    
    <xsl:template name="images">
        <xsl:param name="id"/>
        <cei:figure>
            <xsl:value-of select="$image-zones[detail[@conceptID='1624-1121']/text() = $id]/id/text()"/>
        </cei:figure>
    </xsl:template>
    
</xsl:stylesheet>