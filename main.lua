if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

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
  return 1
end

function touch.xppi()
  return 1
end

function touch.yppi()
  return 1
end

function touch.enable()
  return nil
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

function on.construction()
end

function on.restore(state)
end

function on.save()
end

function on.resize(w, h)
end

function on.activate()
end

function on.getFocus()
end

function on.create()
end

function on.paint(gc)
end

local platform = {
  apiLevel = 2,
  window = {}
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

function string:split(str, delim)
end

function string:uchar(n, ...)
  return ""
end

function string:usub(i, j)
  return self:sub(i, j)
end

function string:ulen()
  return self:len()
end

local var = {}
_G.var = var

function var.list()
  return var.vars or {}
end
-- TBC...

gc.font_cache = {}
gc.size_factor = 4

function gc:init()
  self:setFont(nil, nil, 11)
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
  assert(nil)
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
  size = size * gc.size_factor

  if not gc.font_cache[family..style..size] then
    print('Loading font')
    gc.font_cache[family..style..size] = assert(love.graphics.newFont("NotoSans-Regular.ttf", size))
  end

  if gc.font_cache[family..style..size] then
    love.graphics.setFont(gc.font_cache[family..style..size])
  end
end

function gc:setPen(thickness, style)
  thickness = thickness or 'thin'
  style = style or 'smooth'

  love.setLineWidth(thickness == 'thin' and 1 or (thickness == 'medium' and 2 or (thickness 'thick' and 3)))
end


-- Love Implementation
local main_gc = nil
local filename = nil

local function load_app(filename)
  if filename then
    print('loading app at '..filename)
    local f = assert(loadfile(filename))
    return f()
  end
end

function love.load()
  love.window.setMode(1600, 900, {resizable = true})

  print('[load]')
  filename = arg[2]
  load_app(filename)

  print('[init]')
  print('construction...')
  on.construction()
  print('restore...')
  on.restore(nil)
  print('resize...')
  on.resize(love.graphics.getPixelWidth(), love.graphics.getPixelHeight())
  print('activate...')
  on.activate()
  print('getFocus...')
  on.getFocus()
  print('create...')
  on.create()
  print('[done]')

  main_gc = gc()
end

function love.resize(w, h)
  on.resize(w, h)
end

function love.update()
end

function love.draw()
  on.paint(main_gc, 0, 0, love.graphics.getPixelWidth(), love.graphics.getPixelHeight())
end

function love.keypressed(key, scancode, isrepeat)
  local shift = love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift')
  local ctrl = love.keyboard.isDown('lctrl') or love.keyboard.isDown('rctrl')

  if key == 'up' then
    on.arrowUp()
  elseif key == 'down' then
    on.arrowDown()
  elseif key == 'left' then
    on.arrowLeft()
  elseif key == 'right' then
    on.arrowRight()
  elseif key == 'return' then
    if shift then
      on.returnKey()
    else
      on.enterKey()
    end
  elseif key == 'backspace' then
    on.backspaceKey()
  elseif key == 'escape' then
    on.escapeKey()
  elseif key == 'tab' then
    if shift then
      on.backtabKey()
    else
      on.tabKey()
    end
  elseif key == '-' and shift then
    on.charIn('\226\136\146')
  else
    if love.keyboard.isDown('lctrl') or love.keyboard.isDown('rctrl') then
      if key == 'r' then
        load_app(filename)
      elseif key == 'c' then
        on.copy()
      elseif key == 'x' then
        on.cut()
      elseif key == 'v' then
        on.paste()
      elseif key == 'm' then
        on.menu()
      elseif key == '.' then
        on.contextMenu()
      elseif key == '.' then
        on.clearKey()
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
