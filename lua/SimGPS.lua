-- Lua simulte telemetry data
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


GPS = {}

GPS.readPosition = function (widget)
	local lat=0
	local lon=0
	if   ( (widget.gps ~= nil) ) then
--			local A = widget.pointA:getPoint(widget.race.bearingPointB2A,math.floor(widget.direction:value()/5))
		lat, lon = widget.pointA:get()
		if widget.param1 ~= nil then
	 		lat, lon = widget.pointA:getPoint(widget.race.bearingPointB2A,math.floor(widget.param1:value()/5))
		end
	end
	return lat, lon
end

return GPS
