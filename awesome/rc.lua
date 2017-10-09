-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(awful.util.get_themes_dir() .. "default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "hyper"
editor = os.getenv("EDITOR") or "atom"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    -- awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Wibar
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    gears.wallpaper.set(
      gears.color("#3c3836"))

    -- Each screen has its own tag table.
    awful.tag({ "1" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
end)
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey, "Shift"}, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey, "Shift"}, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey, "Shift"}, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- Layout manipulation
    -- awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
    --           {description = "swap with next client by index", group = "client"}),
    -- awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
    --           {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Shift" }, "w", function () awful.screen.focus(1) end,
              {description = "focus on screen 0", group = "screen"}),
    awful.key({ modkey, "Shift" }, "e", function () awful.screen.focus(2) end,
              {description = "focus on screen 1", group = "screen"}),
    -- awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              -- {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey, }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey, }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Super", "Shift" }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey, "Shift" }, "l", function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey, "Shift" }, "h", function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    -- awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
    --           {description = "increase the number of master clients", group = "layout"}),
    -- awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
    --           {description = "decrease the number of master clients", group = "layout"}),
    -- awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              -- {description = "increase the number of columns", group = "layout"}),
    -- awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              -- {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey, "Shift" }, "o", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),

    awful.key({ modkey, "Super" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    -- awful.key({ modkey, "Shift" }, "space", function () awful.screen.focused().mypromptbox:run() end,
              -- {description = "run prompt", group = "launcher"}),

    -- Menubar
    awful.key({ modkey, "Shift" }, "space", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)

clientkeys = awful.util.table.join(
    awful.key({ modkey, "Mod4", "Shift" }, "w", function (c) c:move_to_screen(1) end,
              {description = "move to screen 0", group = "client"}),
    awful.key({ modkey, "Mod4", "Shift" }, "e", function (c) c:move_to_screen(2) end,
              {description = "move to screen 1", group = "client"}),

    awful.key({ modkey, "Shift" }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift" }, "c", function (c) c:kill() end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Shift" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey, }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"})
)

-- clientbuttons = awful.util.table.join(
--     awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
--     awful.button({ modkey }, 1, awful.mouse.client.move),
--     awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      -- properties = { border_width = beautiful.border_width,
      properties = { border_width = 5,
                     border_color = "#3c3836",
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    -- if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
    --     and awful.client.focus.filter(c) then
    --     client.focus = c
    -- end
end)

client.connect_signal("focus", function(c) c.border_color = "#d65d0e" end)
client.connect_signal("unfocus", function(c) c.border_color = "#3c3836" end)
-- }}}
