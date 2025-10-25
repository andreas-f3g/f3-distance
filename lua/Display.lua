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

Display = {}

Display.paint = function (widget)
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

return Display
