
math.randomseed( os.time() )

--the map library
maplib = {}



--create tiles
mapheight = 48
mapwidth  = 30
tiles = {}
function maplib.createmap()
	for x = 1,mapwidth do
		tiles[x] = {}
		for y = 1,mapheight do
			tiles[x][y] =  {}
			
			local randomtile = math.random(0,1)
			if randomtile == 0 then
				tiles[x][y]["block"] = 0
			elseif randomtile == 1 then
				tiles[x][y]["block"] = 1
			end
		end
	end
end

--executed in love.draw to draw map
function maplib.draw()
	love.graphics.setFont(font)
	love.graphics.setColor(255,255,255,255)
	for x = 1,mapwidth do
		for y = 1,mapheight do
			local graphic
			if tiles[x][y]["block"] == 0 then
				graphic = ""
			elseif tiles[x][y]["block"] == 1 then
				graphic = "#"
			end
			love.graphics.print(graphic, x*scale, y*scale)
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
