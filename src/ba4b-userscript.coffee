libs = 
  $ : jQuery

Downloader = require "util/downloader.coffee"
defaultConfig = require "config.js"
ImageChanger = require "view/image_replacer.coffee"
Storage = require "util/storage.coffee"
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
  downloader.responseType = "json"
  storage = new Storage(GM_getValue, GM_setValue)
  #console.log storage
  #console.log storage.get 'expire'
  #console.log storage.get 'list'
  config = storage.get config, defaultConfig
  
  if (storage.get "list")? and (storage.get 'expire') > Date.now()
    imageChanger.change storage.get("list")
  else
    downloader.on "success", (obj)->
      imageChanger.change obj.list
      
      storage.set 'expire', Date.now() + config.expireTime * 1000
      storage.set 'list', obj.list
      
      return true
    downloader.download config.path
  return true

if window is window.top
  main libs.$
