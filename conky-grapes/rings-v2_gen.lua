--[[
Ring Meters by londonali1010 (2009)
Modified by La-Manoue (2016)
Automation template by popi (2017)

This script draws percentage meters as rings. It is fully customisable; all options are described in the script.

IMPORTANT: if you are using the 'cpu' function, it will cause a segmentation fault if it tries to draw a ring straight away. The if statement near the end of the script uses a delay to make sure that this doesn't happen. It calculates the length of the delay by the number of updates since Conky started. Generally, a value of 5s is long enough, so if you update Conky every 1s, use update_num > 5 in that if statement (the default). If you only update Conky every 2s, you should change it to update_num > 3; conversely if you update Conky every 0.5s, you should use update_num > 10. ALSO, if you change your Conky, is it best to use "killall conky; conky" to update it, otherwise the update_num will not be reset and you will get an error.

To call this script in Conky, use the following (assuming that you save this script to ~/scripts/rings.lua):
	lua_load ~/conky/rings-v2_local.lua
	lua_draw_hook_pre ring_stats
	
Changelog:
+ v2.1.1 -- addedd IO_WAIT ring
+ v2.1.0 -- templated for automation, 
+ v2.0.0 -- Changed some values for ArchLinux
+ v1.2.2 -- Added color change for near-limits values / modified placement
+ v1.2.1 -- Fixed minor bug that caused script to crash if conky_parse() returns a nil value (20.10.2009)
+ v1.2 -- Added option for the ending angle of the rings (07.10.2009)
+ v1.1 -- Added options for the starting angle of the rings, and added the "max" variable, to allow for variables that output a numerical value rather than a percentage (29.09.2009)
+ v1.0 -- Original release (28.09.2009)

]]

local cairo = require 'cairo'

normal="0xffffff"
warn="0xffffff"
crit="0xffffff"

-- Gap between rings
ring_gap = 2

-- Outer ring thickness for consistency
outer_ring_thickness = 20

-- seulement quand fond nécessaire
corner_r=35
bg_colour=0x3b3b3b
bg_alpha=0.2

-- white    | 0xffffff
-- red      | 0xff1d2b
-- green    | 0x1dff22
-- pink     | 0xff1d9f
-- orange   | 0xff8523
-- skyblue  | 0x008cff
-- darkgray | 0x323232

settings_table_io = {
    {
        name='top_io io_perc 1',
        arg='',
        max=100,
        bg_colour=0x3b3b3b,
        bg_alpha=0.8,
        fg_colour=0xffffff,
        fg_alpha=0.8,
        x=748, y=298, -- původní pozice před posunem
        radius=100,
        thickness=outer_ring_thickness,
        start_angle=120,
        end_angle=360
    },
    {
        name='top_io io_perc 2',
        arg='',
        max=100,
        bg_colour=0x3b3b3b,
        bg_alpha=0.6,
        fg_colour=0xffffff,
        fg_alpha=0.8,
        x=748, y=298,
        radius=100 - outer_ring_thickness/2 - ring_gap - (18/2),
        thickness=18,
        start_angle=120,
        end_angle=360
    },
    {
        name='top_io io_perc 3',
        arg='',
        max=100,
        bg_colour=0x3b3b3b,
        bg_alpha=0.4,
        fg_colour=0xffffff,
        fg_alpha=0.8,
        x=748, y=298,
        radius=100 - outer_ring_thickness/2 - ring_gap - 18 - ring_gap - (17/2),
        thickness=17,
        start_angle=120,
        end_angle=360
    }
}

