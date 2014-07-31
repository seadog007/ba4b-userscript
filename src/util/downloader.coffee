{EventEmitter} = require 'events'

class Downloader extends EventEmitter
  constructor: ()->
    @locked = false
    @responseType = ""
  download: (url)->
    if @locked
      console.log 'incorrect invoke'
      return false
    
    @locked = true
    
    console.log "download start : #{url}"
    
    GM_xmlhttpRequest
      url : url
      onload : (e)=>
        response = e.responseText
        
        console.log "download finish : #{url}"
        #console.log e.responseText
        
        if @responseType is "json"
          response = JSON.parse response
        
        if (!response)
          @emit 'fail', url
          return true
        
        @emit 'success',response
        @removeAllListeners 'success'
        @removeAllListeners 'fail'
        @locked = false
        return true
      onerror : (e)=>
        @emit 'fail', url
        @removeAllListeners 'success'
        @removeAllListeners 'fail'
        @locked = false
        return true
      method : "GET"
      
    return true

module.exports = Downloader