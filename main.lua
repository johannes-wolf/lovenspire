if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

local utf8 = require 'utf8'
local class = require 'class'
_G.class = class

if not unpack then
  function unpack(t)
    return table.unpack(t)
  end
end

local gc = class(nil, "GC")

local touch = {}
--_G.touch = touch

function touch.ppi()
  return 20
end

function touch.xppi()
  return 20
end

function touch.yppi()
  return 20
end

function touch.enabled()
  return true
end

function touch.isKeyboardAvailable()
  return false
end

function touch.isKeyboardVisible()
  return false
end

function touch.showKeyboard(state)
  print('NOT IMPLEMENTED')
end

local D2Editor = class(nil, "D2Editor")
_G.D2Editor = D2Editor

function D2Editor.newRichText()
  return D2Editor()
end

function D2Editor:setReadOnly(...)
end

function D2Editor:setBorder(...)
end

local clipboard = {}
--_G.clipboard = clipboard

function clipboard.addText(str)
  clipboard.text = str
end

function clipboard.getText()
  return clipboard.text
end

local cursor = {}
--_G.cursor = cursor

function cursor.set(name)
end

function cursor.hide()
end

function cursor.show()
end

local document = {}
_G.document = document

function document.markChanged()
end

local ti_math = {}
function math.eval(str, exact)
  return "0"
end

function math.evalStr(str)
  return "0"
end

function math.getEvalSettings()
  return ti_math.settings or {
    {'Display Digits', 'Float6'},
    {'Angle Mode', 'Radian'},
    {'Calculation Mode', 'Auto'},
    {'Real or Complex Format', 'Real'},
    {'Exponential Format', 'Engineering'},
    {'Vector Format', 'Normal'},
    {'Base', 'Decimal'},
    {'Unit System', 'SI'},
  }
end

function math.setEvalSettings(settings)
  ti_math.settings = settings or {}
end

local toolpalette = {}
_G.toolpalette = toolpalette

function toolpalette.enableCopy()
end

function toolpalette.enableCut()
end

function toolpalette.enablePaste()
end

local on = {}
_G.on = on

function on.paint(gc)
  love.graphics.print('Nothing', 0, 0)
end

local window = class()
local platform = {
  apiLevel = 2,
  window = window()
}

_G.platform = platform

function platform.hw()
  return 3
end

function platform.isColorDisplay()
  return true
end

function platform.isDeviceModeRendering()
  return false
end

function platform.isTabletModeRendering()
  return false
end

function platform.registerErrorHandler(callback)
  platform.error_handler = callback
end

function platform.window:width()
  return love.graphics.getPixelWidth()
end

function platform.window:height()
  return love.graphics.getPixelHeight()
end

function platform.window:invalidate(x, y, w, h)
end

function platform.window:setBackgroundColor(c)
  if c then
    --love.graphics.setBackgroundColor(love.math.colorFromBytes(c >> 16 & 0xff, c >> 8 & 0xff, c & 0xff))
  else
    love.graphics.setBackgroundColor(1, 1, 1, 1)
  end
end

function platform.window:setFocus(state)
end

function platform.window:getScrollHeight()
  return 0
end

function platform.window:setScrollHeight(x)
end

function platform.window:displayInvalidatedRectangles(state)
end

function platform.withGC(callback, ...)
  if callback then
    local gc = gc()
    return callback(gc, ...)
  end
end

function platform.getDeviceID()
  return "love"
end

local image = class(nil, "image")
_G.image = image

function image.new(...)
  return image(...)
end

function image:width()
  return 0
end

function image:height()
  return 0
end

function string.split(str, delim)
  delim = delim or '%s'
  local t = {}
  for field, s in string.gmatch(str, "([^"..delim.."]*)("..delim.."?)") do
    table.insert(t, field)
    if s == "" then
      return t
    end
  end
end

function string.uchar(...)
  return utf8.char(...)
end

function string.usub(s, i, j)
   if j and j <= 0 then return '' end
   return string.sub(s, i and utf8.offset(s, i) or 1, j and (utf8.offset(s, j+1) - 1))
end

function string.ulen(str)
  return utf8.len(str)