settings_table = {
    {
        name='hwmon',
        arg='1 temp 1',
        max=110,
        bg_colour=0x3b3b3b,
        bg_alpha=0.8,
        fg_colour=0xffffff,
        fg_alpha=0.8,
        x=400, y=350,
        radius=202,
        thickness=8,
        start_angle=0,
        end_angle=240
    },
    {
        name='cpu_core',
        arg='1',
        max=200,
        bg_colour=0x3b3b3b,
        bg_alpha=0.7,
        fg_colour=0xffffff,
        fg_alpha=0.8,
        x=400, y=350,
        radius=185,
        thickness=outer_ring_thickness,
        start_angle=0,
        end_angle=240
    },
    {
        name='cpu_core',
        arg='2',
        max=200,
        bg_colour=0x3b3b3b,
        bg_alpha=0.6333333333333333,
        fg_colour=0xffffff,
        fg_alpha=0.8,
        x=400, y=350,
        radius=185 - outer_ring_thickness/2 - ring_gap - (16/2),
        thickness=16,
        start_angle=0,
        end_angle=240
    },
    {
        name='cpu_core',
        arg='3',
        max=200,
        bg_colour=0x3b3b3b,
        bg_alpha=0.5666666666666667,
        fg_colour=0xffffff,
        fg_alpha=0.8,
        x=400, y=350,
        radius=185 - outer_ring_thickness/2 - ring_gap - 16 - ring_gap - (15/2),
        thickness=15,
        start_angle=0,
        end_angle=240
    },
    {
        name='cpu_core',
        arg='4',
        max=200,
        bg_colour=0x3b3b3b,
        bg_alpha=0.5,
        fg_colour=0xffffff,
        fg_alpha=0.8,
        x=400, y=350,
        radius=185 - outer_ring_thickness/2 - ring_gap - 16 - ring_gap - 15 - ring_gap - (18/2),
        thickness=18,
        start_angle=0,
        end_angle=240
    },
    {
        name='cpu_core',
        arg='5',
        max=200,
        bg_colour=0x3b3b3b,
        bg_alpha=0.43333333333333335,
        fg_colour=0xffffff,
        fg_alpha=0.8,
        x=400, y=350,
        radius=185 - outer_ring_thickness/2 - ring_gap - 16 - ring_gap - 15 - ring_gap - 18 - ring_gap - (17/2),
        thickness=17,
        start_angle=0,
        end_angle=240
    },
    {
        name='cpu_core',
        arg='6',
        max=200,
        bg_colour=0x3b3b3b,
        bg_alpha=0.3666666666666667,
        fg_colour=0xffffff,
        fg_alpha=0.8,
        x=400, y=350,
        radius=185 - outer_ring_thickness/2 - ring_gap - 16 - ring_gap - 15 - ring_gap - 18 - ring_gap - 17 - ring_gap - (16/2),
        thickness=16,
        start_angle=0,
        end_angle=240
    },
    {
        name='cpu_core',
        arg='7',
        max=200,
        bg_colour=0x3b3b3b,
        bg_alpha=0.3,
        fg_colour=0xffffff,
        fg_alpha=0.8,
        x=400, y=350,
        radius=185 - outer_ring_thickness/2 - ring_gap - 16 - ring_gap - 15 - ring_gap - 18 - ring_gap - 17 - ring_gap - 16 - ring_gap - (15/2),
        thickness=15,
        start_angle=0,
        end_angle=240
    },
    {
        name='cpu_core',
        arg='8',
        max=200,
        bg_colour=0x3b3b3b,
        bg_alpha=0.23333333333333334,
        fg_colour=0xffffff,
        fg_alpha=0.8,
        x=400, y=350,
        radius=185 - outer_ring_thickness/2 - ring_gap - 16 - ring_gap - 15 - ring_gap - 18 - ring_gap - 17 - ring_gap - 16 - ring_gap - 15 - ring_gap - ring_gap - (14/2),
        thickness=14,
        start_angle=0,
        end_angle=240
    },
    {
        name='memperc',
        arg='',
        max=100,
        bg_colour=0x3b3b3b,
        bg_alpha=0.8,
        fg_colour=0xffffff,
        fg_alpha=0.8,
        x=720, y=560, -- posunuto o 10 px dolů
        radius=100, -- stejný poloměr jako vnější IO wait
        thickness=outer_ring_thickness, -- stejná šířka jako vnější IO wait
        start_angle=180,
        end_angle=420
    },
    {
        name='swapperc',
        arg='',
        max=100,
        bg_colour=0x3b3b3b,
        bg_alpha=0.6,
        fg_colour=0xffffff,
        fg_alpha=0.8,
        x=720, y=560, -- posunuto o 10 px dolů
        radius=100 - outer_ring_thickness/2 - ring_gap - (18/2), -- stejný poloměr jako prostřední IO wait
        thickness=18, -- stejná šířka jako prostřední IO wait
        start_angle=180,
        end_angle=420
    },
    {
        name='nvidia',
        arg='memutil',
        max=100,
        bg_colour=0x3b3b3b,
        bg_alpha=0.4,
        fg_colour=0xffffff,
        fg_alpha=0.8,
        x=720, y=560, -- posunuto o 10 px dolů
        radius=100 - outer_ring_thickness/2 - ring_gap - 18 - ring_gap - (15/2), -- vnitřní kruh
        thickness=15, -- nejmenší šířka
        start_angle=180,
        end_angle=420
    },

    {
        name='fs_used_perc',
        arg='/',
        max=100,
        bg_colour=0x3b3b3b,
        bg_alpha=0.8,
        fg_colour=0xffffff,
        fg_alpha=0.8,
        x=420, y=690, -- posunuto o 20 px dolů
        radius=80,
        thickness=outer_ring_thickness,
        start_angle=0,
        end_angle=240
    },
    {
        name='fs_used_perc',
        arg='/media/jirka/Data',
        max=100,
        bg_colour=0x3b3b3b,
        bg_alpha=0.6000000000000001,
        fg_colour=0xffffff,
        fg_alpha=0.8,
        x=420, y=690, -- posunuto o 20 px dolů
        radius=80 - outer_ring_thickness/2 - ring_gap - 11/2 - 3, -- zmenšeno o další 1 px (celkem o 3 px)
        thickness=16, -- zvětšeno o další 2 px (celkem o 5 px)
        start_angle=0,
        end_angle=240
    },
    {
        name='fs_used_perc',
        arg='/media/jirka/backup_linux',
        max=100,
        bg_colour=0x3b3b3b,
        bg_alpha=0.4000000000000001,
        fg_colour=0xffffff,
        fg_alpha=0.8,
        x=420, y=690, -- posunuto o 20 px dolů
        radius=80 - outer_ring_thickness/2 - ring_gap - 11 - ring_gap - 10/2 - 4 - 2 - 1 - 1, -- zmenšeno o další 1 px (celkem o 4 px)
        thickness=12, -- zvětšeno o 2 px
        start_angle=0,
        end_angle=240
    },

    {
        name='downspeed',
        arg='wlp6s0',
        max=12500, -- 100 Mbit/s = 12500 KiB/s
        bg_colour=0x3b3b3b,
        bg_alpha=0.8,
        fg_colour=0xffffff,
        fg_alpha=0.8,
        x=620, y=1060,  -- posunuto o 100 dolů
        radius=50,  -- zmenšeno o dalších 10 (bylo 60)
        thickness=outer_ring_thickness,
        start_angle=180,
        end_angle=420
    },
    {
        name='upspeed',
        arg='wlp6s0',
        max=12500, -- 100 Mbit/s = 12500 KiB/s
        bg_colour=0x3b3b3b,
        bg_alpha=0.6000000000000001,
        fg_colour=0xffffff,
        fg_alpha=0.8,
        x=620, y=1060,  -- posunuto o 100 dolů
        radius=30,  -- zmenšeno o 10 (původně 40)
        thickness=17,  -- zmenšeno o 1 (původně 18)
        start_angle=180,
        end_angle=420
    },
    {
        name='time',
        arg='%S',
        max=60,
        bg_colour=0x3b3b3b,
        bg_alpha=0.8,
        fg_colour=0xffffff, -- bílá pro sekundy
        fg_alpha=0.8,
        x=442, y=970,  -- vráceno zpět na původní pozici
        radius=80,
        thickness=20,
        start_angle=0,
        end_angle=240
    },
    {
        name='time',
        arg='%M',
        max=60,
        bg_colour=0x3b3b3b,
        bg_alpha=0.6,
        fg_colour=0xffffff, -- bílá pro minuty
        fg_alpha=0.8,
        x=442, y=970,  -- vráceno zpět na původní pozici
        radius=59.5,
        thickness=16,
        start_angle=0,
        end_angle=240
    },
    {
        name='time',
        arg='%H',
        max=24,
        bg_colour=0x3b3b3b,
        bg_alpha=0.4,
        fg_colour=0xffffff, -- bílá pro hodiny
        fg_alpha=0.8,
        x=442, y=970,  -- vráceno zpět na původní pozici
        radius=42,
        thickness=12,
        start_angle=0,
        end_angle=240
    },
    {
        name='nvidia',
        arg='temp',
        max=110,
        bg_colour=0x3b3b3b,
        bg_alpha=0.8,
        fg_colour=0xffffff, -- bílá
        fg_alpha=0.8,
        x=610, y=780, -- graf GPU je posunut o 20 px dolů v konfiguraci
        radius=60, -- zvětšeno o 10
        thickness=outer_ring_thickness,
        start_angle=180,
        end_angle=420
    },
    {
        name='execi',
        arg='5 nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits',
        max=100,
        bg_colour=0x3b3b3b,
        bg_alpha=0.6,
        fg_colour=0xffffff, -- bílá
        fg_alpha=0.8,
        x=610, y=780, -- graf GPU je posunut o 20 px dolů v konfiguraci
        radius=60 - outer_ring_thickness/2 - ring_gap - 18/2, -- vnitřní kruh, mezera 2 px
        thickness=18,
        start_angle=180,
        end_angle=420
    }
}

