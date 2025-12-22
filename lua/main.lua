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

if Conf == nil then
Conf=dofile("Configure.lua")
end

if Display == nil then
Display=dofile("Display.lua")
end

if Event == nil then
Event=dofile("Event.lua")
end


local function create ()
        red=lcd.RGB(255,0,0)
        Track:set(0,0)
        return {color=Conf.red, min=0, max=150, confirm=nil, confirmSet=0, direction=nil, directionValue=0, gps=nil, point=GPSPoint.new(GPSPoint), pointA=GPSPoint.new(GPSPoint), pointB=GPSPoint.new(GPSPoint), race=Track, start=nil, startSet=0, timer=nil, voice=false}
end


local function init ()
        system.registerWidget({key="taskb", name=Conf.Name, create=create, paint=Display.paint, wakeup=Event.wakeup, configure=Conf.config, read=Conf.read, write=Conf.write})
end 

return {init=init}
