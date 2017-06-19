--the player library
player = {}
player.playerx,player.playery = 0,0

--controls
function player.test()
	if love.keyboard.isDown("left") then
      player.playerx = player.playerx - 1
	end
	if love.keyboard.isDown("right") then
      player.playerx = player.playerx + 1
	end
	
	if love.keyboard.isDown("up") then
      player.playery = player.playery - 1
	end
	if love.keyboard.isDown("down") then
      player.playery = player.playery + 1
	end
end

function player.draw()
	love.graphics.setFont(font)
	love.graphics.setColor(255,0,0,255)
    love.graphics.print("8", player.playerx, player.playery)
end
