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

if Configure == nil then
Configure=dofile("Configure.lua")
end

if Display == nil then
Display=dofile("Display.lua")
end

if Event == nil then
Event=dofile("Event.lua")
end

local function create ()
	return Configure.create()
end

local function config (widget)
	Configure.config(widget)
end

local function read (widget)
	Configure.read(widget)
end

local function write (widget)
	Configure.write(widget)
end

init = function ()
        system.registerWidget({key="taskb", name=Configure.Name, create=create, paint=Display.paint, wakeup=Event.wakeup, configure=config, read=read, write=write})
end 

return {init=init}
