local wibox = require("wibox")
local lain = require("lain")
local madhur = require("madhur")
local beautiful = require("beautiful")
local awful = require("awful")
local helpers = require("madhur.helpers")
local gears = require("gears")
local naughty = require("naughty")
local net_speed_widget = require("awesome-wm-widgets.net-speed-widget.net-speed")
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
local aw_volume_widget = require('awesome-wm-widgets.pactl-widget.volume')
local pacman_widget = require('awesome-wm-widgets.pacman-widget.pacman')
local markup = lain.util.markup
require('awesome-glorious-widgets.hot-corners')
local wiboxes = {}

local clock = awful.widget.watch("date +'%a %d %b %R'", 60, function(widget, stdout)
    widget:set_markup(" " .. markup.font(beautiful.font, " " .. stdout))
end)

local cw = calendar_widget({
    theme = "nord",
    placement = "top_right",
    start_sunday = false,
    radius = 0
})

clock:buttons(awful.util.table.join(awful.button({}, 1, function()
    -- cw.toggle()
    awful.spawn.easy_async_with_shell("eww open calendar --toggle", function(stdout, stderr, reason, exit_code)

    end)

end), awful.button({}, 3, function()
    -- left click
    awful.spawn.easy_async_with_shell("date -u", function(stdout, stderr, reason, exit_code)
        naughty.notify {
            text = tostring(stdout)
        }
    end)
end)))

-- local month_calendar = awful.widget.calendar_popup.month()
-- month_calendar:attach(clock, 'tr')
-- Calendar
-- local cal =
--     lain.widget.cal(
--     {
--         attach_to = {clock},
--         notification_preset = {
--             font = beautiful.font,
--             fg = beautiful.fg_normal,
--             bg = beautiful.bg_normal
--         }
--     }
-- )

-- MEM
local mem = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.font(beautiful.font, " " .. mem_now.perc .. " %"))
    end
})

mem.widget:buttons(awful.util.table.join(awful.button({}, 1, function()
    -- left click
    awful.spawn.easy_async_with_shell("conky -c ~/.config/conky/mem.conf", function(stdout, stderr, reason, exit_code)
        naughty.notify {
            text = tostring(stdout)
        }
    end)
end)))

local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")

-- CPU
-- local cpu =
--     lain.widget.cpu(
--     {
--         settings = function()
--             --helpers.debug("cpu widget called.."..cpu_now.usage)
--             widget:set_markup(markup.font(beautiful.font, " " .. cpu_now.usage .. " %"))
--         end
--     }
-- )

-- cpu.widget:buttons(
--     awful.util.table.join(
--         awful.button(
--             {},
--             1,
--             function()
--                 -- left click
--                 awful.spawn.easy_async_with_shell(
--                     "ps -Ao comm,pcpu,pid --sort=-pcpu | head -n 6",
--                     --awful.spawn.easy_async_with_shell("conky -c ~/.config/conky/cpu.conf",
--                     function(stdout, stderr, reason, exit_code)
--                         naughty.notify {text = tostring(stdout)}
--                     end
--                 )
--             end
--         )
--     )
-- )

-- local cpufreqwidget = wibox.widget.textbox()
-- vicious.register(cpufreqwidget, vicious.widgets.cpufreq, "$2 Ghz $5 ", 2, "cpu0")
-- local cpufreqwidget = madhur.widget.cpufreq({
--     settings = function()
--         widget:set_markup(markup.font(beautiful.font, governor .. " " .. freqv.ghz .. "Ghz "))
--     end
-- })

-- 

local uptime_widget_madhur = madhur.widget.uptime({
    settings = function()
        widget:set_markup(markup.font(beautiful.font, " " .. result))
    end
})

local edd7b0 = awful.widget.watch("/home/madhur/company/f25a24.sh edd7b0", 5, function(widget, stdout, stderr)
    if tonumber(stdout) > 1 then
        awesome.emit_signal("warning", "edd7b0")
    else
        awesome.emit_signal("normal", "edd7b0")
    end
    widget:set_markup(markup.font(beautiful.font, " edd7b0:" .. stdout))
end)

local temp_madhur = madhur.widget.temp({
    settings = function()
        widget:set_markup(markup.font(beautiful.font, " " .. result .. "°C "))
    end
})

temp_madhur.widget:buttons(awful.util.table.join(awful.button({}, 1, function()
    awful.spawn.with_shell("~/scripts/powersave.sh")
end), awful.button({}, 3, function()
    awful.spawn.with_shell("~/scripts/performance.sh")
end)))

local notification = madhur.widget.notification({
    settings = function()
        widget:set_markup(markup.font(beautiful.font, result))
    end
})

local fs = lain.widget.fs({
    partition = "/",
    notification_preset = {
        fg = beautiful.fg_normal,
        bg = beautiful.bg_normal,
        font = beautiful.font
    },
    settings = function()
        local fsp = string.format(" %d %s ", fs_now["/"].percentage, "%")
        widget:set_markup(markup.font(beautiful.font, " " .. fsp))
    end
})
-- ]]

