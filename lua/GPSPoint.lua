-- Lua GPS Point Class
--
--  F3 Distance Tool for FRSky/ETHOS transmitters and GPS telemetry
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


local Point = {}

local R = 6371000 -- radius of the earth in metres

Point.new = function (self, object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

Point.set = function (self, lat, lon)
  self.lat=lat
  self.lon=lon
  self.latRad=math.rad(lat)
  self.lonRad=math.rad(lon)
end

Point.get = function(self)
  return self.lat, self.lon
end

Point.getRad = function(self)
  return self.latRad, self.lonRad
end

Point.getLat = function(self)
  return self.lat
end

Point.getLon = function(self)
  return self.lon
end

Point.getBearing =function (self, lat, lon)

  local bearing = math.deg(math.atan(
		    math.sin(lon - self.lonRad) * math.cos(lat), 
		    math.cos(self.latRad) * math.sin(lat) - math.sin(self.latRad) * math.cos(lat) * math.cos(lat - self.latRad)
		  ))
  if bearing < 0 then   
    bearing = 360 + bearing
  end
  return bearing
end

Point.getDistance = function(self, lat, lon)
  local a = math.sin((lat - self.latRad) / 2)^2 + math.cos(self.latRad) * math.cos(lat) * math.sin((lon - self.lonRad) / 2)^2
  return math.floor( R * 2 * math.atan(math.atan(math.sqrt(a), math.sqrt(1-a))))
end

Point.getPoint = function(self, deg, distance)
  local b = math.rad(deg)
  local d = distance/R
  local latTo = math.asin(math.sin(self.latRad) * math.cos(d) + math.cos(self.latRad) * math.sin(d) * math.cos(b))
  local lonTo = self.lonRad + math.atan(math.atan(math.sin(b) * math.sin(d) * math.cos(self.latRad),
						  math.cos(d) - math.sin(self.latRad) * math.sin(latTo)))
  return {lat=math.deg(latTo), lon=math.deg(lonTo)}
end

return Point
