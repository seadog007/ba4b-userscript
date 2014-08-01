canvasHelper = require 'canvasHelper.coffee'
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
  create : (blobs) ->
    if @locked is true
      console.log 'incorrect invoke'
      return false
    @locked = true
    console.log 'image create start'
    @deferer = new @Deferer
    for file in blobs
      imgURL = Util.getUrl(file.blob)
      imgElement =  document.createElement "img"
      imgElement.src = imgURL
      file.image = imgElement
      @deferer.add()
      imgElement.addEventListener 'load', =>
        @deferer.count()
        return true
      
    @deferer.on 'done', =>
      @emit 'done', blobs
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
    @imagecreater = null
  create : (list)->
    if @locked is true
      console.log 'incorrect invoke'
      return false
    @locked = true
    @urlMap = {}
    @imagecreater = new @Imagecreater
    for item in in list
      @urlMap[item.BAHA_ID] = {}
      @urlMap[item.BAHA_ID]['head'] = "http:\/\/www.gravatar.com\/avatar\/#{item.HASHED_MAIL}?s=40"
    