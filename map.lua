
math.randomseed( os.time() )

--the map library
maplib = {}



--create tiles
mapheight = 48
mapwidth  = 50
tiles = {}
function maplib.createmap()
	for x = 1,mapwidth do
		tiles[x] = {}
		for y = 1,mapheight do
			tiles[x][y] =  {}
			
			local randomtile = math.random(0,1)
			if randomtile == 0 then
				tiles[x][y]["tile"] = ""
			elseif randomtile == 1 then
				tiles[x][y]["tile"] = "*"
			end
		end
	end
end

--executed in love.draw to draw map
function maplib.draw()
	love.graphics.setColor(255,255,255,255)
	for x = 1,mapwidth do
		for y = 1,mapheight do
			love.graphics.print(tiles[x][y]["tile"], x*12, y*12)
		end
	end
end

--[[ a test
for x = 1,10 do
	local line = ""
	for y = 1,10 do
		line = line..tiles.x.y
	end
	print(line.."\n")
end

]]--
