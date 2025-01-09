-- Task B Helper

local GPSPoint=require("GPSPoint")

local PointA=GPSPoint.new(GPSPoint)
local PointB=GPSPoint.new(GPSPoint)
local PointX=GPSPoint.new(GPSPoint)

if Track == nil then
Track=dofile("RaceTrack.lua")
end

Race=Track

PointX:set(0,0)

-- Huckarde Points
PointA:set(51.546700,7.412600)

lat, lon = PointA:get()
print ("Point A lat="..lat)
print ("Point A lon="..lon)

Race:set(320,150)
--Race.bearingPointA2B=320
--Race.distance=150

local B = PointA:getPoint(Race.bearingPointA2B, Race.distance)
print ("A->B: "..(B.lat)..", "..(B.lon))

PointB:set(B.lat, B.lon)
lat, lon = PointB:get()

print ("Point B lat="..lat)
print ("Point B lon="..lon)

print ("Angle A TO B  : "..(PointA:getBearing(PointB:getRad())).."°")
print ("Distance A->B : "..(PointA:getDistance(PointB:getRad())).." m")

print ""

PointX:set(51.546750,7.412701)
--print ("to go 1: "..PointA:getBearing(PointX:getRad()).."°,")

--print ""

--for i=0, 359, 1 do
--print(i.."="..Race.relCourse2PointB[i])
--end


function testCross(bearing)
	local boolean2string={[true]="true", [false]="false"} 
--	local r, d, b =Race:checkCross(bearing)

                if Race.direction == Race.ENTER_BASE_A then
                        r,d,b=Race:checkBcross(math.floor(bearing))
                elseif Race.direction == Race.ENTER_BASE_B then
                        r,d,b=Race:checkAcross(math.floor(bearing))
                else -- before first entry check negative crossing
                        r,d,b=Race:checkFirstAcross(math.floor(bearing))
                end

	print("Course: "..bearing.." Base "..d..": "..b.."°".." cross=="..boolean2string[r])
	if r == true then print("beep direction="..Race.direction) end
end

testCross(200)
testCross(200)
testCross(90)
testCross(90)
testCross(90)
testCross(90)
testCross(90)
testCross(195)
testCross(195)
testCross(195)
testCross(195)
testCross(92)
testCross(92)
testCross(92)
testCross(92)
testCross(310)
testCross(310)
testCross(310)
testCross(310)
testCross(140)
testCross(140)
testCross(140)
testCross(310)
testCross(310)