end

local timer = class()
_G.timer = timer

function timer.getMilliSecCounter()
  return love.timer.getTime() * 1000
end

function timer.start(period)
  timer.period = period / 1000.0
end

function timer.stop()
  timer.period = nil
end

local var = {
  vars = {}
}
_G.var = var

function var.list()
  local t = {}
  for key, _ in pairs(var.vars) do
    table.insert(t, key)
  end
  return t
end

function var.store(ident, value)
  var.vars[ident] = value
end

-- TBC...

gc.font_cache = {}
gc.font_size_factor = 1

function gc:init()
  self:setFont(nil, nil, 11)
end

function gc:smartClipRect(op, x, y, w, h)
	return self:clipRect(op, x, y, w, h)
end

function gc:clipRect(op, x, y, w, h)
  if op == 'reset' then
    self:clipRect('set')
  elseif op == 'set' then
    love.graphics.setScissor(math.max(x or 0, 0),
                             math.max(y or 0, 0),
                             math.max(w or love.graphics.getPixelWidth(), 0),
                             math.max(h or love.graphics.getPixelHeight(), 0))
  elseif op == 'intersect' then
    love.graphics.intersectScissor(math.max(0, x),
                                   math.max(0, y),
                                   math.max(0, w),
                                   math.max(0, h))
  elseif op == 'null' then
    gc:clipRect('set', 0, 0, 0, 0)
  end
end

function gc:drawArc(x, y, w, h, sa, se)
  --love.graphics.arc('line', x, y, w, sa, se, 8)
end

function gc:drawImage(handle, x, y)
  --assert(nil)
end

function gc:drawLine(x1, y1, x2, y2)
  love.graphics.line(x2, y1, x2, y2)
end

function gc:drawPolyLine(list)
  love.graphics.line(table.unpack(list))
end

function gc:drawRect(x, y, w, h)
  love.graphics.rectangle('line', x, y, w, h)
end

function gc:drawString(text, x, y, align)
  align = align or 'top'

  love.graphics.print(text, x, y)

  return x + self:getStringWidth(text)
end

function gc:fillArc()
end

function gc:fillPolygon(list)
  love.graphics.polygon('fill', table.unpack(list))
end

function gc:fillRect(x, y, w, h)
  love.graphics.rectangle('fill', x, y, w, h)
end

function gc:getStringHeight(text)
  local font = love.graphics.getFont()
  return font:getHeight(text)
end

function gc:getStringWidth(text)
  local font = love.graphics.getFont()
  return font:getWidth(text)
end

function gc:setColorRGB(r, g, b)
  if r and g and b then
    love.graphics.setColor(r/255, g/255, b/255, 1)
  elseif r then
    love.graphics.setColor(love.math.colorFromBytes(bit.band(bit.rshift(r, 16), 0xff), bit.band(bit.rshift(r, 8), 0xff), bit.band(r, 0xff)))
  end
end

function gc:setFont(family, style, size)
  family = family or 'sansserif'
  style = style or 'r'
  size = size or 11
  size = size * gc.font_size_factor

  if not gc.font_cache[family..style..size] then
    print('Loading font '..family..' '..style..' '..size)
    gc.font_cache[family..style..size] = assert(love.graphics.newFont("NotoSans-Regular.ttf", size))
  end

  local prev_font = self.current_font or {family, style, size}
  if gc.font_cache[family..style..size] then
    love.graphics.setFont(gc.font_cache[family..style..size])
    gc.current_font = {family, style, size}
  end

  return table.unpack(prev_font)
end

function gc:setLineWidth(thickness)
	return self:setPen(thickness, self.style or 'smooth')
end

function gc:setPen(thickness, style)
  self.thickness = thickness or 'thin'
  self.style = style or 'smooth'

  love.graphics.setLineWidth(thickness == 'thin' and 1 or (thickness == 'medium' and 2 or (thickness 'thick' and 3)))
end


-- Love Implementation
local main_gc = nil
local is_grabbing = false
local filename = nil

local function load_app(filename)
  if filename then
    print('loading app at '..filename)
    local f = assert(loadfile(filename))
    return f()
  end
