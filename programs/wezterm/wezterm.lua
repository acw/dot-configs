local wezterm = require "wezterm";
local config = {}

config.font = wezterm.font("GeistMono Nerd Font Mono")
config.font_size = 14
config.line_height = 1.1
config.hide_tab_bar_if_only_one_tab = false
config.window_background_opacity = 0.9

local function standard_domain(name, address)
  return {
    name = name,
    remote_address = address,
    username = "awick",
    local_echo_threshold_ms = 10,
  }
end

config.ssh_domains = {
  standard_domain("mensah","100.71.249.5"),
  standard_domain("graf", "100.76.80.63"),
  standard_domain("origin", "100.74.8.5"),
  standard_domain("grendel", "100.74.37.1"),
}

config.window_frame = {
  font_size = 16.0,
}

config.leader = {
  key = "b",
  mods = "CTRL",
  timeout_milliseconds = 1000,
}

local function leader_key(key, action)
  return {
    mods = "LEADER",
    key = key,
    action = action,
  }
end

config.keys = {
  leader_key("c", wezterm.action.SpawnTab "CurrentPaneDomain"),
  leader_key("x", wezterm.action.CloseCurrentPane { confirm = true }),
  leader_key("b", wezterm.action.ActivateTabRelative(-1) ),
  leader_key("o", wezterm.action.ActivateTabRelative(1) ),
  leader_key("v", wezterm.action.SplitHorizontal{ domain = "CurrentPaneDomain" }),
  leader_key("s", wezterm.action.SplitVertical{ domain = "CurrentPaneDomain" }),
  leader_key("h", wezterm.action.ActivatePaneDirection("Left")),
  leader_key("j", wezterm.action.ActivatePaneDirection("Down")),
  leader_key("k", wezterm.action.ActivatePaneDirection("Up")),
  leader_key("l", wezterm.action.ActivatePaneDirection("Right")),

  leader_key("t", wezterm.action.PromptInputLine {
      description = 'New name for tab',
      initial_value = 'Name',
      action = wezterm.action_callback(function(window, _, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),

}

for i = 0, 9 do
  table.insert(config.keys, leader_key(tostring(i), wezterm.action.ActivateTab(i)))
end

local function tab_title(tab_info)
  local title = tab_info.tab_title

  if title and #title > 0 then
    return title
  end

  return tab_info.active_pane.title
end

wezterm.on("format-tab-title",
  function(tab, _, _, _ , _, max_width)
    local title = tab.tab_index .. " - " .. tab_title(tab)
    local background = "#999999"
    local foreground = "#000000"

    if tab.is_active then
      background = "#FFFF99"
    end

    return {
      { Attribute = { Intensity = "Bold" } },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = wezterm.truncate_right(title, max_width - 2) },
    }
  end
)

wezterm.on("update-status",
  function(window, pane)
    local prefix = "     "

    if window:leader_is_active() then
      prefix = " " .. utf8.char(0x1f30a)
    end

    window:set_left_status(wezterm.format {
      { Text = prefix },
    })

    local meta = pane:get_metadata() or {}
    local right = wezterm.time.now():format("%A, %B %d — %I:%M%p")
      .. wezterm.time.now():format_utc(" (%H:%M UTC)")

    if meta.is_tardy then
      local msecs = meta.since_last_response_ms
      right = right .. string.format(' [tardy: %5fms]', msecs)
    end

    window:set_right_status(wezterm.format {
      { Text = right .. " " },
    })
  end)

return config
