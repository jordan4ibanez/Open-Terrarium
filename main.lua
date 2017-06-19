dofile("player.lua")
dofile("map.lua")
dofile("menu.lua")

function love.draw()
	maplib.draw()
	player.draw()
	menu.draw()   
end

function love.load()
	maplib.createmap()
	font = love.graphics.newFont("font.ttf", 12)
	fontmed = love.graphics.newFont("font.ttf", 22)
	fontbig = love.graphics.newFont("font.ttf", 35)
	love.graphics.setFont(font)
end


function love.update(dt)
	player.test()
	menu.animate()
end
