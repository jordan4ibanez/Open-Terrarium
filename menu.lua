--menu animation and info
menu = {}


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

	love.graphics.setFont(fontbig)
	love.graphics.setColor(255,0,0,255)
    love.graphics.print("D", 400, menutitle.g)
    love.graphics.print("I", 440, menutitle.a)
    love.graphics.print("G", 480, menutitle.m)
    love.graphics.print("!", 520, menutitle.e)

	--score debug
	love.graphics.setFont(fontmed)
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("Score:"..tostring(math.random(0,20000000)), 400,110)
	
	--debug player's pos
	love.graphics.print("PosX:"..player.playerx.." PosY:"..player.playery, 400,150)
end
