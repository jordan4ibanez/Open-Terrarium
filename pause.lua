--the pause menu

pause = false

--menu items
pause_menu_items = {
"GRAPHICS",
"VOLUME",
"WORLD",
"EXIT"
}

pause_menu_submenu = nil

function pause_game()	
	local x, y = love.mouse.getPosition( )
	local starter_y = 250
	local ier = 0
	pause_menu_submenu = nil
	for _,item in pairs(pause_menu_items) do
		if x > love.graphics.getWidth( )/2-(fontbig:getWidth(item)/2)-2 and love.graphics.getWidth( )/2-(fontbig:getWidth(item)/2)-2 +fontbig:getWidth(item) and 
			y > starter_y-9+(ier*100) and y < starter_y-9+(ier*100) +  fontbig:getHeight(item) then
			pause_menu_submenu = item
		end
		ier = ier + 1
	end
		--starter_y-9+(ier*100),fontbig:getWidth(item), fontbig:getHeight(item)
	
end



function render_pause_menu()
	
	--menu title
	love.graphics.setColor(255,255,255,255)
	love.graphics.setFont(hugefont)
	love.graphics.print("GAME MENU", love.graphics.getWidth( )/2-(hugefont:getWidth("GAME MENU")/2),50)
	
	
	--directories
	
	local starter_y = 250
	local ier = 0
	
	for _,item in pairs(pause_menu_items) do
		--selection
		if pause_menu_submenu == item then
			love.graphics.setColor(255,0,0,255)
			love.graphics.rectangle( "fill", love.graphics.getWidth( )/2-(fontbig:getWidth(item)/2)-5, starter_y-9+(ier*100)-5,fontbig:getWidth(item)+10, fontbig:getHeight(item)+10 )
		end
		--
		love.graphics.setColor(255,255,255,255)
		love.graphics.rectangle( "fill", love.graphics.getWidth( )/2-(fontbig:getWidth(item)/2)-2, starter_y-9+(ier*100),fontbig:getWidth(item), fontbig:getHeight(item) )
		---
		love.graphics.setColor(0,0,0,255)
		love.graphics.setFont(fontbig)
		love.graphics.print(item, love.graphics.getWidth( )/2-(fontbig:getWidth(item)/2),starter_y+(ier*100))
		
		
		
		ier = ier + 1
	end
	love.graphics.setColor(100,100,100,255)
end
