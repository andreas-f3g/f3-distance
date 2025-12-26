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


GPS = {}

GPS.readPosition = function (widget)
	local gpsLAT=0
	local gpsLON=0
	if   ( (widget.gps ~= nil) ) then
		local version = system.getVersion().minor
			if version < 5 then
       				gpsLAT = widget.gps:value(OPTION_LATITUDE)
       				gpsLON = widget.gps:value(OPTION_LONGITUDE)
			else
	       			gpsLAT = widget.gps:value({options=OPTION_LATITUDE})
       				gpsLON = widget.gps:value({options=OPTION_LONGITUDE})
			end
	end
	return gpsLAT, gpsLON
end

return GPS