local net_widget = net_speed_widget()
net_widget:buttons(awful.util.table.join(awful.button({}, 1, function()
    -- left click
    awful.spawn.easy_async_with_shell(
        "ip -f inet addr show enp5s0 |grep inet | awk NF | sed -En -e 's/.*inet ([0-9.]+).*/\\1/p'",
        function(stdout, stderr, reason, exit_code)
            naughty.notify {
                text = tostring(stdout)
            }
        end)
end), awful.button({}, 3, function()
    -- right click
    awful.spawn.easy_async_with_shell("sudo netstat -ntpe | grep -v '127.0.0.1' | grep 'ESTABLISHED'",
        function(stdout, stderr, reason, exit_code)
            naughty.notify {
                text = tostring(stdout)
            }
        end)
end), awful.button({}, 2, function()
    -- middle click
    awful.spawn.easy_async_with_shell("conky -c ~/.config/conky/io.conf", function(stdout, stderr, reason, exit_code)
        naughty.notify {
            text = tostring(stdout)
        }
    end)
end)))

local mygpu = madhur.widget.nvidia({
    settings = function()
        widget:set_markup(markup.font(beautiful.font, " " .. gpu.usage .. " " .. gpu.temp .. "°C"))
    end
})

local switchtag = madhur.widget.switchtag({
    settings = function()
        local icon = nil
        if awful.util.switch_tag then
            icon = "10s"
        else
            icon = "0s"
        end

        widget:set_markup(markup.font(beautiful.font, icon))
    end
})
switchtag.widget:buttons(awful.util.table.join(awful.button({}, 1, function()
    awful.util.switch_tag = not awful.util.switch_tag
    switchtag.update()
end)))

-- ALSA volume
-- theme.volume =
--     lain.widget.alsa(
--     {
--         settings = function()
--             widget:set_markup(markup.font(theme.font, " " .. volume_now.level .. "%"))
--         end
--     }
-- )

local volume = lain.widget.pulse({
    settings = function()
        local speaker_icon = "  "
        local headphone_icon = " "
        local icon
        if tonumber(volume_now.index) == 2 then
            icon = headphone_icon
        else
            icon = speaker_icon
        end
        widget:set_markup(markup.font(beautiful.font, icon .. volume_now.left))
    end
})
awful.util.volume = volume
awful.util.volume_new = aw_volume_widget

-- local volume_bar = lain.widget.pulsebar()
-- local volume_bar_widget = volume_bar.bar

local volume_widget = wibox.widget {
    volume,
    -- volume_bar_widget,
    layout = wibox.layout.align.horizontal
}

volume_widget:buttons(awful.util.table.join(awful.button({}, 1, function()
    -- left click
    awful.spawn("pavucontrol")
end), awful.button({}, 2, function()
    -- middle click
    os.execute(string.format("pactl set-sink-volume %d 100%%", volume_bar.device))
    -- volume_bar.update()
    volume.update()
end), awful.button({}, 3, function()
    -- right click
    os.execute(string.format("pactl set-sink-mute %d toggle", volume_bar.device))
    -- volume_bar.update()
    volume.update()
end), awful.button({}, 4, function()
    -- scroll up
    os.execute(string.format("pactl set-sink-volume %d +1%%", volume_bar.device))
    -- volume_bar.update()
    volume.update()
end), awful.button({}, 5, function()
    -- scroll down
    os.execute(string.format("pactl set-sink-volume %d -1%%", volume_bar.device))
    volume_bar.update()
    volume.update()
end)))
-- Net
-- local net =
--     lain.widget.net(
--     {
--         settings = function()
--             widget:set_markup(markup.font(beautiful.font, " " .. net_now.received .. " ↓ " .. net_now.sent .. " ↑"))
--         end
--     }
-- )

-- simple vertical separator widget
local spr = wibox.widget {
    markup = "<span font='JetBrains Mono Nerd Font 12'>|</span>",
    widget = wibox.widget.textbox
}

-- A transparent separataor widget with width of 10 pixels
local hr_spr = wibox.widget {
    color = "#000000",
    thickness = 2,
    forced_width = 10,
    orientation = "vertical",
    widget = wibox.widget.separator
}

