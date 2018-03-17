global.Cookie = require 'js-cookie'

class Storage
  constructor: (@COOKIE_KEY = "vuex") ->

Storage::sset = (key, value, context) ->
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

Storage::sget = (key, context) ->
  if !context && typeof key == 'object'
    context = key
    return @getJSON context
  unless context
    throw new Error 'context required'
  ret = @getJSON context
  ret[key]

Storage::ssetJSON = (value, context) ->
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
  if res.getHeader 'Set-Cookie'
    res.removeHeader 'Set-Cookie'
  res.setHeader 'Set-Cookie', global.document.cookie

Storage::sgetJSON = (context) ->
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

Storage::set = (key, value, context) ->
  if context && context.isServer then return @sset(key, value, context)
  unless value
    return @setJSON value
  
  oldState = @getJSON()
  oldState[key] = value
  @setJSON oldState

Storage::get = (key, context) ->
  if context && context.isServer then return @sget(key, context)
  unless key
    return @getJSON()
  ret = @getJSON()
  ret[key]

Storage::setJSON = (value, context) ->
  if context && context.isServer then return @ssetJSON(value, context)
  if !value || typeof value != 'object'
    value = {}
  Cookie.set @COOKIE_KEY, value, expires: 150

Storage::getJSON = (context) ->
  if context && context.isServer then return @sgetJSON(context)
  ret = Cookie.getJSON(@COOKIE_KEY)
  if !ret || typeof ret != 'object'
    ret = {}
  ret
    
module.exports = new Storage
module.exports.Storage = Storage