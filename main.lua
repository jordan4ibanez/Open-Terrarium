dofile("player.lua")
dofile("map.lua")

function love.draw()
	maplib.draw()
	player.draw()	   
end

function love.load()
	maplib.createmap()
end


function love.update(dt)
	player.test()
end
