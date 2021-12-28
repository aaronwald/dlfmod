--data.lua

require("item")
local styles = data.raw["gui-style"].default


styles.coypu_small_button = {
  type = "button_style",
  parent = "frame_button",
  width = 24,
  height = 24,
  padding = 0
}