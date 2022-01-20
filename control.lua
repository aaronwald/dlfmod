

function update_gui_frame(player)
    frame = player.gui.left["coypu-frame"]

    if frame then
        frame.destroy()
        -- return
    end

    ------------------
    -- Caluclate ETA
    ------------------

    -- current_percentage_value = game.forces.player.research_progress
    -- delta_percentage_value = current_percentage_value - global.last_percentage
    -- remaining_percentage_value = 1 - current_percentage_value
    -- remaining_percentage_chunks = remaining_percentage_value / delta_percentage_value
    -- remaining_time_seconds = 2 * remaining_percentage_chunks


    --------------
    -- Build gui
    --------------

    frame = player.gui.left.add{
        type = "frame",
        caption = {""},
        name = "coypu-frame",
        direction = "horizontal"
    }

   frame.add{
        type="sprite-button",
        sprite="item/iron-ore",
        style="coypu_small_button",
        name="killall"
    }

   frame.add{
        type="sprite-button",
        sprite="item/copper-ore",
        style="coypu_small_button",
        name="killeverything"
    }

-- game.forces["enemy"].kill_all_units()
-- https://wiki.factorio.com/Rich_text
    frame.add{
        type = "label",
        style = "bold_label", 
        caption = "Iron 1m " .. player.force.item_production_statistics.get_flow_count{name="iron-ore",output=False,precision_index=defines.flow_precision_index.one_minute}
    }


    json = "{\"production\":" .. game.table_to_json(player.force.item_production_statistics.output_counts) .. ",\n"
    json = json .. "\"fluid\":" .. game.table_to_json(player.force.fluid_production_statistics.output_counts) .. ",\n"
    json = json .. "\"kills\":" .. game.table_to_json(player.force.kill_count_statistics.output_counts) .. ",\n"
    json = json .. "\"build\":" .. game.table_to_json(player.force.entity_build_count_statistics.output_counts) .. "\n"
    json = json .. "}\n"
    game.write_file("coypu_" .. game.tick .. ".json", json, true, 1)


    last_tick = "" .. game.tick
    game.write_file("coypu.tick", last_tick, false, 1)

    -- player.force.item_production_statistics.get_flow_count{name="iron-ore",output=False,precision_index=defines.flow_precision_index.one_minute} 

    -- game.print(game.table_to_json(player.force.item_production_statistics.output_counts))
    -- for k,v in pairs (player.force.item_production_statistics.output_counts) do
    --     game.print(k)
    -- end

end

function refresh_gui()
    for _, player in pairs(game.players) do
        update_gui_frame(player)
    end
end



local function on_init()
    for _, player in pairs(game.players) do
        update_gui_frame(player)
    end


--     local tabbed_pane = game.player.gui.top.add{type="tabbed-pane"}
-- local tab1 = tabbed_pane.add{type="tab", caption="Tab 1"}
-- local tab2 = tabbed_pane.add{type="tab", caption="Tab 2"}
-- local label1 = tabbed_pane.add{type="label", caption="Label 1"}
-- local label2 = tabbed_pane.add{type="label", caption="Label 2"}
-- tabbed_pane.add_tab(tab1, label1)
-- tabbed_pane.add_tab(tab2, label2)
end

script.on_nth_tick(100, 
	function(event) 
		refresh_gui()
		-- game.print("tock:" .. event.tick)
	end
)

script.on_event(
	defines.events.on_player_created,
	function(event)
	   game.print('foo')
	end
)

script.on_event(
    defines.events.on_gui_click,
    function(event)
        -- https://wiki.factorio.com/Console
        if event.element.name == "killall" then
            game.forces["enemy"].kill_all_units()
        elseif event.element.name == "killeverything" then
            for _, player in pairs(game.players) do
                local surface=player.surface
                for key, entity in pairs(surface.find_entities_filtered({force="enemy"})) do
                    entity.destroy()
                end
            end
        end
        game.print('gui click' .. event.element.name)
    end
)

script.on_init(on_init)
