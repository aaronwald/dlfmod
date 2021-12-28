

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
        style="coypu_small_button"
    }

-- https://wiki.factorio.com/Rich_text
    frame.add{
        type = "label",
        style = "bold_label", 
        caption = "Iron 1m " .. player.force.item_production_statistics.get_flow_count{name="iron-ore",output=False,precision_index=defines.flow_precision_index.one_minute}
    }


    -- /c game.print(game.player.gui.is_valid_sprite_path("file/__core__/graphics/questionmark"))

    -- for k,v in pairs (player.force.item_production_statistics.output_counts) do
    	-- game.print(k)
    -- end

 --    player.gui.top.add{type="label", name="greeting", caption="Hi"}
	-- player.gui.top.greeting.caption = "Hello there!"
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

script.on_init(on_init)
