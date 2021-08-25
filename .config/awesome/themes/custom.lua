--------------------------
-- Custom awesome theme --
--------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local home_dir = '/home/anderson/'
local this_dir = home_dir .. '.config/awesome/themes/'

local theme = {}

--theme.font = "RobotoMono Nerd Font 9"
--theme.font = "DejavuSansMono Nerd Font Medium 10"
--theme.font = "Nimbus Sans Regular 11"
--theme.font = "Roboto Regular 11"
--theme.font = "RobotoMono Nerd Font 10"
theme.font = "RobotoMono Nerd Font 10"
-- theme.font = "Terminus 10"
-- theme.font_smaller = "Monospace 8"
theme.font_smaller = "DejaVu Sans Book 8"

theme.fg_normal = '#FFFFFFC0'
theme.bg_normal = '#000000'
--theme.bg_lit = '#D6493780'
theme.bg_lit = '#FF004480'
--theme.fg_icon = '#FF0044'
theme.fg_icon = '#FFFFFF'
theme.fg_text = theme.fg_normal
theme.fg_graph = theme.fg_text
--theme.bg_focus = "#D64937"
theme.bg_focus = "#FF0044"
theme.bg_urgent = "#000000"
theme.bg_weak = "#FFFFFF44"
theme.fg_danger = "#FF0044"

--theme.fg_ping = '#44B7F7'
--theme.fg_ping_warning = '#FF0087'
--theme.fg_battery = '#44B7F7'
--theme.fg_battery_warning = '#FF0087'
--theme.fg_battery_charging = '#00FF5F'
----theme.fg_date = '#00FF5F'
--theme.fg_date = '#44B7F7'
--theme.fg_date_today = '#000000'
--theme.bg_date_today = '#FF0087'
----theme.fg_date = '#44B7F7'
--theme.fg_volume = '#44B7F7'
--theme.fg_term = '#44B7F7'
--theme.fg_mem = '#00FF5F'
--theme.fg_cpu = '#74AEAB'

theme.fg_clay_paused = theme.fg_normal
theme.fg_clay_playing = theme.fg_icon

theme.fg_owm_icon = '#FFBA68' -- theme.fg_icon
theme.fg_owm_text = '#FFBA68' -- theme.fg_text

theme.fg_ping_icon = '#77FF00' -- theme.fg_icon
theme.fg_ping_text = '#77FF00' -- theme.fg_text
theme.fg_ping_warning = theme.bg_focus

theme.fg_battery_icon = theme.fg_icon
theme.fg_battery_text = theme.fg_text
theme.fg_battery_warning = theme.bg_focus
theme.fg_battery_charging = '#77FF00'

theme.fg_date_icon = theme.fg_icon
theme.fg_date_text = '#00FF5F'
theme.fg_date_today = theme.bg_normal
theme.bg_date_today = theme.bg_focus

-- theme.fg_volume_icon = "#FF7700" -- theme.fg_icon
-- theme.fg_volume_text = "#FF7700" -- theme.fg_text
theme.fg_volume_icon = "#DDAAFF" -- theme.fg_icon
theme.fg_volume_text = "#DDAAFF" -- theme.fg_text
theme.fg_volume_muted = theme.bg_focus

theme.fg_term_icon = theme.fg_icon
theme.fg_term_text = theme.fg_text
theme.fg_term_warn = theme.bg_focus

theme.fg_mem_graph = '#77FF00' -- theme.fg_graph
theme.fg_mem_warning = theme.bg_focus

theme.fg_swap_graph = '#AAAA00' -- theme.fg_graph
theme.fg_swap_warning = theme.bg_focus

theme.fg_cpu_graph = '#00AAFF' -- theme.fg_graph
theme.fg_cpu_warning = theme.bg_focus

theme.fg_gpmdp_playing = '#77FF00'
--theme.fg_gpmdp_paused = '#FF0044'
theme.fg_gpmdp_paused = '#FFAA00'

theme.fg_spotify_playing = '#77FF00'
--theme.fg_gpmdp_paused = '#FF0044'
theme.fg_spotify_paused = '#FFAA00'

theme.fg_mqtt_ok = '#77FF00'
theme.fg_mqtt_warning = theme.bg_focus

--
--theme.fg_mem = '#00FF5F'
--theme.fg_cpu = '#74AEAB'

--theme.accent_color = '#44ff77'

theme.useless_gap   = dpi(0)
theme.border_width  = 0
theme.border_normal = "#000000"
theme.border_focus  = theme.bg_focus
theme.border_marked = "#91231c"
theme.systray_icon_spacing = 2

theme.tooltip_bg=theme.bg_normal
theme.tooltip_fg=theme.fg_normal
theme.tooltip_font = 'DejaVuSansMono Nerd Font 9'

--theme.taglist_disable_icon = true

--theme.taglist_fg_empty = '#666666'
--theme.taglist_bg_focus = '#55555580'
--theme.taglist_spacing = 0
theme.taglist_font = 'RobotoMono Nerd Font Medium 10'

