class GM_Storage
  constructor: (getMethod, setMethod, namespace = 'ba4b')->
    @_get = getMethod
    @_set = setMethod
    @namespace = namespace
    @cache = null
    @_load()

  set: (key, value)->
    #make sure always get newest value
    @_load()
    @cache[key] = value
    @_save()

  get: (key, defaultValue)->
    #make sure always get newest value
    @_load()
    if @cache[key]
      @cache[key]
    else if defaultValue?
      defaultValue
    else
      undefined

  remove: (key)->
    #make sure always get newest value
    @_load()
    delete cache[key]
    @_save()

  #use when storage was modified by another program
  reload: ()->
    @_load

  _load: ()->
    if GM_getValue(@namespace)
      @cache = JSON.parse GM_getValue @namespace
    else
      @cache = {}
      @_save

  _save: ()->
    GM_setValue @namespace, JSON.stringify @cache

module.exports = GM_Storage