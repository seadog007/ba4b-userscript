unsafe = unsafeWindow
canvasHelper = require './canvashelper.coffee'
{EventEmitter} = require 'events'
class Deferer extends EventEmitter
  constructor: ->
    @all = 0
    @counted = 0
  add: ->
    @all++
  count: ->
    @counted++
    @emit 'progress', 
      all : @all
      fired : @counted
    if @counted is @all
      @emit 'done'

class ImageCreater extends EventEmitter
  constructor : (@Deferer = Deferer) ->
    @locked = false
  create : (urls) ->
    if @locked is true
      console.log 'incorrect invoke'
      return false
    @locked = true
    console.log 'image create start'
    @deferer = new @Deferer
    for url in urls
      imgElement = document.createElement "img"
      imgElement.crossOrigin = 'anonymous'
      imgElement.src = url.url
      url.image = imgElement
      @deferer.add()
      imgElement.addEventListener 'load', =>
        @deferer.count()
        return true
      
    @deferer.on 'done', =>
      @emit 'done', urls
      @deferer.removeAllListeners 'done'
      @deferer = null
      @removeAllListeners 'done'
      @locked = false
      return true
    return true

class UrlCreater extends EventEmitter
  constructor: (@Imagecreater = ImageCreater)->
    @locked = false
    @urlMap = null
    @urlList = null
    @imagecreater = null
  create : (list)->
  
    console.log 'create start'
    if @locked is true
      console.log 'incorrect invoke'
      return false
    @locked = true
    @urlMap = {}
    @urlList = []
    @imagecreater = new @Imagecreater
    
    for item in list
      @urlMap[item.BAHA_ID] = {}
      @urlMap[item.BAHA_ID]['head'] = "http:\/\/www.gravatar.com\/avatar\/#{item.HASHED_MAIL}?s=40"
      @urlList.push 
        id : item.BAHA_ID,
        url : "http:\/\/www.gravatar.com\/avatar\/#{item.HASHED_MAIL}?s=110"
    
    @imagecreater.on 'done', (urls)=>
      for url in urls
        canvas = document.createElement "canvas"
        canvas.width = 110
        canvas.height = 160
        ctx = canvas.getContext '2d'
        canvasHelper.drawImage url.image, ctx,
          xPaintArea : 110
          yPaintArea : 160
        
        @urlMap[url.id]['full'] = canvas.toDataURL 'image/png'
      
      @emit 'done', @urlMap
      
      @removeAllListeners 'done'
      @locked = false
      @imagecreater = null
      @urlList = null
      
      return false
    @imagecreater.create @urlList

module.exports = UrlCreater