-- Funkce pro Conky musí být globální a začínat conky_
function draw_ring(cr,t,pt)
    local w,h=conky_window.width,conky_window.height
    local xc,yc,ring_r,ring_w,sa,ea=pt['x'],pt['y'],pt['radius'],pt['thickness'],pt['start_angle'],pt['end_angle']
    local bgc, bga, fgc, fga=pt['bg_colour'], pt['bg_alpha'], pt['fg_colour'], pt['fg_alpha']
    local angle_0=sa*(2*math.pi/360)-math.pi/2
    local angle_f=ea*(2*math.pi/360)-math.pi/2
    local t_arc=t*(angle_f-angle_0)
    -- Draw background ring
    cairo_arc(cr,xc,yc,ring_r,angle_0,angle_f)
    cairo_set_source_rgba(cr,rgb_to_r_g_b(bgc,bga))
    cairo_set_line_width(cr,ring_w)
    cairo_stroke(cr)
    -- Draw indicator ring
    cairo_arc(cr,xc,yc,ring_r,angle_0,angle_0+t_arc)
    cairo_set_source_rgba(cr,rgb_to_r_g_b(fgc,fga))
    cairo_stroke(cr)
end

function rgb_to_r_g_b(colour,alpha)
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

-- Funkce pro Conky musí být globální a začínat conky_
function conky_cpu_core(core_num)
    local core_num = tonumber(core_num)
    local cpu1 = tonumber(conky_parse('${cpu cpu'..core_num..'}'))
    local cpu2 = tonumber(conky_parse('${cpu cpu'..(core_num+8)..'}'))
    local total = (cpu1 or 0) + (cpu2 or 0)
    return string.format("%.0f", total)
