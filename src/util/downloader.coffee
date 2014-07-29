{EventEmitter} = require 'events'

class Downloader extends EventEmitter
  constructor: ()->
    @_cachedURL = []
    @_cache = {}
    @locked = false
    @responseType = ""
  download: (url)->
    if @locked
      console.log 'incorrect invoke'
      return false
    
    if url in @_cachedURL
      @emit 'success', @_cache[url]
      @removeAllListeners 'success'
      return true
    
    @locked = true
    
    console.log 'download start'
    
    GM_xmlhttpRequest
      url : url
      onload : (e)=>
        response = e.responseText
        if @responseType is "json"
          response = JSON.parse response
        
        if (!response)
          @emit 'fail', url
        
        @emit 'success',response
        return true
      onerror : (e)=>
        @emit 'fail', url
        @locked = false
        return true
      method : "GET"
      
    return true

module.exports = Downloader