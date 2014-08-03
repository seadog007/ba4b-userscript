fixCss = """
  .FM-cbox2 > a {
      float: left;
      border-right: 1px solid transparent;
      border-bottom: 1px solid transparent;
      margin-right: 10px;
  }
  .MSG-myavatar {
      float: left;
      margin: 10px 0px 0px 10px;
      border: 2px solid transparent;
  }
  .MSG-box9 .MSG-myavatar {
      float: left;
      margin: 10px 0px 0px 10px;
      border: 2px solid transparent;
  }
"""

class StyleFixer
  constructor: (@$)->
  
  fix: ()->
    styleElement = @$ '<style></style>'
    styleElement.html fixCss
    styleElement.appendTo 'body'


module.exports = StyleFixer