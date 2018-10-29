---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local home_dir = '/home/anderson/'
local this_dir = home_dir .. '.config/awesome/themes/'

local theme = {}

--theme.font          = "DejaVuSansMono Nerd Font 9"
theme.font          = "RobotoMono Nerd Font Medium 10"
--theme.font          = "SauceCodePro Nerd Font Medium 9"
--theme.font          = "Pixeled 5"
--theme.font          = "Symtext 8"
--theme.font          = "Pixel-Art 7"
--theme.font    = "Pixellari 9"
--theme.pixel_font    = "Pixellari 9"

--theme.bg_normal     = "#2D2D2D"
theme.bg_normal     = "#080808"
--theme.bg_normal     = "#080202"
--theme.bg_focus      = "#D64937"
theme.bg_focus      = "#4499BB"
--theme.bg_focus = '#44B7F7'
--theme.bg_focus = '#44ff77'
theme.bg_urgent     = "#000000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

--theme.fg_normal     = "#CACAC0"
--theme.fg_soft       = "#888888"
--theme.fg_normal     = "#CACAC0"
theme.fg_normal     = "#C0C0C0"
theme.fg_bright     = "#FFFFFF"
theme.fg_focus      = "#FFFFFF"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.fg_battery = '#44B7F7'
theme.fg_battery_warning = '#FF0087'
theme.fg_battery_charging = '#00FF5F'
theme.fg_date = '#00FF5F'
theme.fg_volume = '#44B7F7'
theme.fg_term = '#44B7F7'
theme.fg_mem = '#00FF5F'
theme.fg_cpu = '#74AEAB'

--theme.accent_color = '#44ff77'

theme.useless_gap   = dpi(0)
theme.border_width  = 1
theme.border_normal = "#000000"
theme.border_focus  = theme.bg_focus
theme.border_marked = "#91231c"
theme.systray_icon_spacing = 2

theme.tooltip_bg=theme.bg_normal
theme.tooltip_fg=theme.fg_normal

--theme.taglist_disable_icon = true
theme.taglist_fg_empty = '#444444'
theme.taglist_spacing = 0
theme.taglist_font = 'Roboto 10'


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
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

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
--theme.wallpaper = '/home/anderson/.wallpapers/new3/wallhaven-319318.png'
theme.wallpapers = {
    --'/home/anderson/.wallpapers/ut3/1.png',
    --'/home/anderson/.wallpapers/ut3/1blue.png',
    --'/home/anderson/.wallpapers/ut3/1.png',
    '/home/anderson/.wallpapers/ut4/ut99_red3.png',
    '/home/anderson/.wallpapers/ut4/ut99_red3.png',
    '/home/anderson/.wallpapers/ut4/ut99_red3.png',
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
