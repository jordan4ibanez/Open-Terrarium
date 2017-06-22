--menu animation and info
menu = {}

mx,my = 1,1

menutitle = {}
menutitle.g = 50
menutitle.a = 50
menutitle.m = 50
menutitle.e = 50

menutimer = 0
pause = false

letter = 1

function menu.animate()
	if pause == false then
		menutimer = menutimer + 1
	end
	if menutimer > 20 then
	
		if letter == 1 then
			menutitle.g = menutitle.g + 2
		elseif letter == 2 then
			menutitle.a = menutitle.a + 2
		elseif letter == 3 then
			menutitle.m = menutitle.m + 2
		elseif letter == 4 then
			menutitle.e = menutitle.e + 2
		end
		if menutimer >= 40 then
			menutimer = 0
			letter = letter + 1
			if letter > 4 then
				letter = 1
			end
		end
	elseif menutimer <= 20 then
		if letter == 1 then
			menutitle.g = menutitle.g - 2
		elseif letter == 2 then
			menutitle.a = menutitle.a - 2
		elseif letter == 3 then
			menutitle.m = menutitle.m - 2
		elseif letter == 4 then
			menutitle.e = menutitle.e - 2
		end
		
	end
end

function menu.draw()
	
	menu.cursor()
	
	love.graphics.setFont(fontbig)
	love.graphics.setColor(255,0,0,255)
    love.graphics.print("D", 400, menutitle.g)
    love.graphics.print("I", 440, menutitle.a)
    love.graphics.print("G", 480, menutitle.m)
    love.graphics.print("!", 520, menutitle.e)

	--score debug
	love.graphics.setFont(fontmed)
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("Score:"..tostring(love.math.random(0,20000000)), 400,110)

	
	--debug mining
	if player.mining == true then
		love.graphics.setColor(255,0,0,255)
		love.graphics.print("Mining", 400,180)
		love.graphics.setColor(128,128,128,255)
		love.graphics.print("Placing", 560,180)
		
	elseif player.mining == false then		
		love.graphics.setColor(128,128,128,255)
		love.graphics.print("Mining", 400,180)
		love.graphics.setColor(255,0,0,255)
		love.graphics.print("Placing", 560,180)love.graphics.print("PosX:"..player.playerx.." PosY:"..player.playery, 400,150)
	end
	--debug player's pos
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("PosX:"..player.playerx.." PosY:"..player.playery, 400,150)
	--debug mouse's pos
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("MX:"..mx.." MY:"..my, 400,220)
	--debug selected item
	love.graphics.setColor(255,255,255,255)
	if player.selected == 1 then
		love.graphics.print("ITEM: #", 400,250)
	elseif player.selected == 2 then
		love.graphics.print("ITEM: /", 400,250)
	end
	love.graphics.print("Chunkx:"..chunkx.." Chunky:"..chunky, 400,280)
end

function menu.cursor()
	local x, y = love.mouse.getPosition( )
	local xx,yy = math.floor(x/scale),math.floor((y+3)/scale)
	--only change if in boundaries
	if ((xx >= 1 and xx <= mapwidth) and (yy >= 1 and yy <= mapheight)) and (math.abs(xx-player.playerx) <=5 and math.abs(yy-player.playery) <=5) then
		mx,my = xx,yy
	else
		mx,my = -1,-1
	end
	love.graphics.rectangle("line", (mx* scale), (my*scale)-3, scale, scale )

end
