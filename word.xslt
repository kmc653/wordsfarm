<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/entry_list">
  <html>
  <body>
  <p><xsl:value-of select="entry[1]/fl"/></p>
  
  <xsl:for-each select="entry[1]/in">
    <span><xsl:value-of select="if"/></span>  
  </xsl:for-each>
  
  <!-- <p><xsl:value-of select="entry/"/></p> -->
  
  </body>
  </html>
</xsl:template>

</xsl:stylesheet>