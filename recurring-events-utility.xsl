<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:date="http://exslt.org/dates-and-times" extension-element-prefixes="date">
        
        
        <!-- 
            # Author: Brian Zerangue
            # Created: August 24, 2013
            # Title: Recurring Date List Utility
            # Special Thanks to @phoque (Nils Werner) for helping me figure this out. 
            -->
        
        
        <!-- 
            
        RECURRING DATES LIST UTILITY
        
        EXAMPLE ON HOW TO APPLY THE UTILITY
            
        <ul>
            <xsl:call-template name="date-recursion">
                <xsl:with-param name="repeat" select="recurring-number"/>
                <xsl:with-param name="type" select="recurring-type"></xsl:with-param>
                <xsl:with-param name="start-date" select="date"/>
                <xsl:with-param name="end-date" select="end-date"/>
            </xsl:call-template>
        </ul> 
        -->
    
    <xsl:template name="date-recursion">
        <xsl:param name="repeat"/>
        <xsl:param name="count" select="0"/>
        <xsl:param name="type">
            <xsl:choose>
                <xsl:when test="'weeks'"><xsl:value-of select="concat($repeat*7,'D')"/></xsl:when>
                <xsl:when test="'months'">M</xsl:when>
                <xsl:when test="'years'">Y</xsl:when>
                <!-- Defaults to days -->
                <xsl:otherwise>D</xsl:otherwise>
            </xsl:choose>
        </xsl:param>
        <xsl:param name="start-date"/>
        <xsl:param name="end-date"/>
        
        <xsl:param name="date-diff">
            <xsl:value-of select="date:difference($start-date,$end-date)"/>
        </xsl:param>
        
        <xsl:param name="date-diff-days">
            <xsl:value-of select="translate($date-diff,'PYMD','')"/>
        </xsl:param>
        
        <xsl:param name="date-diff-by-type">
            <xsl:choose>
                <xsl:when test="$type='days'">
                    <xsl:value-of select="$date-diff-days"/>
                </xsl:when>
                <xsl:when test="$type='weeks'">
                    <xsl:value-of select="$date-diff-days div 7"/>
                </xsl:when>
                <xsl:when test="$type='months'">
                    <xsl:choose>
                        <xsl:when test="substring($start-date,6,2)='01'">
                            <xsl:value-of select="$date-diff-days div 31"/>
                        </xsl:when>
                        <xsl:when test="substring($start-date,6,2)='02'">
                            <xsl:choose>
                                <xsl:when test="date:leap-year($start-date)">
                                    <xsl:value-of select="$date-diff-days div 29"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$date-diff-days div 28"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="substring($start-date,6,2)='03'">
                            <xsl:value-of select="$date-diff-days div 31"/>
                        </xsl:when>
                        <xsl:when test="substring($start-date,6,2)='04'">
                            <xsl:value-of select="$date-diff-days div 30"/>
                        </xsl:when>
                        <xsl:when test="substring($start-date,6,2)='05'">
                            <xsl:value-of select="$date-diff-days div 31"/>
                        </xsl:when>
                        <xsl:when test="substring($start-date,6,2)='06'">
                            <xsl:value-of select="$date-diff-days div 30"/>
                        </xsl:when>
                        <xsl:when test="substring($start-date,6,2)='07'">
                            <xsl:value-of select="$date-diff-days div 31"/>
                        </xsl:when>
                        <xsl:when test="substring($start-date,6,2)='08'">
                            <xsl:value-of select="$date-diff-days div 31"/>
                        </xsl:when>
                        <xsl:when test="substring($start-date,6,2)='09'">
                            <xsl:value-of select="$date-diff-days div 30"/>
                        </xsl:when>
                        <xsl:when test="substring($start-date,6,2)='10'">
                            <xsl:value-of select="$date-diff-days div 31"/>
                        </xsl:when>
                        <xsl:when test="substring($start-date,6,2)='11'">
                            <xsl:value-of select="$date-diff-days div 30"/>
                        </xsl:when>
                        <xsl:when test="substring($start-date,6,2)='12'">
                            <xsl:value-of select="$date-diff-days div 31"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$type='years'">
                    <xsl:choose>
                        <xsl:when test="date:leap-year($start-date)">
                            <xsl:value-of select="$date-diff-days div 366"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$date-diff-days div 365"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>
        </xsl:param>
        
        <xsl:if test="$count &lt;= $date-diff-by-type">
            <li>
                <xsl:choose>
                    <xsl:when test="$type='days'">
                        <xsl:value-of select="date:add($start-date,concat('P',$count,'D'))"/>
                    </xsl:when>
                    <xsl:when test="$type='weeks'">
                        <xsl:value-of select="date:add($start-date,concat('P',$count*7,'D'))"/>
                    </xsl:when>
                    <xsl:when test="$type='months'">
                        <xsl:value-of select="date:add($start-date,concat('P',$count,'M'))"/>
                    </xsl:when>
                    <xsl:when test="$type='years'">
                        <xsl:value-of select="date:add($start-date,concat('P',$count,'Y'))"/>
                    </xsl:when>
                </xsl:choose>
            </li>
            <xsl:call-template name="date-recursion">
                <xsl:with-param name="repeat" select="$repeat"/>
                <xsl:with-param name="count" select="$count + $repeat"/>
                <xsl:with-param name="type" select="$type"/>
                <xsl:with-param name="start-date" select="$start-date"/>
                <xsl:with-param name="end-date" select="$end-date"/>
            </xsl:call-template>
        </xsl:if>
        
    </xsl:template>
    
</xsl:stylesheet>