end

function conky_main()
    temp_watch()
    disk_watch()
    --iface_watch()
    -- if a battery is found
    --{{ BATTERY_ACTIVATE }}
    conky_ring_stats()
    -- quand fond nécessaire
    --    conky_draw_bg()
end

function conky_ring_stats()
    -- 20170715 IO_WAIT
    local function setup_rings_io(cr,pt)
        local str=''
        local value=0
        local warn_value=50
        local crit_value=70
        str=string.format('${%s %s}',pt['name'],pt['arg'])
        iowait=0
        ioused=tonumber(conky_parse(str))
        if ioused>0 then 
            iowait=100 - ioused
        end
        value=tonumber(iowait)
        if value == nil then value = 0 end
        pct=value/pt['max']
        draw_ring(cr,pct,pt)
    end
    local function setup_rings(cr,pt)
        local str=''
        local value=0
        if pt['name'] == 'cpu_core' then
            local core_num = tonumber(pt['arg'])
            local cpu1 = tonumber(conky_parse('${cpu cpu'..core_num..'}'))
            local cpu2 = tonumber(conky_parse('${cpu cpu'..(core_num+8)..'}'))
            value = (cpu1 or 0) + (cpu2 or 0)
        elseif pt['name'] == 'downspeed' or pt['name'] == 'upspeed' then
            str=string.format('${%s %s}',pt['name'],pt['arg'])
            str=conky_parse(str)
            if str then
                local num_str = str:match("([%d,%.]+)")
                if num_str then
                    num_str = num_str:gsub(",", ".")
                    local num = tonumber(num_str)
                    if num then
                        if str:match("MiB") then
                            value = num * 1024
                        elseif str:match("KiB") then
                            value = num
                        elseif str:match("B") then
                            value = num / 1024
                        else
                            value = num
                        end
                    end
                end
            end
        else
            str=string.format('${%s %s}',pt['name'],pt['arg'])
            str=conky_parse(str)
            value=tonumber(str)
        end
        if value == nil then value = 0 end
        pct=value/pt['max']
        draw_ring(cr,pct,pt)
    end
    if conky_window==nil then return end
    local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)
    local cr=cairo_create(cs)
    local updates=conky_parse('${updates}')
    update_num=tonumber(updates)
    if update_num>5 then
        for i in pairs(settings_table) do
            setup_rings(cr,settings_table[i])
        end
        for i in pairs(settings_table_io) do
            setup_rings_io(cr,settings_table_io[i])
        end
    end
    cairo_surface_destroy(cs)
    cairo_destroy(cr)
