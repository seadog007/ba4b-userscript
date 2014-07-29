libs = 
  $ : jQuery

Downloader = require "util/downloader.coffee"
config = require "config.js"
ImageChanger = require "view/image_replacer.coffee"

###
list format
{
  "list": 
    [
      {
        "BAHA_ID": "pcchou",
        "HASHED_MAIL": "7ab6825f7735466f759547d3c78902e6"
      },
      {
        "BAHA_ID": "seadog007",
        "HASHED_MAIL": "d41d8cd98f00b204e9800998ecf8427e"
      }
    ]
}
###

main = ($)->
  downloader = new Downloader
  imageChanger = new ImageChanger $
  cacheList = {}
  downloader.responseType = "json"
  
  downloader.on "success", (obj)->
    imageChanger.change obj.list
    cacheList = obj.list
    return true
  downloader.download config.path
  

if window is window.top
  main libs.$
