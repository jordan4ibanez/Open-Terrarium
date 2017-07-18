
print("keep everything in memory until save, or until close game")

--textures: https://github.com/minetest-texturepacks/Good-Morning-Craft-Minetest

--the directory
debugGraph = require 'modules.debugGraph.debugGraph'

math.randomseed(os.time())


dofile("tserial.lua")
dofile("ore.lua")
dofile("map.lua")
dofile("menu.lua")
dofile("player.lua")
dofile("collision.lua")
dofile("physics.lua")

--the scale of the map
scale = 280

screenwidth = love.graphics.getWidth( )

screenheight = love.graphics.getHeight( )

function love.draw()
	maplib.draw()
	player.draw()
	menu.draw()  
	fpsGraph:draw()
	memGraph:draw()
	dtGraph:draw()
	player.draw_health()
end

function love.load()


	love.graphics.setDefaultFilter( "nearest", "nearest", 0 )
	
	load_player_textures()
	
	fpsGraph = debugGraph:new('fps', 600, 120,100,50,0.01)
	memGraph = debugGraph:new('mem', 600, 160,100,50,0.01)
	dtGraph = debugGraph:new('custom', 600, 190,100,50,0.01)
	
	maplib.createmap()
	
	font = love.graphics.newFont("font.ttf", 12)
	fontmed = love.graphics.newFont("font.ttf", 22)
	fontbig = love.graphics.newFont("font.ttf", 35)
	
	love.graphics.setFont(font)
	
	
	minesound = love.audio.newSource("mine.ogg", "static")
	placesound = love.audio.newSource("place.ogg", "static")
	stepsound = love.audio.newSource("step.ogg", "static")
	oof = love.audio.newSource("oof.ogg", "static")
	menu_music = love.audio.newSource("sounds/menu_music.ogg")
	menu_music:setLooping(true)
	
	
	texture_table = {}
	local i = 1
	for key,value in pairs(ore) do
		texture_table[i] = love.graphics.newImage("textures/"..value.image)
		i = i + 1
	end
	
	--playertexture = love.graphics.newImage("textures/player.png")
	heart = love.graphics.newImage("textures/heart.png")
	
	--menu_music:play()
end

function love.quit( )
	print("Thanks for playing!")
	return nil
end

function love.update(dt)

	maplib.load_chunks()
	fpsGraph:update(dt)
	memGraph:update(dt)
	-- Update our custom graph
	dtGraph:update(dt, math.floor(dt * 1000))
	dtGraph.label = 'DT: ' ..  dt
	
	menu.animate()
	mine(key)
	player.move_camera(dt)
	maplib.liquid_flow(dt)
	--debug
	if love.keyboard.isDown("space") then
		print("clear")
	end
	move(dt)
	physics.player_x_apply(dt)
	physics.gravity()
	maplib.new_block(player.playerx,player.playery)
end