local function powerline_rl(cr, width, height)
    local arrow_depth, offset = height / 2, 0

    -- Avoid going out of the (potential) clip area
    if arrow_depth < 0 then
        width = width + 2 * arrow_depth
        offset = -arrow_depth
    end

    cr:move_to(offset + arrow_depth, 0)
    cr:line_to(offset + width, 0)
    cr:line_to(offset + width - arrow_depth, height / 2)
    cr:line_to(offset + width, height)
    cr:line_to(offset + arrow_depth, height)
    cr:line_to(offset, height / 2)
    -- cr:set_source_rgb (0.5, 0, 0)
    cr:close_path()
    -- cr:stroke()
end

local widget_types = {}

-- generic function to apply background / forecolor on widget, the widget is expected to be wrapped in wibox.container.background, so that just bg and fg properties can be altered.
-- otherwise, each widget has its own way to set bg/ fg
local function styleWidget(background_container_widget, widget_type, background_color, foreground_color, normalize,
    warning_critical)

    -- normalize property is expected to be passed from when widgets is being changed from warning / critical signal to normal, so that it can restore back to default state
    if normalize then
        background_color = beautiful.darker
        foreground_color = beautiful.fg_normal
    end

    -- widget specific overrides, for default scenarios only.
    -- warning / critical styles are global for now
    if warning_critical == nil or warning_critical == false then
        if widget_type == "calendar" then
            background_color = "#11161b"
            -- foreground_color = "#94f7c5"
            foreground_color = "#85dfa8"
        elseif widget_type == "mem" then
            --foreground_color = "#8cc1ff"
            foreground_color = "#297639"
        elseif widget_type == "cpu_widget" then
            --foreground_color = "#f46521"
            foreground_color = "#f06a2b"

        elseif widget_type == "cpufreq" then
            foreground_color = "#f06a2b"
        elseif widget_type == "temp" then
            foreground_color = "#f06a2b"

        elseif widget_type == "gpu" then
            foreground_color = "#94f7c5"

        elseif widget_type == "fs" then
            foreground_color = "#e2a6ff"
        elseif widget_type == "net_new" then
            foreground_color = "#90daff"
        elseif widget_type == "volume_new" then
            foreground_color = "#ffeba6"
        elseif widget_type == "uptime" then
            foreground_color = "#85dfa8"
        elseif widget_type == "pacman" then
            foreground_color = "#1793d1"
        end
    end

    -- we can change the bg / fg color in case of warning / critical if not passed from signal
    if warning_critical then
        foreground_color = beautiful.darker
    end
    -- if the properties are nil, the child widget will retain its background / foreground property. Useful when we dont want to override
    if background_color then
        background_container_widget.bg = background_color
    end

    if foreground_color then
        background_container_widget.fg = foreground_color
    end

end

local function pl(widget, reverse, widget_type)
    -- Uncomment below to have alternating background colors
    -- if reverse then
    --      color = beautiful.darker
    -- else
    --     color = beautiful.dark
    -- end

    -- Uncomment to enable powerline
    -- local finalWidget = wibox.container.background(wibox.container.margin(widget, 16, 16), background_color, powerline_rl)
    local finalWidget = wibox.container.background(wibox.container.margin(widget, 16, 16), nil, nil)
    styleWidget(finalWidget, widget_type, nil, nil, true)

    local tempWidget = wibox.widget {

        finalWidget,
        {
            id = "top_border",
            widget = wibox.widget.separator,
            forced_height = 2,
            thickness = 2,
            forced_width = 80,
            orientation = "horizontal",
            color = finalWidget.fg
        },
        layout = wibox.layout.fixed.vertical
    }

    -- Add margin if required
    -- local fw = finalWidget
    local fw = wibox.container.margin(finalWidget, 10, 10, 0, 0)

    -- we do not pass fw to widget_types because signal manipulators manipulate bg / bg which are only available on background widget
    if widget_type then
        widget_types[widget_type] = finalWidget
    end
    return fw
end

awesome.connect_signal("warning", function(widget_type)
    -- helpers.debug(widget_type.."warning")
    styleWidget(widget_types[widget_type], widget_type, beautiful.warning_bg, nil, false, true)
    if awful.util.smart_wibar_hide then
        widget_types[widget_type].visible = true
    end
end)
awesome.connect_signal("critical", function(widget_type)
    -- helpers.debug(widget_type.."critical")
    styleWidget(widget_types[widget_type], widget_type, beautiful.critical_bg, nil, false, true)
    if awful.util.smart_wibar_hide then
        widget_types[widget_type].visible = true
    end
end)

awesome.connect_signal("normal", function(widget_type)
    -- helpers.debug(widget_type.."normal")
    if not widget_types[widget_type] then
        return
    end

    styleWidget(widget_types[widget_type], widget_type, nil, nil, true, false)

    if awful.util.smart_wibar_hide then
        widget_types[widget_type].visible = false
    else
        -- helpers.debug(widget_types["cpu"])
        widget_types[widget_type].visible = true
    end
end)

