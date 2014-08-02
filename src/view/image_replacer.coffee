class ImageReplacer
  constructor: (jQuery)->
    @$ = jQuery
  
  change: (map, parent)->
    if parent?
      images = (@$ parent).find 'img'
    else
      images = @$ "img"
    result = false
    images = images.filter ()->
      format = /http:\/\/avatar2\.bahamut\.com\.tw\/avataruserpic\/\w\/\w\/(\w+)\/.*/g
      str = this.src
      return format.test str
    images.each ->
      str = this.src
      name = str.split("/")
      ###
      "I really have no idea why it didn't work"
      if not name
        console.log str, "exec fail?"
        return true
      ###
      name = name[6]
      ###
      for value in list
        if value.BAHA_ID is name
          if str.search("_s") >= 0
            this.src = "http:\/\/www.gravatar.com\/avatar\/#{value.HASHED_MAIL}?s=40"
          else
            this.src = "http:\/\/www.gravatar.com\/avatar\/#{value.HASHED_MAIL}?s=110"
          result = true
          return true
      ###
      
      if map[name]?
        if str.search("_s") >= 0
          this.src = map[name].head
        else
          this.src = map[name].full
      return true
    
    return true


module.exports = ImageReplacer