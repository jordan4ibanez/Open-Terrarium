--the pause menu

pause = false

function pause_game()	
	--love.graphics.rectangle( "line", 10, 1, 53,53 )
	
end

--menu items
pause_menu_items = {
"GRAPHICS",
"VOLUME",
"WORLD",
"EXIT"

}

--Font:getHeight( )

function render_pause_menu()
	
	--menu title
	love.graphics.setColor(255,255,255,255)
	love.graphics.setFont(hugefont)
	love.graphics.print("GAME MENU", love.graphics.getWidth( )/2-(hugefont:getWidth("GAME MENU")/2),50)
	
	
	--directories
	
	local starter_y = 250
	local ier = 0
	
	for _,item in pairs(pause_menu_items) do
		love.graphics.setColor(255,255,255,255)
		love.graphics.rectangle( "fill", love.graphics.getWidth( )/2-(fontbig:getWidth(item)/2)-2, 250-9+(ier*100),fontbig:getWidth(item), fontbig:getHeight(item) )
		---
		love.graphics.setColor(0,0,0,255)
		love.graphics.setFont(fontbig)
		love.graphics.print(item, love.graphics.getWidth( )/2-(fontbig:getWidth(item)/2),250+(ier*100))
		
		ier = ier + 1
	end
		
	
	--love.graphics.setColor(80,80,80,255)
end