--theme.taglist_font = 'Pixellari 12'
--theme.taglist_shape_focus = gears.arrow()
--theme.taglist_shape_border_width_focus = 3
--theme.taglist_shape_border_color_focus = '#FF0000'

theme.progressbar_margins = {top=22}
-- theme.progressbar_margins = {top=20, bottom=2}
--theme.progressbar_margins = {bottom=3, top=3}
--theme.progressbar_margins = {bottom=0, top=0}
--theme.progressbar_margins = {bottom=2, top=20}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
--local taglist_square_size = 24  -- dpi(24)
--theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
--    taglist_square_size, theme.fg_normal
--)
--theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
--    taglist_square_size, theme.fg_normal
--)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_font = 'Roboto 10'
theme.notification_border_color = theme.bg_normal
theme.notification_margin = dpi(100)
theme.notification_opacity = 0.92

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path.."default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_path.."default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themes_path.."default/titlebar/maximized_focus_active.png"

--theme.wallpaper = themes_path.."zenburn/background.png"
--local wp = '/home/anderson/.wallpapers/new3/wallhaven-319318.png'
--local wp = '/home/anderson/.wallpapers/astro-parking.png'
--local wp = '/home/anderson/.wallpapers/ng1/121406.jpg'
--local wp = '/home/anderson/.wallpapers/ng1/121410.jpg'
--local wp = '/home/anderson/.wallpapers/rainbow-colors-blurred.jpg'
--local wp = '/home/anderson/.wallpapers/doom-ng/slayer.jpg'
-- local wp = '/home/anderson/.wallpapers/lights1920.png'
local wp = '/home/anderson/.wallpapers/lights2.jpg'

-- local wp = '/usr/share/backgrounds/archlinux/awesome.png'
-- local wp = '/usr/share/backgrounds/archlinux/split.png'
-- local wp = '/usr/share/backgrounds/archlinux/wild.png'

-- local wp = '/home/anderson/.wallpapers/undertale/thumb-1920-969432.jpg'
--local wp = '/home/anderson/.wallpapers/sw/thefuture.jpg'
--local wp = '/home/anderson/.wallpapers/sw/isnow.jpg'
--local wp = '/home/anderson/.wallpapers/332450.jpg'
--local wp = '/home/anderson/.wallpapers/cyberpunk/cropped-1920-1080-872313.png'
--local wp = '/home/anderson/.wallpapers/cyberpunk/xE3J4MZ.jpg'
theme.wallpapers = {
    --'/home/anderson/.wallpapers/ut3/1.png',
    --'/home/anderson/.wallpapers/ut3/1blue.png',
    --'/home/anderson/.wallpapers/ut3/1.png',
    --'/home/anderson/.wallpapers/ut4/ut99_red3.png',
    --'/home/anderson/.wallpapers/ut4/ut99_red3.png',
    --'/home/anderson/.wallpapers/ut4/ut99_red3.png',
    --'/home/anderson/.wallpapers/arch/arch-orangeneon.png',
    --'/home/anderson/.wallpapers/arch/arch-orangeneon.png',
    --'/home/anderson/.wallpapers/arch/arch-orangeneon.png',
    --'/home/anderson/.wallpapers/arch/simple-blue.png',
    --'/home/anderson/.wallpapers/arch/simple-blue.png',
    --'/home/anderson/.wallpapers/arch/simple-blue.png',
    wp,
    wp,
    wp,
}

--theme.wallpaper = '/home/anderson/.wallpapers/ut3/1full.jpg'

-- You can use your own layout icons like this:
theme.layout_tile       = themes_path .. "zenburn/layouts/tile.png"
theme.layout_tileleft   = themes_path .. "zenburn/layouts/tileleft.png"
theme.layout_tilebottom = themes_path .. "zenburn/layouts/tilebottom.png"
theme.layout_tiletop    = themes_path .. "zenburn/layouts/tiletop.png"
--theme.layout_fairv      = themes_path .. "zenburn/layouts/fairv.png"
theme.layout_fairv      = this_dir .. "layouts/fairv.png"
theme.layout_fairh      = themes_path .. "zenburn/layouts/fairh.png"
theme.layout_spiral     = themes_path .. "zenburn/layouts/spiral.png"
theme.layout_dwindle    = themes_path .. "zenburn/layouts/dwindle.png"
--theme.layout_max        = themes_path .. "zenburn/layouts/max.png"
theme.layout_max        = this_dir .. "layouts/max.png"
theme.layout_fullscreen = themes_path .. "zenburn/layouts/fullscreen.png"
theme.layout_magnifier  = themes_path .. "zenburn/layouts/magnifier.png"
theme.layout_floating   = themes_path .. "zenburn/layouts/floating.png"
theme.layout_cornernw   = themes_path .. "zenburn/layouts/cornernw.png"
theme.layout_cornerne   = themes_path .. "zenburn/layouts/cornerne.png"
theme.layout_cornersw   = themes_path .. "zenburn/layouts/cornersw.png"
theme.layout_cornerse   = themes_path .. "zenburn/layouts/cornerse.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
