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


if GPSPoint == nil then
GPSPoint=dofile("GPSPoint.lua")
end

if Track == nil then
Track=dofile("RaceTrack.lua")
end

local function name(widget)
    local myname = "Task B"
    return myname
end

local red
local crossTime = 0

local function create()
	red=lcd.RGB(255,0,0)
	Track:set(0)
	return {color=red, min=0, max=150, confirm=nil, confirmSet=0, direction=nil, directionValue=0, gps=nil, point=GPSPoint.new(GPSPoint), pointA=GPSPoint.new(GPSPoint), pointB=GPSPoint.new(GPSPoint), race=Track, start=nil, startSet=0, timer=nil, voice=false}
end

local function configure(widget)

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

local function paint(widget)
	local w, h = lcd.getWindowSize()
	if widget.gps ~= nil then
		if widget.race.running == true then
			lcd.color(widget.color)
    			lcd.drawFilledRectangle(0, 0, w, h)
			lcd.color(BLACK)
			lcd.font(FONT_S_BOLD)
			lcd.drawText(2,10,"dir:  "..widget.race.bearingPointA2B.."° / dist:  "..widget.race.distance.." m")
			lcd.drawText(2,30,"A: LON="..widget.pointA.lon.."°")
			lcd.drawText(2,50,"   LAT="..widget.pointA.lat.."°")
			lcd.drawText(2,70,"B: LON="..widget.pointB.lon.."°")
			lcd.drawText(2,90,"   LAT="..widget.pointB.lat.."°")
			lcd.font(FONT_XL)
			if widget.timer ~= nil then
				lcd.drawText(w/2,(h/2)*1.2,math.floor(widget.timer:value()).."sec.", CENTERED) 
			end
			lcd.font(FONT_XXL)
			lcd.drawText(w/2,(h/2)*1.5,"LAP: "..widget.race.lap, CENTERED)
		else
			lcd.color(BLACK)
    			lcd.drawFilledRectangle(0, 0, w, h)
			lcd.color(WHITE)
			lcd.font(FONT_XL)
 			lcd.drawText(4,10,"direction = "..math.floor(180+360*widget.direction:value()/2048).."°")
			lcd.drawText(4,40,"LON = "..widget.point.lon.."°")
			lcd.drawText(4,70,"LAT = "..widget.point.lat.."°")
			lcd.drawText(4,100,"distance= "..widget.min.."m - "..widget.max.."m")
			lcd.drawText(4,130,"bearing = "..math.floor(widget.pointA:getBearing(widget.pointB:getRad())).."°")
		end
	end
end

local function wakeup(widget)
	local gpsLAT
	local gpsLON
	if (widget.gps ~= nil) and ((os.clock() - crossTime) >1)then
		local version=system.getVersion().minor
		if version < 5 then
       			gpsLAT = widget.gps:value(OPTION_LATITUDE)
       			gpsLON = widget.gps:value(OPTION_LONGITUDE)
		else
	       		gpsLAT = widget.gps:value({options=OPTION_LATITUDE})
       			gpsLON = widget.gps:value({options=OPTION_LONGITUDE})
		end
		widget.point:set(gpsLAT,gpsLON)

		if widget.startSet == widget.start:value() then
			-- running
			if widget.race.running == false then widget.race:start() end
			local r=false
			if widget.race.direction == widget.race.ENTER_BASE_A then
				r=widget.race:checkBcross(math.floor(widget.pointB:getBearing(widget.point:getRad())*10)/10)
        		elseif widget.race.direction == widget.race.ENTER_BASE_B then
                		r=widget.race:checkAcross(math.floor(widget.pointA:getBearing(widget.point:getRad())*10)/10)
        		else -- before first entry check negative crossing
                		r=widget.race:checkFirstAcross(math.floor(widget.pointA:getBearing(widget.point:getRad())*10)/10)
        			lcd.invalidate()
			end
			if r==true then 
				crossTime=os.clock()
				system.playTone(2400,30) 
				widget.race:increaseLaps()
				if widget.voice == true then system.playNumber(widget.race.lap) end
        			lcd.invalidate()
			end
		else
			widget.race.running=false
        		if widget.confirmSet == widget.confirm:value() then
				-- store position and course
				system.playTone(1200,30)
				widget.race:set(math.floor(180+360*widget.direction:value()/2048), widget.max)
				widget.pointA:set(gpsLAT,gpsLON)
				if widget.min ~= 0 then -- move base A position
					local A
					if widget.min > 0 then
                        			widget.race.distance = widget.max - widget.min
						A = widget.point:getPoint(widget.race.bearingPointA2B, widget.min) 
					else 
                        			widget.race.distance = widget.max + (-1*widget.min)
						A = widget.point:getPoint(widget.race.bearingPointB2A, (-1*widget.min))
					end
					widget.pointA:set(A.lat, A.lon)
				end
				local B = widget.pointA:getPoint(widget.race.bearingPointA2B, widget.race.distance)
				widget.pointB:set(B.lat, B.lon)
			end
        		lcd.invalidate()
		end
	end
end

local function read(widget)
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

local function write(widget)
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

local function init()
	system.registerWidget({key="taskb", name=name, create=create, paint=paint, wakeup=wakeup, configure=configure, read=read, write=write})
end

return {init=init}
