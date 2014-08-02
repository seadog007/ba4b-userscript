{EventEmitter} = require 'events'

#hook for guild

hook_readAllReply = """
  function readAllReply(a, b) {
    $.ajax({
      url: '/ajax/comment.php?a=S&s=' + a,
      method: 'POST',
      param: 'a=S&s=' + a,
      loading: function () {
        b.innerHTML = '<img src="http://i2.bahamut.com.tw/loading.gif">'
      },
      success: function (b) {
        changeDiv('allReply' + a, b)
        try {
          window.ba4b.updateImageIn()
        } catch (e) {
          console.log(e);
        }
      }
    })
  }
"""
hook_readMore = """
  function readMore(a) {
    if (point_now < total_ary) {
      a = point_now;
      var b = buildMsgAndReply3();
      document.getElementById('noMsg') .style.display = 'none';
      document.getElementById('readMore') .innerHTML += b;
      for (i = a; i < point_now && i < total_ary; i++) changetxt('m-' + msgArr[i].sn)
      
      try {
        window.ba4b.updateImageIn()
      } catch (e) {
        console.log(e);
      }
      
    } else {
      document.getElementById('moreBtn') .disabled = !0;
      var b = getCookie('BAHAID'),
      c = '',
      d = '';
      t = document.getElementById('lastTime') .value;
      1 < (new Date - new Date(t.substr(0, 4), t.substr(5, 2) - 1, t.substr(8, 2), t.substr(11, 2), t.substr(14, 2), t.substr(17, 2))) / 7776000000 ? (alert('您沒有更舊的動態了！'), document.getElementById('moreBtn') .disabled = !1)  : (r = document.getElementById('daysRange') .value, a.toLowerCase() == b.toLowerCase() ? (c = '/ajax/getMoreMsg.php', d = 't=' + t + '&r=' + r + '&k=' + k + '&auto=' + document.getElementById('autoReadMore') .value + '&lastGetSn=' + document.getElementById('lastGetSn') .value)  : (c = '/ajax/othersMoreMsg.php', d = 't=' + t + '&r=' + r + '&u=' + a + '&k=' + k + '&lastGetSn=' + document.getElementById('lastGetSn') .value), $.ajax({
        url: c,
        method: 'POST',
        param: d,
        success: function (a) {
          showActiveDiv('readMore', a)
          
          try {
            window.ba4b.updateImageIn()
          } catch (e) {
            console.log(e);
          }
        }
      }))
    }
  }
"""
hook_getVoteList = """
  function getVoteList(a, b, c) {
    var d = document.getElementById('msgvotelist'),
    f = document.getElementById('lastSn');
    if ('none' == d.style.display || 'block' == d.style.display && b + '&' + c != f.value) {
      'block' == d.style.display && (d.style.display = 'none');
      $.ajax({
        url: '/ajax/comment.php?a=showGPBP&t=' + c + '&sn=' + b,
        method: 'POST',
        param: 'a=showGPBP&t=' + c + '&sn=' + b,
        success: function (a) {
          showVoteList('msgvotelist', a)
          try {
            window.ba4b.updateImageIn()
          } catch (e) {
            console.log(e);
          }
        }
      });
      if (isIE()) {
        var h = a.x;
        a = document.documentElement.scrollTop + a.clientY
      } else h = 1000 < document.body.clientWidth ? a.pageX - (document.body.clientWidth - 1000) / 2 : a.pageX,
      a = a.pageY;
      f.value = b + '&' + c;
      d.style.left = h + 'px';
      d.style.top = a + 10 + 'px'
    } else d.style.display = 'none',
    f.value = ''
  }
"""
hook_checkMsg = """
  function checkMsg() {
    var a = document.getElementById('msgtalk'),
    b = a.value;
    if (1800 < b.utf8Length()) alert('只能寫600個字喔!');
     else if ('' == b.replace(/(^\\s*)|(\\s*$)/g, '')) alert('不能空白!');
     else if (1 == document.getElementById('sendingMsg') .value) alert('處理中請稍候！');
     else {
      var b = 'mainmsg.php',
      c = '',
      d = document.getElementById('ori_s');
      if (d) switch (d.value.substr(0, 1)) {
      case 'g':
        b = 'guildMsgNew.php',
        c = '&sf=' + d.value.substr(1)
      }
      document.getElementById('sendingMsg') .value = 1;
      noreply = 0;
      document.getElementById('forbidden') && (noreply = document.getElementById('forbidden') .checked ? 1 : 0);
      secret = document.getElementById('privacy') .checked ? 1 : 0;
      $('iframe') .each(function (a) {
        0 <= a.src.indexOf('?autoplay=1') && (a.src = a.src.replace(/\\?autoplay=1/gi, ''))
      });
      $.ajax({
        url: '/ajax/' + b,
        method: 'POST',
        param: 'msg=' + encodeURIComponent(a.value) + '&status=' + secret + '&flag=' + noreply + c,
        success: function (a) {
          showActiveDiv('MSG-box2', a)
          try {
            window.ba4b.updateImageIn()
          } catch (e) {
            console.log(e);
          }
        }
      })
    }
  }
"""
hook_checkReply = """
  function checkReply(a, b) {
    var c = document.getElementById('replyMsg' + a),
    d = c.value;
    countLimit(c, 85) || ('' == d.replace(/(^\s*)|(\s*$)/g, '') ? (alert('請輸入留言'), c.focus())  : document.getElementById('replyBtn' + a) .disabled ? alert('處理中，請稍候')  : (document.getElementById('replyBtn' + a) .disabled = !0, $.ajax({
      url: '/ajax/comment.php?a=A&s=' + a,
      method: 'POST',
      param: 'a=A&s=' + a + '&c=' + encodeURIComponent(c.value) + '&u=' + b,
      success: function (b) {
      showActiveDiv('allReply' + a, b)
      try {
        window.ba4b.updateImageIn()
      } catch (e) {
        console.log(e);
      }
      }
    })))
  }
"""