end

function temp_watch()
    warn_value=70
    crit_value=80
    temperature=tonumber(conky_parse("${hwmon 1 temp 1}"))
    if temperature<warn_value then
        settings_table[1]['fg_colour']=normal
    elseif temperature<crit_value then
        settings_table[1]['fg_colour']=warn
    else
        settings_table[1]['fg_colour']=crit
    end
end

function disk_watch()
    warn_disk=93
    crit_disk=98
    disk=tonumber(conky_parse("${fs_used_perc /}"))
    if disk<warn_disk then
        settings_table[10]['fg_colour']=normal
    elseif disk<crit_disk then
        settings_table[10]['fg_colour']=warn
    else
        settings_table[10]['fg_colour']=crit
    end
    disk=tonumber(conky_parse("${fs_used_perc /media/jirka/Data}"))
    if disk<warn_disk then
        settings_table[11]['fg_colour']=normal
    elseif disk<crit_disk then
        settings_table[11]['fg_colour']=warn
    else
        settings_table[11]['fg_colour']=crit
    end
    disk=tonumber(conky_parse("${fs_used_perc /media/jirka/backup_linux}"))
    if disk<warn_disk then
        settings_table[12]['fg_colour']=normal
    elseif disk<crit_disk then
        settings_table[12]['fg_colour']=warn
    else
        settings_table[12]['fg_colour']=crit
    end
end
