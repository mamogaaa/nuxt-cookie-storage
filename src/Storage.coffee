global.Cookie = require 'js-cookie'

class Storage
  constructor: (@COOKIE_KEY = "vuex") ->

if process.server
  Storage::set = (key, value, context) ->
    if !context && typeof value == 'object'
      context = value
      return @setJSON key, context
    unless context
      throw new Error 'context required'
    req = context.req
    res = context.res
    global.document =
      cookie: req.headers.cookie
    
    oldState = @getJSON context
    oldState[key] = value
    @setJSON oldState, context

  Storage::get = (key, context) ->
    if !context && typeof key == 'object'
      context = key
      return @getJSON context
    unless context
      throw new Error 'context required'
    ret = @getJSON context
    ret[key]

  Storage::setJSON = (value, context) ->
    unless context
      throw new Error 'context required'
    req = context.req
    res = context.res
    global.document =
      cookie: req.headers.cookie
    if !value || typeof value != 'object'
      value = {}
    Cookie.set @COOKIE_KEY, value, expires: 150
    req.headers.cookie = global.document.cookie
    res.setHeader 'Set-Cookie', global.document.cookie

  Storage::getJSON = (context) ->
    unless context
      throw new Error 'context required'
    req = context.req
    res = context.res
    global.document =
      cookie: req.headers.cookie
    ret = Cookie.getJSON(@COOKIE_KEY)
    if !ret || typeof ret != 'object'
      ret = {}
    ret

if !process.server
  Storage::set = (key, value) ->
    unless value
      return @setJSON value
    
    oldState = @getJSON()
    oldState[key] = value
    @setJSON oldState

  Storage::get = (key) ->
    unless key
      return @getJSON()
    ret = @getJSON()
    ret[key]

  Storage::setJSON = (value) ->
    if !value || typeof value != 'object'
      value = {}
    Cookie.set @COOKIE_KEY, value, expires: 150

  Storage::getJSON = (context) ->
    ret = Cookie.getJSON(@COOKIE_KEY)
    if !ret || typeof ret != 'object'
      ret = {}
    ret
    
module.exports = new Storage
module.exports.Storage = Storage