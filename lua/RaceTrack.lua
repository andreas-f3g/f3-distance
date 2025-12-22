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

RaceTrack.NOT_STARTED=0
RaceTrack.ENTER_BASE_A=1
RaceTrack.ENTER_BASE_B=2

RaceTrack.set = function (self, bearing2B, distance2B)
  self.distance=distance2B -- meter
  self.direction=self.NOT_STARTED -- 0=nostart@A, 1=entry@A, 2=entry@B
  self.lap=-1
  self.running=false
  self.bearingPointA2B=bearing2B
  self.bearingPointB2A=(bearing2B+180)%360
end

RaceTrack.start = function (self)
  self.lap=-1
  self.running=true
  self.direction=self.NOT_STARTED
end

RaceTrack.checkCrossing = function (self,base,gps)
	if ((base+270) < gps+360) or ((base+450) > (gps+360)) then
		return true
	end
	return false
end

RaceTrack.checkFirstAcross = function(self,bearing)
	if not self.checkCrossing(self,self.bearingPointA2B,bearing) then
		self.direction=self.ENTER_BASE_A
		return true
	end
	return false
end

RaceTrack.checkAcross = function(self,bearing)
	if self.checkself.Crossing(self.bearingPointA2B,bearing) then
		self.direction=self.ENTER_BASE_A
		return true
	end
	return false
end

RaceTrack.checkBcross = function(self,bearing)
	if self.checkCrossing(self.bearingPointB2A,bearing) then
		self.direction=self.ENTER_BASE_B
		return true
	end
	return false
end

RaceTrack.getDirection = function(self)
 	return self.direction -- 0=nostart@A, 1=entry@A, 2=entry@B
end

RaceTrack.increaseLaps = function(self)
	self.lap = self.lap + 1
end

return RaceTrack
