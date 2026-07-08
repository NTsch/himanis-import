<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="https://heuristnetwork.org"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
   
   <xsl:template match="/">
      <TEI xmlns="http://www.tei-c.org/ns/1.0">
         <xsl:apply-templates select='hml/records'/>
      </TEI>
   </xsl:template>
   
   <xsl:template match="records">
      <teiHeader>
         <fileDesc>
            <titleStmt>
               <title>Title</title>
            </titleStmt>
            <publicationStmt>
               <p>Publication Information</p>
            </publicationStmt>
            <sourceDesc>
               <p>Information about the source</p>
            </sourceDesc>
         </fileDesc>
      </teiHeader>
      <text>
         <body>
            <listPerson>
               <xsl:apply-templates select="record[detail[@conceptID='1624-1337'] and type[text() = 'Person']]"/>
            </listPerson>
         </body>
      </text>
   </xsl:template>
   
   <xsl:template match="record[detail[@conceptID='1624-1337'] and type[text() = 'Person']]">
      <person xml:id="{detail[@conceptID='1624-1337']/text()}">
         <persName>
            <xsl:apply-templates select="detail[@conceptID='2-1']"/>
            <xsl:apply-templates select="detail[@conceptID='3-1009']"/>
         </persName>
         <xsl:apply-templates select="*[not(@conceptID='2-1' or @conceptID='3-1009')]"/>
      </person>
   </xsl:template>
   
   <xsl:template match="detail[@conceptID='2-1']">
      <name>
         <xsl:apply-templates/>
      </name>
   </xsl:template>
   
   <xsl:template match="detail[@conceptID='3-1009']">
      <name>
         <xsl:apply-templates/>
      </name>
   </xsl:template>
   
   <xsl:template match="detail[@conceptID='2-3']">
      <note>
         <xsl:apply-templates/>
      </note>
   </xsl:template>
   
   <xsl:template match="url">
      <bibl>
         <xsl:apply-templates/>
      </bibl>
   </xsl:template>
   
   <xsl:template match="citeAs">
      <bibl>
         <xsl:apply-templates/>
      </bibl>
   </xsl:template>
   
   <xsl:template match="id"/>
   
   <xsl:template match="title"/>
   
   <xsl:template match="type"/>
   
   <xsl:template match="added"/>
   
   <xsl:template match="modified"/>
   
   <xsl:template match="workgroup"/>
   
   <xsl:template match="detail[@conceptID='1624-1337']"/>
    
</xsl:stylesheet>