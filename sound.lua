--play sounds at random pitch
function sound_play(sound,min,max)
	sound:setPitch(love.math.random(min,max)/100)
	sound:stop()
	sound:play()
end


