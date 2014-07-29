class ImageReplacer
  constructor: (jQuery)->
    @$ = jQuery
  
  change: (map)->
    images = @$ "img"
    format = /http:\/\/avatar2.bahamut.com.tw\/avataruserpic\/\w\/\w\/(\w+)\/.*/g
    images = images.filter ()->
      str = this.src
      return format.test str
    images.each ->
      name = format.exec this.src
      name = name[1]
      if name and map[name]
        this.src = map[name]
      return true