local jgmenu_right_click = wibox.widget {
    resize = true,
    widget = wibox.widget.imagebox,
    forced_width = 300
}

jgmenu_right_click:connect_signal("button::press", function(_, _, _, button)
    if button == 3 then
        awful.spawn("jgmenu", false)
    end
end)

local awesome_icon = wibox.widget {
    image = beautiful.awesome_icon,
    resize = false,
    widget = wibox.widget.imagebox
}

awesome_icon:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then
        awful.spawn("jgmenu", false)
    end
end)

-- Uncomment belwo to have prompt on wibar
-- local myprompt = awful.widget.prompt {
--     prompt = 'Execute: ',
--     with_shell = true,
--     exe_callback = function(input)
--         if not input or #input == 0 then return end
--         naughty.notify{ text = 'The input was: '..input }
--     end
-- }
-- awful.util.myprompt = myprompt

local text_box = wibox.widget {
    markup = "",
    halign = "center",
    valign = "center",
    widget = wibox.widget.textbox
}
awful.util.text_box_prompt = text_box

local systray = wibox.widget.systray()
local pactl_widget = aw_volume_widget {
    widget_type = 'icon_and_text'
}
pl(volume_widget, "true", "volume");

-- local mypromptbox = awful.widget.prompt()
local right_widgets = {
    -- Right widgets
    layout = wibox.layout.fixed.horizontal,

    -- pl(mytasklist),
    -- pl(cpu.widget, true, "cpu"),
    -- jgmenu_right_click,
    pl(cpu_widget({
        width = 70,
        step_width = 2,
        step_spacing = 0,
        color = '#434c5e'
    }), true, "cpu_widget"),
    -- pl(cpufreqwidget.widget, true, "cpufreq"),
    pl(temp_madhur.widget, false, "temp"),
    pl(mem.widget, true, "mem"),
    -- pl(mygpu.widget, false, "gpu"),
    pl(fs.widget, true, "fs"),
    -- pl(net.widget, false, "net"),
    pl(net_widget, true, "net_new"),
    pl(uptime_widget_madhur.widget, true, "uptime"),
    -- pl(
    --     volume_widget {
    --         widget_type = "icon_and_text"
    --     }
    -- ),
    -- pl(volume, true, "volume"),
    -- pl(volume_bar_widget),

    pl(pactl_widget, "true", "volume_new"),
    -- pl(g50ad0, true, "g50ad0"),
   -- pl(edd7b0, true, "edd7b0"),
    pl(notification, true, "notification"),
    --  pl(switchtag, true, "switchtag"),
    pl(pacman_widget {
        interval = 600, -- Refresh every 10 minutes
        popup_bg_color = '#222222',
        popup_border_width = 1,
        popup_border_color = '#7e7e7e',
        popup_height = 50, -- 10 packages shown in scrollable window
        popup_width = 500,
        polkit_agent_path = '/usr/bin/lxpolkit'
    }, true, "pacman"),
    wibox.container.margin(systray, 3, 3, 3, 3)
}

function wiboxes.get(s)
    local mywibox = awful.wibar({
        position = "top",
        stretch = true,
        margins = 0,
        border_width = 0,
        screen = s,
        height = 30,
        bg = "#1a1b26aa",
        -- fg = beautiful.fg_normal,
        ontop = false
    })

    s.right_widgets = right_widgets
    systray:set_base_size(24)

    local mylayoutbox = require("widgets.layoutbox").get(s)
    local mytaglist = require("widgets.taglist").get(s)
    local mytasklist = require("widgets.tasklist").get(s)
    awful.util.mytasklist = mytasklist

    local left_widgets = {
        -- Left widgets
        layout = wibox.layout.fixed.horizontal,
        wibox.container.margin(awesome_icon, 5, 5, 5, 5),
        hr_spr,
        mytaglist,
        hr_spr,
        spr,
        wibox.container.margin(mylayoutbox, 5, 10, 5, 5),
        spr,
        mytasklist,
        -- myprompt,
        text_box
    }
    -- Add widgets to the wibox
    mywibox:setup{
        layout = wibox.layout.align.horizontal,
        expand = "none",
        -- {
        --     widget = wibox.container.background,
        --     bg = "#1a1b26",
        --     left_widgets
        -- },
        left_widgets,
        {
            layout = wibox.layout.align.horizontal,
            expand = "none",
            nil,
            pl(clock, true, "calendar")
            -- jgmenu_right_click
        },
        right_widgets

        -- {
        --     widget = wibox.container.background,
        --     bg = "#1a1b26",
        --     right_widgets,
        --     opacity = 1,
        -- }
    }
    return mywibox
end

return wiboxes
