{EventEmitter} = require 'events'

class AjaxHook extends EventEmitter
  constructor: (@unsafeWindow, @$)->
  
  injectHook: ()->
    guildPattern = /http:\/\/guild\.gamer\.com\.tw\/guild\.php\?sn=.+/g
    if (guildPattern.test(window.location.href))
      @_injectGuildHook()
      
  ###
    TODO
      add hook for read more at the bottom of guild
      add hook for read more at the bottom of home
  ###
  _injectGuildHook: ()->
    console.log 'inject hook!'
    unsafe = @unsafeWindow
    $ = @$
    newHook = (replyId, loadBar)=>
      all = loadBar.parentNode
      $.ajax
        url: '/ajax/comment.php?a=S&s=' + replyId
        method: 'POST'
        data: 'a=S&s=' + replyId
        loading: ()=>
          loadBar.innerHTML = '<img src="http://i2.bahamut.com.tw/loading.gif">'
        success:(result)=>
          console.log 'hook test'
          console.log result
          unsafe.changeDiv 'allReply' + replyId, result
          
          @emit 'ajax', all
          console.log all
            
    killOldHook = "javascript:" + encodeURIComponent("readAllReply = function(){};undefined;")
    window.location.href = killOldHook;
    (@$ document).on 'click', 'a[onclick^=readAllReply]', null, ->
      onclickPattern = /readAllReply\((\d+),this\.parentNode\)/g
      id = (onclickPattern.exec ($ this).attr 'onclick' )[1]
      newHook id, this.wrappedJSObject.parentNode
    
module.exports = AjaxHook