end

local function app_on(event, ...)
  if event ~= 'paint' then
    print('[event] '..event)
  end
  if on and on[event] then
    return on[event](...)
  end
end

local function app_init()
  app_on('construction')
  --app_on('restore', nil)
  app_on('resize', love.graphics.getPixelWidth(), love.graphics.getPixelHeight())
  app_on('activate')
  app_on('getFocus')
  app_on('create')

  main_gc = gc()
end

function love.load()
  love.window.setMode(1600, 900, {resizable = true})

  print('[load]')
  filename = arg[2]
  load_app(filename)

  print('[init]')
  app_init()
end

function love.resize(w, h)
  app_on('resize', w, h)
end

function love.update()
  if timer.period then
    if (timer.next_tick or 0) < love.timer.getTime() then
      app_on('timer')
      if timer.period then
        timer.next_tick = love.timer.getTime() + timer.period
      end
    end
  end
end

function love.draw()
  if on.paint then
    on.paint(main_gc, 0, 0, love.graphics.getPixelWidth(), love.graphics.getPixelHeight())
  end
end

function love.mousemoved(x, y, dx, dy, istouch)
  app_on('mouseMove', x, y)
end

function love.mousepressed(x, y, button, istouch, presses)
  local ctrl = love.keyboard.isDown('lctrl') or love.keyboard.isDown('rctrl')

  if button == 1 then
    if ctrl then
      is_grabbing = true
      app_on('grabDown', 0, 0)
    end
    app_on('mouseDown', x, y)
  elseif button == 2 then
    app_on('rightMouseDown', x, y)
  end
end

function love.mousereleased(x, y, button, istouch, presses)
  if button == 1 then
    if is_grabbing then
      app_on('grabUp', 0, 0)
    else
      app_on('mouseUp', x, y)
    end
  elseif button == 2 then
    app_on('rightMouseUp', x, y)
  end

  is_grabbing = false
end

function love.keypressed(key, scancode, isrepeat)
  local shift = love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift')
  local ctrl = love.keyboard.isDown('lctrl') or love.keyboard.isDown('rctrl')

  if key == 'up' then
    if on.arrowUp then
      app_on('arrowUp')
    else
      app_on('arrowKey', 'up')
    end
  elseif key == 'down' then
    if on.arrowDown then
      app_on('arrowDown')
    else
      app_on('arrowKey', 'down')
    end
  elseif key == 'left' then
    if on.arrowLeft then
      app_on('arrowLeft')
    else
      app_on('arrowKey', 'left')
    end
  elseif key == 'right' then
    if on.arrowRight then
      app_on('arrowRight')
    else
      app_on('arrowKey', 'right')
    end
  elseif key == 'return' then
    if shift then
      app_on('returnKey')
    else
      app_on('enterKey')
    end
  elseif key == 'backspace' then
    if ctrl then
      app_on('clearKey')
    else
      app_on('backspaceKey')
    end
  elseif key == 'escape' then
    app_on('escapeKey')
  elseif key == 'tab' then
    if shift then
      app_on('backtabKey')
    else
      app_on('tabKey')
    end
  elseif key == '-' and ctrl then
    app_on('charIn', '\226\136\146') -- BUG!!
  else
    if love.keyboard.isDown('lctrl') or love.keyboard.isDown('rctrl') then
      if key == 'r' then
        --on = {}
        load_app(filename)
        app_init()
        main_gc = gc()
      elseif key == 'c' then
        app_on('copy')
      elseif key == 'x' then
        app_on('cut')
      elseif key == 'v' then
        app_on('paste')
      elseif key == 'm' then
        app_on('contextMenu')
      elseif key == 'k' then
        app_on('clearKey')
      elseif key == '1' then
        gc.font_size_factor = 1
        main_gc = gc()
      elseif key == '2' then
        gc.font_size_factor = 2
        main_gc = gc()
      elseif key == '3' then
        gc.font_size_factor = 4
        main_gc = gc()
      end
    end
  end
  print('key='..key)
end

function love.textinput(text)
  if on.charIn then
    on.charIn(text)
  end
end
