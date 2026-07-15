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
        <!-- groups acts by fond -->
        <xsl:for-each-group select="hml/records/record[type/text()='Act']" group-by="tokenize(title, ', ')[3]">

            <!-- build filesystem-safe version of the fond id for the filename -->
            <xsl:variable name="safe-fond">
                <xsl:choose>
                    <xsl:when test="normalize-space(current-grouping-key()) != ''">
                        <xsl:value-of select="translate(normalize-space(current-grouping-key()), ' /\:', '____')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>unknown-fond</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:result-document href="{concat('fonds/', $safe-fond, '.xml')}" method="xml" indent="yes">
                <cei:cei>
                    <cei:teiHeader>
                        <cei:fileDesc>
                            <cei:titleStmt>
                                <cei:title><xsl:value-of select="current-grouping-key()"/></cei:title>
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
                            <!-- apply all acts belonging to this fond -->
                            <xsl:apply-templates select="current-group()"/>
                        </cei:group>
                    </cei:text>
                </cei:cei>
            </xsl:result-document>
        </xsl:for-each-group>
        
        <xsl:result-document href="{'fonds/guerin.xml'}" method="xml" indent="yes">
                <cei:cei>
                    <cei:teiHeader>
                        <cei:fileDesc>
                            <cei:titleStmt>
                                <cei:title>Guerin Edition</cei:title>
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
                            <xsl:apply-templates select="hml/records/record[type/text()='Act' and detail[@conceptID='1624-1336'] and detail[@conceptID='1624-1318']]" mode='guerin'/>
                        </cei:group>
                    </cei:text>
                </cei:cei>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match='record[type/text()="Act"]'>

        <xsl:variable name="idno" select="id/text()"/>
        <xsl:variable name="charter-img" select="$image-zones[detail[@conceptID='1624-1121']/text() = $idno]"/>

        <cei:text type="charter">
            <cei:body>
                <xsl:apply-templates select="id"/>
                <cei:chDesc>
                    <cei:issued>
                        <xsl:apply-templates select="detail[@conceptID='2-9']"/>
                    </cei:issued>
                    <!--regular abstract-->
                    <xsl:apply-templates select="detail[@conceptID='1624-1113'] | detail[@conceptID='1624-1338']"/>
                    <xsl:apply-templates select="detail[@conceptID='1624-1112']"/>
                    <cei:witnessOrig>
                        <xsl:apply-templates select="title"/>
                        <cei:figure>
                            <cei:graphic>
                                <xsl:value-of select="$charter-img/detail[@conceptID='1624-1122']/file/url/text()"/>
                            </cei:graphic>
                        </cei:figure>
                    </cei:witnessOrig>
                </cei:chDesc>
                <cei:tenor>
                    <xsl:value-of select="$charter-img/detail[@conceptID='2-964']/text()"/>
                </cei:tenor>
            </cei:body>
        </cei:text>
    </xsl:template>
    
    <xsl:template match="record[type/text()='Act']" mode="guerin">
        
        <xsl:variable name="idno" select="id/text()"/>
        <xsl:variable name="charter-img" select="$image-zones[detail[@conceptID='1624-1121']/text() = $idno]"/>
        
        <cei:text type="charter">
            <cei:body>
                <xsl:apply-templates select="id"/>
                <cei:chDesc>
                    <cei:issued>
                        <xsl:apply-templates select="detail[@conceptID='2-9']"/>
                    </cei:issued>
                    <!-- guerin abstract -->
                    <xsl:apply-templates select="detail[@conceptID='1624-1318']"/>
                    <!--<xsl:apply-templates select="detail[@conceptID='1624-1112']"/>-->
                    <!--<cei:witnessOrig>
                        <xsl:apply-templates select="title"/>
                    </cei:witnessOrig>-->
                </cei:chDesc>
                <cei:tenor>
                    <!--guerin transcript-->
                    <xsl:apply-templates select="detail[@conceptID='1624-1336']"/>
                </cei:tenor>
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
        <cei:idno>
            <xsl:text>Teklia Arkindex: </xsl:text>
            <xsl:apply-templates/>
        </cei:idno>
    </xsl:template>
    
    <xsl:template match="detail[@conceptID='1624-1114']">
        <cei:idno>
            <xsl:text>Inventory reference: </xsl:text>
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
                    <xsl:variable name="zeromonth" select="concat('0', month/text())"/>
                    <xsl:value-of select="substring($zeromonth, string-length($zeromonth)-1, string-length($zeromonth))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>99</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="day">
            <xsl:choose>
                <xsl:when test="day/text()">
                    <xsl:variable name="zeroday" select="concat('0', day/text())"/>
                    <xsl:value-of select="substring($zeroday, string-length($zeroday)-1, string-length($zeroday))"/>
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
        <xsl:variable name="from" select="substring(concat(replace(temporal/date[1]/raw/normalize-space(), '-', ''), '99999999'), 1, 8)"/>
        <xsl:variable name="to" select="substring(concat(replace(temporal/date[2]/raw/normalize-space(), '-', ''), '99999999'), 1, 8)"/>
        <cei:dateRange from="{$from}" to="{$to}">
            <xsl:value-of select="concat(temporal/date[1]/raw, ' - ', temporal/date[2]/raw)"/>
        </cei:dateRange>
    </xsl:template>
    
</xsl:stylesheet>