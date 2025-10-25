-- Lua Form widget part
--
--  F3 Distance Tool for FrSky/ETHOS transmitters and GPS telemetry
-- 
--
--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation; see <http://www.gnu.org/licenses/>.
--     
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY! Without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE is the program
--    published. See the GNU General Public License for more details.
--     
--                                   Copyright (c) 2025 Andreas Stockhaus
-- 

local Configure = {}

local red
local crossTime = 0

Configure.Name = function (widget)
    local myname = "F3-Distance"
    return myname
end

Configure.create = function ()
	red=lcd.RGB(255,0,0)
	Track:set(0)
	return {color=red, min=0, max=150, confirm=nil, confirmSet=0, direction=nil, directionValue=0, gps=nil, point=GPSPoint.new(GPSPoint), pointA=GPSPoint.new(GPSPoint), pointB=GPSPoint.new(GPSPoint), race=Track, start=nil, startSet=0, timer=nil, voice=false}
end

Configure.config = function (widget)

    line = form.addLine("Range (m)")
    local slots = form.getFieldSlots(line, {0, " - ", 0})
    form.addNumberField(line, slots[1], -150, 10, function() return widget.min end, function(value) widget.min = value  end)
    form.addStaticText(line, slots[2], " - ")
    form.addNumberField(line, slots[3], 0, 150, function() return widget.max end, function(value) widget.max = value end)
    
    line = form.addLine("Direction Slider")
    form.addSourceField(line, nil, function() return widget.direction end, function(value) widget.direction = value end)

    line = form.addLine("Position Key")
    form.addSourceField(line, nil, function() return widget.confirm end, function(value) widget.confirm = value widget.confirmSet = value:value() end)

    line = form.addLine("Start Race Switch")
    form.addSourceField(line, nil, function() return widget.start end, function(value) widget.start = value widget.startSet = value:value() end)

    line = form.addLine("GPS Device")
    form.addStaticText(line, nil , "GPS ")
    form.addSourceField(line, nil, function() return widget.gps end, function(value) widget.gps = value end)

    line = form.addLine("Color Background")
    form.addColorField(line, nil, function() return widget.color end, function(color) widget.color = color end)

    line = form.addLine("Flight Timer")
    form.addSourceField(line, nil, function() return widget.timer end, function(value) widget.timer = value end)

    line = form.addLine("Voice")
    form.addBooleanField(line, nil, function() return widget.voice end, function(value) widget.voice = value end)

end

Configure.read = function(widget)
    widget.min = storage.read("min")
    widget.max = storage.read("max")
    widget.confirm = storage.read("confirm")
    widget.confirmSet = storage.read("confirmSet")
    widget.direction = storage.read("direction")
    widget.start = storage.read("start")
    widget.startSet = storage.read("startSet")
    widget.gps = storage.read("gps")
    widget.color = storage.read("color")
    widget.timer = storage.read("timer")
    widget.voice = storage.read("voice")
end

Configure.write = function(widget)
    storage.write("min", widget.min)
    storage.write("max", widget.max)
    storage.write("confirm", widget.confirm)
    storage.write("confirmSet", widget.confirmSet)
    storage.write("direction", widget.direction)
    storage.write("start", widget.start)
    storage.write("startSet", widget.startSet)
    storage.write("gps", widget.gps)
    storage.write("color", widget.color)
    storage.write("timer", widget.timer)
    storage.write("voice", widget.voice)
end

return Configure
