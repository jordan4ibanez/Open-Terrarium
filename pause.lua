--the pause menu

pause = false

function pause_game()	
	--love.graphics.rectangle( "line", 10, 1, 53,53 )
	
end

--Font:getHeight( )

function render_pause_menu()
	
	--menu title
	love.graphics.setColor(255,255,255,255)
	love.graphics.setFont(hugefont)
	love.graphics.print("GAME MENU", love.graphics.getWidth( )/2-(hugefont:getWidth("GAME MENU")/2),50)
	
	
	--directories
	
	
	--graphics
	love.graphics.setColor(255,255,255,255)
	love.graphics.rectangle( "fill", love.graphics.getWidth( )/2-(fontbig:getWidth("GRAPHICS")/2)-2, 250-9,fontbig:getWidth("GRAPHICS"), fontbig:getHeight("GRAPHICS") )
	---
	love.graphics.setColor(0,0,0,255)
	love.graphics.setFont(fontbig)
	love.graphics.print("GRAPHICS", love.graphics.getWidth( )/2-(fontbig:getWidth("GRAPHICS")/2),250)
	
	--volume
	love.graphics.setColor(255,255,255,255)
	love.graphics.rectangle( "fill", love.graphics.getWidth( )/2-(fontbig:getWidth("VOLUME")/2)-2, 350-9,fontbig:getWidth("VOLUME"), fontbig:getHeight("VOLUME") )
	---
	love.graphics.setColor(0,0,0,255)
	love.graphics.setFont(fontbig)
	love.graphics.print("VOLUME", love.graphics.getWidth( )/2-(fontbig:getWidth("VOLUME")/2),350)
	
	--world
	love.graphics.setColor(255,255,255,255)
	love.graphics.rectangle( "fill", love.graphics.getWidth( )/2-(fontbig:getWidth("WORLD")/2)-2, 450-9,fontbig:getWidth("WORLD"), fontbig:getHeight("WORLD") )
	---
	love.graphics.setColor(0,0,0,255)
	love.graphics.setFont(fontbig)
	love.graphics.print("WORLD", love.graphics.getWidth( )/2-(fontbig:getWidth("WORLD")/2),450)
	
	--exit
	love.graphics.setColor(255,255,255,255)
	love.graphics.rectangle( "fill", love.graphics.getWidth( )/2-(fontbig:getWidth("EXIT")/2)-2, 550-9,fontbig:getWidth("EXIT"), fontbig:getHeight("EXIT") )
	---
	love.graphics.setColor(0,0,0,255)
	love.graphics.setFont(fontbig)
	love.graphics.print("EXIT", love.graphics.getWidth( )/2-(fontbig:getWidth("EXIT")/2),550)
	
	
	--love.graphics.setColor(80,80,80,255)
end
