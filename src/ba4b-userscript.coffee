$ = (require 'lib/jquery-1.11_1.js').noConflict()
Downloader = require "util/downloader.coffee"
defaultConfig = require "config.js"
ImageChanger = require "view/image_replacer.coffee"
Storage = require "util/storage.coffee"
AjaxHook = require "view/ajax_hook.coffee"

#UrlCreater = require "util/urlcreater.coffee"
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

  ###
main = ($)->
  downloader = new Downloader
  urlCreater = new UrlCreater
  #console.log storage
  #console.log storage.get 'expire'
  #console.log storage.get 'list'
  config = storage.get 'config', defaultConfig
  
  if (storage.get "list")? and (storage.get 'expire') > Date.now()
    imageChanger.change storage.get "list"
    urlCreater.on 'done', (a)->
      console.log a
    urlCreater.create storage.get "list"
  else
    downloader.on "success", (obj)->
      imageChanger.change obj.list
      
      storage.set 'expire', Date.now() + config.expireTime * 1000
      storage.set 'list', obj.list
      
      return true
    downloader.download config.path
  
  hook.on 'ajax', (parent)->
    console.log "update ajax hook!"
    imageChanger.change storage.get "list", parent
  
  setTimeoutR = (a, b)->setTimeout b,a
  setTimeoutR 1000, ()->
    hook.injectHook()
  
  lastTime = Date.now() - config.forceReloadTime * 1000
  forceReload = ()->
    if lastTime + config.forceReloadTime * 1000 > Date.now()
      console.log "reload too often: next Time to reload is #{lastTime + config.forceReloadTime * 1000}, now is #{Date.now()}"
      return true
    downloader.on "success", (obj)->
      imageChanger.change obj.list
      
      storage.set 'expire', Date.now() + config.expireTime * 1000
      storage.set 'list', obj.list
      
      return true
    downloader.download config.path
    lastTime = Date.now()
    
  resetConfig = ()->
    storage.remove 'config'
    config = defaultConfig
  GM_registerMenuCommand "ba4d force reload", forceReload
  GM_registerMenuCommand "ba4d reset config", resetConfig
  
  return true
  ###
class Ba4b
  constructor: (@downloader, @defaultConfig, @imageChanger, @storage, @ajaxHook, @GM_registerMenuCommand)->
    @config = null
    @loadConfig()
    @_init()
  
  _init: ->
    if (@storage.get "list")? and !@isListExpired()
      @changeImage storage.get "list"
    else
      console.log "out date list: #{@storage.get 'expire'} \n now is #{Date.now()}"
      @downloadNewList()
    setTimeoutR = (a, b)-> setTimeout b, a
    setTimeoutR 1000, ()=>
      @ajaxHook.injectHook()
  isListExpired: ->
    return (@storage.get 'expire') < Date.now()
    
  loadConfig: (reset)->
    if reset
      storage.remove 'config'
    @config = storage.get 'config', @defaultConfig
  
  setConfig: (property, value)->
    @config[property] = value
    storage.set 'config', @config
  
  getConfig: (property)->
    (storage.get 'config')[property]
  
  downloadNewList: ()->
    downloader.responseType = 'json'
    downloader.on "success", (obj)=>
    
      @storage.set 'expire', Date.now() + @config.expireTime * 1000
      @storage.set 'list', obj.list
      @imageChanger.change obj.list
      
      return true
    downloader.download @config.path
  
  changeImage: (list, conatiner)->
    if !list?
      list = storage.get 'list'
    imageChanger.change list

if window is window.top
  storage = new Storage GM_getValue, GM_setValue
  downloader = new Downloader
  imageChanger = new ImageChanger $
  hook = new AjaxHook window, $
  
  ba4b = new Ba4b downloader, defaultConfig, imageChanger, storage, hook, GM_registerMenuCommand
  
  triggerAjax = (container)->
    console.log "update ajax call!"
    ba4b.changeImage(container)
  
  resetConfig = ()->
    console.log "reset config!"
    ba4b.loadConfig(true)
  
  redownloadList = ()->
    console.log "redownload list!"
    ba4b.downloadNewList()
  
  setConfig = (prop, val)->
    ba4b.setConfig(prop, val)
  
  getConfig = (prop)->
    ba4b.getConfig(prop)
  
  if cloneInto? && exportFunction?
    try
      unsafeWindow.ba4b = cloneInto {}, unsafeWindow
      exportFunction triggerAjax, unsafeWindow.ba4b, defineAs: "updateImageIn"
      exportFunction resetConfig, unsafeWindow.ba4b, defineAs: "resetConfig"
      exportFunction redownloadList, unsafeWindow.ba4b, defineAs: "redownloadList"
      exportFunction setConfig, unsafeWindow.ba4b, defineAs: "setConfig"
      exportFunction getConfig, unsafeWindow.ba4b, defineAs: "getConfig"
      
    catch
  else
    unsafeWindow.ba4b = 
      updateImageIn : triggerAjax
      resetConfig : resetConfig
      redownloadList : redownloadList
      setConfig : setConfig
      getConfig : getConfig
  
  GM_registerMenuCommand "ba4b : update list now", redownloadList
  GM_registerMenuCommand "ba4b : reset config", resetConfig
  