# hook for home

hook_r_creation_gplist = """
  function r_creation_gplist( xmldoc ) {
    var nodes = xmldoc.getElementsByTagName('errMsg');
    var htmlcode = '';

    if(nodes.length) {
      htmlcode = nodes[0].firstChild.nodeValue;
    }
    else{
      var userid = xmldoc.getElementsByTagName('userid');
      var next = xmldoc.getElementsByTagName('next');
      for(i=0;i<userid.length;i++){
        var uid = userid[i].firstChild.nodeValue;
        htmlcode += '<a href=\"http://home.gamer.com.tw/'+uid+'\" target=\"_blank\"><img src=\"'+getAvatarPic(uid)+'\" onmouseover=\"showGamerCard(event,\\''+uid.toLowerCase()+'\\')\" onmousemove=\"moveGamerCard(event)\" onmouseout=\"hideGamerCard()\"></a>'
      }
      if( next.length ) {
        htmlcode += next[0].firstChild.nodeValue;
      }
    }
    $('#gplist').html(htmlcode);
    $('#gplist').show();
    try {
      window.ba4b.updateImageIn()
    } catch (e) {
      console.log(e);
    }
    
  }
"""
hook_r_creation_reply = """
  function r_creation_reply(xmldoc) {
    var error = $('MSG', xmldoc).val();
    if( error ) {
      alert(error);
      return ;
    }

    var html = $('TXT',xmldoc).val();
    var rsn = $('RSN',xmldoc).val();

    $('#reply'+rsn).val('');


    if( 0 != rsn ) {
      $('#ownerreplys'+rsn).html($('#ownerreplys'+rsn).html()+html);
    }else{
      $('#replys').html($('#replys').html()+html);
    }

    creation_changetxt('replys');

    egg('button[disabled]').attr('disabled',false);
    try {
      window.ba4b.updateImageIn()
    } catch (e) {
      console.log(e);
    }
  }
"""

class AjaxHook extends EventEmitter
  constructor: (@unsafeWindow, @$)->
  
  ###
    TODO
      [v]add hook for read more at the bottom of guild
      []add hook for read more at the bottom of home
  ###
  injectHook: ()->
    guildPattern = /http:\/\/guild\.gamer\.com\.tw\/guild\.php\?sn=.+/g
    guildSingleMessagePattern = /http:\/\/guild\.gamer\.com\.tw\/singleACMsg\.php\?.+/g
    homePattern = /http:\/\/home\.gamer\.com\.tw\/.+/g
    
    if (guildPattern.test(window.location.href))
      @_injectGuildHook()
    else if (guildSingleMessagePattern.test(window.location.href))
      @_injectGuildHook()
    
    if (homePattern.test(window.location.href))
      @_injectHomeHook()
  
  _injectHomeHook: ()->
    @_injectScript hook_r_creation_gplist
    @_injectScript hook_r_creation_reply
  
  _injectGuildHook: ()->
    @_injectScript hook_readAllReply
    @_injectScript hook_readMore
    @_injectScript hook_getVoteList
    @_injectScript hook_checkMsg
    @_injectScript hook_checkReply
  
  _injectScript: (scriptStr)->
    if unsafeWindow?
      _window = unsafeWindow
    else
      _window = window
    try
      _window.eval scriptStr
      console.log "script injected!"
    catch e
      console.log 'eval error', e, scriptStr
  
module.exports = AjaxHook