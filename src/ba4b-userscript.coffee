libs = 
  $ : jQuery

Downloader = require "util/downloader.coffee"
config = require "config.js"
ImageChanger = require "view/image_replacer.coffee"


main = ($)->
  downloader = new Downloader
  imageChanger = new ImageChanger $
  cacheMap = {}
  downloader.responseType = "json"
  
  downloader.on "success", (map)->
    imageChanger.change map
    cacheMap = map
    return true
  downloader.download config.path
  

main(libs.$)