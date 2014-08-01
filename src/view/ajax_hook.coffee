{EventEmitter} = require 'events'

class AjaxHook extends EventEmitter
  constructor: (@unsafeWindow, @$)->
  
  ###
    TODO
      [v]add hook for read more at the bottom of guild
      []add hook for read more at the bottom of home
  ###
  injectHook: ()->
    guildPattern = /http:\/\/guild\.gamer\.com\.tw\/guild\.php\?sn=.+/g
    if (guildPattern.test(window.location.href))
      @_injectGuildHook()
      
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
    ###
    # idk the variable name, it's auto generate stuff, baha sucks
    newHook_readMore = (a) =>
      a$ = a
      i = undefined
      b = undefined
      c = undefined
      d = undefined
      t = undefined
      if unsafe.point_now < unsafe.total_ary
        a = unsafe.point_now
        b = unsafe.buildMsgAndReply3()
        document.getElementById("noMsg").style.display = "none"
        document.getElementById("readMore").innerHTML += b
        i = a
        while i < unsafe.point_now and i < unsafe.total_ary
          unsafe.changetxt "m-" + unsafe.msgArr[i].sn
          i++
        @emit 'ajax'
      else
        document.getElementById("moreBtn").disabled = not 0
        b = unsafe.getCookie("BAHAID")
        c = ""
        d = ""
        t = document.getElementById("lastTime").value
        if 1 < (new Date - new Date(t.substr(0, 4), t.substr(5, 2) - 1, t.substr(8, 2), t.substr(11, 2), t.substr(14, 2), t.substr(17, 2))) / 7776000000
          alert "您沒有更舊的動態了！"
          document.getElementById("moreBtn").disabled = false
        else
          unsafe.r = document.getElementById("daysRange").value
          if a.toLowerCase() is b.toLowerCase()
            c = "/ajax/getMoreMsg.php"
            d = "t=" + t + "&r=" + unsafe.r + "&k=" + unsafe.k + "&auto=" + document.getElementById("autoReadMore").value + "&lastGetSn=" + document.getElementById("lastGetSn").value
          else
            c = "/ajax/othersMoreMsg.php"
            d = "t=" + t + "&r=" + unsafe.r + "&u=" + a + "&k=" + unsafe.k + "&lastGetSn=" + document.getElementById("lastGetSn").value
          $.ajax
            url: c
            method: "POST"
            data: d
            success: (a) =>
              unsafe.showActiveDiv.call unsafe, "readMore", a
              console.log a
              @emit 'ajax'
              return
      return
    ###
    #killOldHook = "javascript:" + encodeURIComponent("readAllReply = function(){};readMore = function(){};undefined;")
    killOldHook = "javascript:" + encodeURIComponent("readAllReply = function(){};undefined;")
    window.location.href = killOldHook;
    (@$ document).on 'click', 'a[onclick^=readAllReply]', null, ->
      onclickPattern = /readAllReply\((\d+),this\.parentNode\)/g
      id = (onclickPattern.exec ($ this).attr 'onclick' )[1]
      newHook id, this.wrappedJSObject.parentNode
    ###(@$ document).on 'click', 'button[onclick^=readMore]', null, ->
      onclickPattern = /readMore\('(#GID\d+)'\);/g
      id = (onclickPattern.exec ($ this).attr 'onclick' )[1]
      newHook_readMore id
    ###
    # it's temp fix, who cares?
    (@$ document).on 'click', 'button[onclick^=readMore]', null, =>
      setTimeoutR = (a,b)->setTimeout b,a
      setTimeoutR 5000, ()=>
        @emit 'ajax'
    
module.exports = AjaxHook