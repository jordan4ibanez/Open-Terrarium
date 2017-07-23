--the entity library


--hold the library
entity = {}

--store all the entities
entity_table = {}
entity_count = 0


--create entities
function entity.create_entity(type,sizex,sizey,texture,chunkx,chunky,posx,posy)
	entity_count = entity_count + 1
	entity_table[entity_count] = {}
	entity_table[entity_count]["sizex"] = sizex
	entity_table[entity_count]["sizey"] = sizey
	entity_table[entity_count]["texture"] = texture
	entity_table[entity_count]["chunkx"] = chunkx
	entity_table[entity_count]["chunky"] = chunky
	entity_table[entity_count]["posx"] = posx
	entity_table[entity_count]["posy"] = posy
end

--draw entities
function entity.render_entity()
	if entity_count > 0 then
		for i = 1,entity_count do
			local drawx = player_drawnx+(entity_table[i]["posx"]*scale)+(map_max*scale*(entity_table[i]["chunkx"]-chunkx))-(player.playerx*scale)
			local drawy = player_drawny+(entity_table[i]["posy"]*scale)+(map_max*scale*(chunky-entity_table[i]["chunky"]))-(player.playery*scale)
			love.graphics.draw(entity_table[i]["texture"],  drawx,drawy,0, scale/16*entity_table[i]["sizex"], scale/16*entity_table[i]["sizey"],scale*(entity_table[i]["sizex"]*4)/16,scale*(entity_table[i]["sizey"]*4)/16)
		
		end
	end
end
