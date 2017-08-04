--terminal

terminal = false
terminal_history = "--------\n"
terminal_input = ""

function render_terminal()
	love.graphics.setColor(0,0,0,155)
	love.graphics.rectangle( "fill", 0, 0,love.graphics.getWidth(), fontbig:getHeight("ABCDEFG")+7 )
	
	love.graphics.setColor(255,255,255,200)
	love.graphics.rectangle( "fill", 0, fontbig:getHeight("ABCDEFG")+7,love.graphics.getWidth(), 3 )
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.setFont(fontbig)
	--push text back
	if fontbig:getWidth(terminal_input..blink_cursor)> love.graphics.getWidth() then
		love.graphics.print(terminal_input..blink_cursor, -(fontbig:getWidth(terminal_input..blink_cursor)-love.graphics.getWidth()),12)
	else
		love.graphics.print(terminal_input..blink_cursor, 0,12)
	end
end

blink_cursor = "/"
blink_timer = 0
function terminal_logic(dt)
	blink_timer = blink_timer + dt
	
	if blink_timer > 0.5 then
		if blink_cursor == "/" then
			blink_cursor = " "
			blink_timer = 0
		elseif blink_cursor == " " then
			blink_cursor = "/"
			blink_timer = 0
		end
	end
	
	if globalkey then
	
		if (globalkey:match("w")) then
			--print("globalkey bad")
		end
		
		if globalkey == "return" then
			terminal_history = terminal_history..terminal_input.."\n"
			terminal_input = ""
		elseif globalkey == "backspace" then
			terminal_input = terminal_input:sub(1, -2)
		elseif globalkey == "space" then
			terminal_input = terminal_input.." "
		elseif globalkey == "f1" then
			print(terminal_history)
		else
			terminal_input = terminal_input..globalkey
		end
		
		globalkey = nil
	end
end
