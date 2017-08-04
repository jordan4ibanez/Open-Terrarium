--the pause menu

pause = false

function pause_game()	
	--love.graphics.rectangle( "line", 10, 1, 53,53 )
	
end

function render_pause_menu()
	love.graphics.setFont(hugefont)
	love.graphics.print("PAUSED", love.graphics.getWidth( )/2-300,love.graphics.getHeight( )/2-50)
end
