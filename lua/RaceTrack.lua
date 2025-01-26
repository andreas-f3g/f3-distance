-- Lua Race Class
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

local RaceTrack = {}

RaceTrack.new = function (self, object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

RaceTrack.NOT_STARTED=0
RaceTrack.ENTER_BASE_A=1
RaceTrack.ENTER_BASE_B=2

RaceTrack.set = function (self, bearing2B, distance2B)
  self.NOT_STARTED=0
  self.ENTER_BASE_A=1
  self.ENTER_BASE_B=2
  self.distance=distance2B -- meter
  self.direction=self.NOT_STARTED -- 0=nostart@A, 1=entry@A, 2=entry@B
  self.lap=-1
  self.running=false
  self.bearingPointA2B=bearing2B
  self.relCourse2PointA={} -- array 0..359 is not lua like!
  self.relCourse2PointA=self.setCrossing(self.relCourse2PointA, self.bearingPointA2B)
  self.aCrossed=0  
  self.bearingPointB2A=(bearing2B+180)%360
  self.relCourse2PointB={} -- array 0..359 is not lua like!
  self.relCourse2PointB=self.setCrossing(self.relCourse2PointB, self.bearingPointB2A)
  self.bCrossed=0  
end

RaceTrack.start = function (self)
  self.lap=-1
  self.running=true
  self.direction=self.NOT_STARTED
end

RaceTrack.setCrossing = function(relCourse, bearing)
	local course=math.abs(bearing)
	local c=0
	for i=course,(course+360) do
        	local j = i %360
        	relCourse[j]=c
        	if c == 180 then 
                	c=-180
        	end
        	c=c+1   
	end
	return relCourse
end

RaceTrack.checkFirstAcross = function(self,bearing)
	if math.abs(self.relCourse2PointA[bearing]) <= 90 then
			self.direction=self.ENTER_BASE_A
			return true, "A", self.relCourse2PointA[bearing]
	else
			return false, "A", self.relCourse2PointA[bearing]
	end
end

RaceTrack.checkAcross = function(self,bearing)
	if math.abs(self.relCourse2PointA[bearing]) >= 90 then
		self.direction=self.ENTER_BASE_A
		return true, "A", self.relCourse2PointA[bearing]
	else
		return false, "A", self.relCourse2PointA[bearing]
	end
end

RaceTrack.checkBcross = function(self,bearing)
	if math.abs(self.relCourse2PointB[bearing]) >= 90 then
		self.direction=self.ENTER_BASE_B
		return true, "B", self.relCourse2PointB[bearing]
	else
		return false, "B", self.relCourse2PointB[bearing]
	end
end

RaceTrack.getDirection = function(self)
 	return self.direction -- 0=nostart@A, 1=entry@A, 2=entry@B
end

RaceTrack.increaseLaps = function(self)
	self.lap = self.lap + 1
end

return RaceTrack
