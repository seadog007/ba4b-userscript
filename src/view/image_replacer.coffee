class ImageReplacer
  constructor: (jQuery)->
    @$ = jQuery
  
  change: (list)->
    images = @$ "img"
    result = false
    format = /http:\/\/avatar2.bahamut.com.tw\/avataruserpic\/\w\/\w\/(\w+)\/.*/g
    images = images.filter ()->
      str = this.src
      return format.test str
    images.each ->
      name = format.exec this.src
      name = name[1]
      
      for value in list
        if value.BAHA_ID is name
          if str.search("_s") >= 0
            this.src = "http:\/\/www.gravatar.com\/avatar\/#{value.HASHED_MAIL}?s=40"
          else
            this.src = "http:\/\/www.gravatar.com\/avatar\/#{value.HASHED_MAIL}?s=110"
          result = true
          return false
          
      return true
    return true