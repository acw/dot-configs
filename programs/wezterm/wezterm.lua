local wezterm = require "wezterm";
local config = {}

config.font = wezterm.font("GeistMono Nerd Font Mono")
config.font_size = 14

config.hide_tab_bar_if_only_one_tab = false

config.window_background_opacity = 0.9

config.ssh_domains = {
  { name = "mensah",
    remote_address = "100.71.249.5",
    username = "awick",
  },
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
    local title = tab.tab_index .. ": " .. tab_title(tab)
    title = wezterm.truncate_right(title, max_width - 2)

    if tab.is_active then
      return {
        { Foreground = { Color = "Yellow" } },
        { Text = title },
      }
    else
      return { { text = title } }
    end
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
    if meta.is_tardy then
      local msecs = meta.since_last_response_ms
      window.set_right_status(string.format('tardy: %5fms', msecs))
    end
  end
)

return config
