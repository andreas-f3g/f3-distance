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


Event = {}

Display.wakeup = function (widget)
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

return Event
