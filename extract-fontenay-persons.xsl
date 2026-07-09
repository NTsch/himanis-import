<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="https://heuristnetwork.org"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
   
   <xsl:template match="/">
      <tei:TEI>
         <xsl:apply-templates select='hml/records'/>
      </tei:TEI>
   </xsl:template>
   
   <xsl:variable name="relation-records" select="/hml/records/record[type[text() = 'Record relationship']]"/>
   
   <xsl:template match="records">
      <tei:teiHeader>
         <tei:fileDesc>
            <tei:titleStmt>
               <tei:title>Title</tei:title>
            </tei:titleStmt>
            <tei:publicationStmt>
               <tei:p>Publication Information</tei:p>
            </tei:publicationStmt>
            <tei:sourceDesc>
               <tei:p>Information about the source</tei:p>
            </tei:sourceDesc>
         </tei:fileDesc>
      </tei:teiHeader>
      <tei:text>
         <tei:body>
            <tei:listPerson>
               <xsl:apply-templates select="record[detail[@conceptID='1624-1337'] and type[text() = 'Person']]"/>
            </tei:listPerson>
         </tei:body>
      </tei:text>
   </xsl:template>
   
   <xsl:template match="record[detail[@conceptID='1624-1337'] and type[text() = 'Person']]">
      <tei:person xml:id="{id/text()}">
         <tei:persName>
            <xsl:apply-templates select="detail[@conceptID='2-1']"/>
            <xsl:apply-templates select="detail[@conceptID='3-1009']"/>
         </tei:persName>
         <xsl:apply-templates select="*[not(@conceptID='2-1' or @conceptID='3-1009')]"/>
      </tei:person>
      <!--<xsl:call-template name="relations">
         <xsl:with-param name="title" select="title/text()"/>
         <xsl:with-param name="id" select="id/text()"/>
      </xsl:call-template>-->
   </xsl:template>
   
   <xsl:template match="detail[@conceptID='2-1' or @conceptID='3-1009']">
      <xsl:choose>
         <xsl:when test="contains(text(), 'LAT:')">
            <tei:name xml:lang="lat">
               <xsl:value-of select="substring-after(text(), 'LAT:')"/>
            </tei:name>
         </xsl:when>
         <xsl:otherwise>
            <tei:name>
               <xsl:apply-templates/>
            </tei:name>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="detail[@conceptID='2-3']">
      <tei:note>
         <xsl:apply-templates/>
      </tei:note>
   </xsl:template>
   
   <xsl:template match="url">
      <tei:bibl>
         <xsl:apply-templates/>
      </tei:bibl>
   </xsl:template>
   
   <xsl:template match="citeAs">
      <tei:bibl>
         <xsl:apply-templates/>
      </tei:bibl>
   </xsl:template>
   
   <xsl:template match="id"/>
   
   <xsl:template match="title"/>
   
   <xsl:template match="type"/>
   
   <xsl:template match="added"/>
   
   <xsl:template match="modified"/>
   
   <xsl:template match="workgroup"/>
   
   <xsl:template match="detail[@conceptID='1624-1337']"/>
   
   <xsl:template name="relations">
      <xsl:param name="id"/>
      <xsl:param name="title"/>
      <xsl:apply-templates select="$relation-records[detail[@conceptID='2-7']/text() = $id]">
         <xsl:with-param name="title" select="$title"/>
      </xsl:apply-templates>
   </xsl:template>
   
   <xsl:template match="$relation-records">
      <xsl:param name="title"/>
      <xsl:variable name="passive-id" select="detail[@conceptID='2-5']/text()"/>
      <tei:relation name="{detail[@conceptID='2-6']/text()}" active="{$title}" passive="{/hml/records/record[id/text() = $passive-id]/title/text()}"/>
   </xsl:template>
    
</xsl:stylesheet>