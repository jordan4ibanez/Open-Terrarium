--textures: https://github.com/minetest-texturepacks/Good-Morning-Craft-Minetest

--the directory
dir = love.filesystem.getAppdataDirectory( )

math.randomseed(os.time())

dofile("tserial.lua")
dofile("ore.lua")
dofile("map.lua")
dofile("menu.lua")
dofile("collision.lua")
dofile("player.lua")

--the scale of the map
scale = 16

screenwidth = love.graphics.getWidth( )

screenheight = love.graphics.getHeight( )

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
	
	playertexture = love.graphics.newImage("textures/player.png")
	
	menu_music:play()
end

function love.quit( )
	print("Thanks for playing!")
	return nil
end

function love.update(dt)
	menu.animate()
	mine(key)
	gravity(dt)
	player.move_camera(dt)
	maplib.liquid_flow(dt)
	--debug
	if love.keyboard.isDown("space") then
		print("clear")
	end
	move(dt)
end
