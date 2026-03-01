local resolution = 32

local function removeFirst(tbl,val)
    for i,v in ipairs(tbl) do
        if v == val then
            return table.remove(tbl,i)
        end
    end
end

local function deep_tint (tabl, tint)  --thx darkfrei
    for i,  v in pairs (tabl) do
        if type (v) == "table" then
            deep_tint (v, tint)
        end
    end
    if tabl.picture then
        tabl.tint = tint
    end
end


-- Lookup table for rotated variants of sprites. For each key, its value is a table of evenly spaced rotations over 360 degrees.
-- This isn't necessarily the smartest way to do this, but it is a pretty quick and straightforward way to start with figuring out
-- a nice-looking approach to glyph rotations in the first place. A more practical solution might be to define these relationships
-- by how they're arranged in a single sprite sheet, which would also greatly simplify how we tell Factorio where each frame of a
-- rotation is, as opposed to defining every one of them individually as they are now. It works for now, though.
local glyph_rotation_groups = {
    ["┃"] = { "┃", "╱", "━", "╲", "┃", "╱", "━", "╲" },
    ["╋"] = { "╋", "⤫", "╋", "⤫", "╋", "⤫", "╋", "⤫" },
    ["└"] = { "└", "┌", "┐", "┘" },
    ["┗"] = { "┗", "┏", "┓", "┛" },
    ["┻"] = { "┻", "┣", "┳", "┫" },
    ["╹"] = { "╹", "╺", "╻", "╸" },
    ["◝"] = { "◝", "◞", "◟", "◜" },
    ["▴"] = { "▴", "▸", "▾", "◂" },
}
-- Build some big dumb lookup tables
local glyph_rotations = {}
for _, r in pairs(glyph_rotation_groups) do
    glyph_rotations[r[1]] = r
    local n = #r
    for i = 2, n do
        if not glyph_rotations[r[i]] then
            rr = { r[i] }
            for j = 2, n do
                rr[j] = r[(i + j - 2) % n + 1]
            end
            glyph_rotations[r[i]] = rr
        end
    end
end

-- Rotate a glyph for the orientation, o. Orientation ranges from 0 to 1, with 0 and 1 referring to "north", increasing in the clockwise direction.
---@param glyph string
---@param o RealOrientation
---@return string
local function rotated_glyph(glyph, o)
    local map = glyph_rotations[glyph]
    if not map then return glyph end
    local n = #map
    return map[math.floor(o * n + 0.5) % n + 1]
end

local tau = math.pi * 2
local cos = math.cos
local sin = math.sin

-- Rather than rotating glyph offsets in the usual fashion, we skew them instead. This lets sprites smoothly slide past each
-- other without unsightly gaps or overlaps for diagonal orientations. Skewing is always done laterally relative to the given
-- orientation, approaching a full grid step of skew at an offset of 45 degrees from cardinal directions. Discontinuities exist
-- where those regions meet, but the overall result is much nicer-looking than the alternative. Horizontal skewing is used at those
-- exact orientations.
--
-- Direction counts that are a factor of 8 ensure faithful grid-alignment always, at least locally, without off-grid "cheating".
-- Multiples of 8 will include the discontinuities though (where the skewing is also the most extreme). To avoid those, a count of
-- 12 is a decent minimum that includes the cardinal directions, or 36 for visually smoother (though still clearly discrete) steps.
---@param shift Vector
---@param o RealOrientation
---@return Vector
local function rotated_shift(shift, o)
    local x, y = shift[1], shift[2]
    o = o*tau
    local s, c = sin(o), cos(o)
    if c*c >= 0.5 then
        -- Skew horizontally
        return {
            (c < 0 and -1 or 1)*(x - y * s/c),
            c < 0 and -y or y,
        }
    else
        -- Skew vertically
        return {
            s < 0 and y or -y,
            (s < 0 and -1 or 1)*(x + y * c/s),
        }
    end
end

local function helper(arg)
    local chars,ftint,x,y,btint,b,offx,offy,offz,var,dir,fram,linlen,cwidth,cheight,cres,canimlen = arg.chars,arg.ftint,arg.x,arg.y,arg.btint,arg.b,arg.offx,arg.offy,arg.offz,arg.var,arg.dir,arg.fram,arg.linlen,arg.cwidth,arg.cheight,arg.cres,arg.canimlen


    if chars == nil then chars = "a," end
    if b == nil then b = "background" end
    if x == nil then x = 3 end
    if y == nil then y = 3 end
    if ftint == nil then ftint = {{r=0.5,g=0.5,b=0.5}} end
    if btint == nil then btint = {{r=0,g=0,b=0}} end
    if offx == nil then offx = 0 end
    if offy == nil then offy = 0 end
    if offz == nil then offz = 0 end
    if var == nil then var = 1 end
    if dir == nil then dir = 1 end
    if fram == nil then fram = 1 end
    if linlen == nil then linlen = 1 end
    if cwidth == nil then cwidth = 1 end
    if cheight == nil then cheight = 1 end
    if cres == nil then cres = resolution end
    if canimlen == nil then canimlen = 1 end
    local allen = x*y
    if #chars == 2 then chars = string.rep(chars,allen) end
    if #ftint == 1 then
        for i = 1,allen do
            ftint[i] = ftint[1]
        end
    end
    if #btint == 1 then
        for i = 1,allen do
            btint[i] = btint[1]
        end
    end
    local layerstable = {}
    offx = offx - (x-1)/2
    offy = offy - (y-1)/2
    local i = 1
    for char in string.gmatch(chars,'([^,]+)') do
        local xcord=(i-1)%x + offx
        local ycord=math.floor((i-1)/x) + offy
        if char == " " then char = "≞" end
        if b == " " then b = "≞" end
        -- individual filenames and shifts for each rotation frame
        local filename_bg, filename, shift
        local filenames_bg, filenames, frames = {}, {}, {}
        for j=1,dir do
            local o = (j-1)/dir
            filenames_bg[j] = "__pixeltorio_base_ent__/graphics/tileset/" .. rotated_glyph(b, o) .. ".png"
            filenames[j] = "__pixeltorio_base_ent__/graphics/tileset/" .. rotated_glyph(char, o) .. ".png"
            local fshift = rotated_shift({ xcord*resolution/cres, ycord*resolution/cres }, o)
            fshift[2] = fshift[2] - offz
            frames[j] = {
                shift = fshift,
                x = 0, y = 0, -- All sprites are single frames
            }
        end
        if dir == 1 then
            filename_bg = filenames_bg[1]
            filename = filenames[1]
            shift = frames[1].shift
            filenames_bg = nil
            filenames = nil
            frames = nil
        end
        layerstable[i*2-1] =   {filename=filename_bg,filenames=filenames_bg,frames=frames,width=resolution*cwidth,height=resolution*cheight,scale=32/cres,tint=btint[i],shift=shift,variation_count=var,direction_count=dir,frame_count=fram,priority="extra-high-no-scale",animation_speed=1/(60*canimlen)}
        layerstable[i*2] = {filename=filename,filenames=filenames,frames=frames,width=resolution*cwidth,height=resolution*cheight,scale=32/cres,tint=ftint[i],shift=shift,variation_count=var,direction_count=dir,frame_count=fram,priority="extra-high-no-scale",animation_speed=1/(60*canimlen),apply_runtime_tint=arg.apply_runtime_tint}
        -- Individual sprite graphics
        layerstable[i*2-1].lines_per_file = 1
        layerstable[i*2-1].line_length = linlen
        layerstable[i*2].lines_per_file = 1
        layerstable[i*2].line_length = linlen
        -- Thanks to a more enlightened approach to asset creation, these sprites do not suffer from the usual flaws introduced by 3D rendering software
        layerstable[i*2-1].apply_projection = false
        layerstable[i*2].apply_projection = false
        i=i+1
    end
    return layerstable
end


data.raw["resource"]["calcite"].stages.sheet={filename="__pixeltorio_base_ent__/graphics/tileset/resource.png",width=resolution,height=resolution,scale=32/resolution,variation_count=3,tint={r=0.87,g=0.87,b=0.87}}
data.raw["resource"]["calcite"].stage_counts={3000,1000,500}
data.raw["resource"]["calcite"].randomize_visual_position=false

data.raw["resource"]["tungsten-ore"].stages.sheet={filename="__pixeltorio_base_ent__/graphics/tileset/resource.png",width=resolution,height=resolution,scale=32/resolution,variation_count=3,tint={r=0.87,g=0.5,b=0.87}}
data.raw["resource"]["tungsten-ore"].stage_counts={3000,1000,500}
data.raw["resource"]["tungsten-ore"].randomize_visual_position=false

data.raw["resource"]["sulfuric-acid-geyser"].stages.sheet=nil
data.raw["resource"]["sulfuric-acid-geyser"].stages.sheets=helper{chars="🌋",x=1,y=1,ftint={{r=1,g=1,b=0.3}},btint={{r=0,g=0,b=0,a=0}}}
data.raw["resource"]["sulfuric-acid-geyser"].randomize_visual_position=false
data.raw["resource"]["sulfuric-acid-geyser"].stateless_visualisation=nil

data.raw["simple-entity"]["huge-volcanic-rock"].pictures={layers=helper{chars="⛰,⛰,⛰,⛰,⛰,⛰,⛰,⛰,⛰",ftint={{r=0.5,g=0.3,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["simple-entity"]["big-volcanic-rock"].pictures={layers=helper{chars="⛰,⛰,⛰,⛰",x=2,y=2,ftint={{r=0.5,g=0.3,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}


data.raw["simple-entity"]["vulcanus-chimney"].pictures={layers=helper{chars="┏,━,┓,┃,⌇,┃,┗,━,┛",ftint={{r=0.6,g=0.6,b=0.3}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["simple-entity"]["vulcanus-chimney-faded"].pictures={layers=helper{chars="┏,━,┓,┃,⌇,┃,┗,━,┛",ftint={{r=0.5,g=0.5,b=0.3}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["simple-entity"]["vulcanus-chimney-cold"].pictures={layers=helper{chars="┏,━,┓,┃,⌇,┃,┗,━,┛",ftint={{r=0.4,g=0.4,b=0.3}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["simple-entity"]["vulcanus-chimney-truncated"].pictures={layers=helper{chars="┏,┓,┗,┛",x=2,y=2,btint={{r=0,g=0,b=0,a=0}}}}
data.raw["simple-entity"]["vulcanus-chimney-short"].pictures={layers=helper{chars="┏,┓,┗,┛",x=2,y=2,btint={{r=0,g=0,b=0,a=0}}}}
data.raw["simple-entity"]["vulcanus-chimney"].lower_pictures=nil
data.raw["simple-entity"]["vulcanus-chimney-faded"].lower_pictures=nil
data.raw["simple-entity"]["vulcanus-chimney-cold"].lower_pictures=nil
data.raw["simple-entity"]["vulcanus-chimney-truncated"].lower_pictures=nil
data.raw["simple-entity"]["vulcanus-chimney-short"].lower_pictures=nil
data.raw["simple-entity"]["vulcanus-chimney"].stateless_visualisation_variations=nil
data.raw["simple-entity"]["vulcanus-chimney-faded"].stateless_visualisation_variations=nil
data.raw["simple-entity"]["vulcanus-chimney-cold"].stateless_visualisation_variations=nil

data.raw["tree"]["ashland-lichen-tree-flaming"].stateless_visualisation_variations={{animation={sheet=helper{chars="🔥",x=1,y=1,offy=-1,cres=16,ftint={{r=1,g=0.25,b=0.25}}}[2]}}}

data.raw["assembling-machine"]["foundry"].graphics_set={
    animation={layers=helper{chars="⚙,≞,┏,━,┓,\z
                                     a,╱,┃,≈,┃,\z
                                     a,╱,┗,◒,┛,\z
                                     ◳,╱,╱,💧,╲,\z
                                    F,◳,◳,◳,🔥",x=5,y=5,ftint={{r=1,g=0.75,b=0.5}}}},
    idle_animation={layers=helper{chars="⚙,≞,┏,━,┓,\z
                                          a,╱,┃,≈,┃,\z
                                          a,╱,┗,◒,┛,\z
                                          ◳,╱,╱,💧,╲,\z
                                          F,◳,◳,◳,🔥",x=5,y=5}},
}
data.raw["assembling-machine"]["foundry"].fluid_boxes[1].pipe_covers={
    north={layers=helper{chars="⊤",x=1,y=1,offy=1}},
    south={layers=helper{chars="⊥",x=1,y=1,offy=-1}},
    east={layers=helper{chars="⊣",x=1,y=1,offx=-1}},
    west={layers=helper{chars="⊢",x=1,y=1,offx=1}}
}
data.raw["assembling-machine"]["foundry"].fluid_boxes[1].pipe_picture=data.raw["assembling-machine"]["assembling-machine-2"].fluid_boxes[1].pipe_covers
data.raw["assembling-machine"]["foundry"].fluid_boxes[1].render_layer="higher-object-above"
data.raw["assembling-machine"]["foundry"].fluid_boxes[1].enable_working_visualisations=nil
data.raw["assembling-machine"]["foundry"].fluid_boxes[2].pipe_covers={
    north={layers=helper{chars="⊤",x=1,y=1,offy=1}},
    south={layers=helper{chars="⊥",x=1,y=1,offy=-1}},
    east={layers=helper{chars="⊣",x=1,y=1,offx=-1}},
    west={layers=helper{chars="⊢",x=1,y=1,offx=1}}
}
data.raw["assembling-machine"]["foundry"].fluid_boxes[2].pipe_picture=data.raw["assembling-machine"]["assembling-machine-2"].fluid_boxes[1].pipe_covers
data.raw["assembling-machine"]["foundry"].fluid_boxes[2].render_layer="higher-object-above"
data.raw["assembling-machine"]["foundry"].fluid_boxes[2].enable_working_visualisations=nil
data.raw["assembling-machine"]["foundry"].fluid_boxes[3].pipe_covers={
    north={layers=helper{chars="⊤",x=1,y=1,offy=1}},
    south={layers=helper{chars="⊥",x=1,y=1,offy=-1}},
    east={layers=helper{chars="⊣",x=1,y=1,offx=-1}},
    west={layers=helper{chars="⊢",x=1,y=1,offx=1}}
}
data.raw["assembling-machine"]["foundry"].fluid_boxes[3].pipe_picture=data.raw["assembling-machine"]["assembling-machine-2"].fluid_boxes[1].pipe_covers
data.raw["assembling-machine"]["foundry"].fluid_boxes[3].render_layer="higher-object-above"
data.raw["assembling-machine"]["foundry"].fluid_boxes[3].enable_working_visualisations=nil
data.raw["assembling-machine"]["foundry"].fluid_boxes[4].pipe_covers={
    north={layers=helper{chars="⊤",x=1,y=1,offy=1}},
    south={layers=helper{chars="⊥",x=1,y=1,offy=-1}},
    east={layers=helper{chars="⊣",x=1,y=1,offx=-1}},
    west={layers=helper{chars="⊢",x=1,y=1,offx=1}}
}
data.raw["assembling-machine"]["foundry"].fluid_boxes[4].pipe_picture=data.raw["assembling-machine"]["assembling-machine-2"].fluid_boxes[1].pipe_covers
data.raw["assembling-machine"]["foundry"].fluid_boxes[4].render_layer="higher-object-above"
data.raw["assembling-machine"]["foundry"].fluid_boxes[4].enable_working_visualisations=nil
data.raw["corpse"]["foundry-remnants"].animation={layers=helper{chars="⚙,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,F,∅,∅,∅,∅",ftint={{r=1,g=0.3,b=0.5}}}}

data.raw["transport-belt"]["turbo-transport-belt"].belt_animation_set={
    animation_set={
        filename="__pixeltorio_base_ent__/graphics/tileset/belt.png",width=resolution,height=resolution,scale=32/resolution,direction_count=13,tint={r=0.25,g=1,b=0.25}
    },
    north_index=1,
    south_index=2,
    east_index=3,
    west_index=4,
    south_to_east_index=5,
    south_to_west_index=6,
    north_to_east_index=7,
    north_to_west_index=8,
    west_to_north_index=9,
    west_to_south_index=10,
    east_to_north_index=11,
    east_to_south_index=12,
    starting_north_index=13,
    starting_south_index=13,
    starting_east_index=13,
    starting_west_index=13,
    ending_north_index=13,
    ending_south_index=13,
    ending_east_index=13,
    ending_west_index=13,
}
data.raw["corpse"]["turbo-transport-belt-remnants"].animation={layers=helper{chars="▲",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}

data.raw["underground-belt"]["turbo-underground-belt"].structure={
    direction_in={
        north={layers=helper{chars="⨺1",x=1,y=1,ftint={{r=0.25,g=1,b=0.25}}}},
        south={layers=helper{chars="⨺2",x=1,y=1,ftint={{r=0.25,g=1,b=0.25}}}},
        east={layers=helper{chars="⨺3",x=1,y=1,ftint={{r=0.25,g=1,b=0.25}}}},
        west={layers=helper{chars="⨺4",x=1,y=1,ftint={{r=0.25,g=1,b=0.25}}}},
    },
    direction_out={
        north={layers=helper{chars="⨹2",x=1,y=1,ftint={{r=0.25,g=1,b=0.25}}}},
        south={layers=helper{chars="⨹1",x=1,y=1,ftint={{r=0.25,g=1,b=0.25}}}},
        east={layers=helper{chars="⨹4",x=1,y=1,ftint={{r=0.25,g=1,b=0.25}}}},
        west={layers=helper{chars="⨹3",x=1,y=1,ftint={{r=0.25,g=1,b=0.25}}}},
    }
}
data.raw["underground-belt"]["turbo-underground-belt"].belt_animation_set=nil
data.raw["corpse"]["turbo-underground-belt-remnants"].animation={layers=helper{chars="⨺",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}

data.raw["splitter"]["turbo-splitter"].structure={
    north={layers=helper{chars="ṡ1,ṡ1",x=2,y=1,ftint={{r=0.25,g=1,b=0.25}}}},
    south={layers=helper{chars="ṡ2,ṡ2",x=2,y=1,ftint={{r=0.25,g=1,b=0.25}}}},
    east={layers=helper{chars="ṡ3,ṡ3",x=1,y=2,ftint={{r=0.25,g=1,b=0.25}}}},
    west={layers=helper{chars="ṡ4,ṡ4",x=1,y=2,ftint={{r=0.25,g=1,b=0.25}}}},
}
data.raw["splitter"]["turbo-splitter"].structure_patch=nil
data.raw["splitter"]["turbo-splitter"].belt_animation_set=nil
data.raw["corpse"]["turbo-splitter-remnants"].animation={layers=helper{chars="ṡ1",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}} --should fix later


data.raw["mining-drill"]["big-mining-drill"].graphics_set={
    animation={
        north={
            layers=helper{chars="⛏,━,▴,━,┓,┃,m,m,m,┃,┃,m,m,m,┃,┃,m,m,b,┃,┗,━,━,━,┛",x=5,y=5,ftint={{r=0.5,g=0.5,b=1}}}
        },
        south={
            layers=helper{chars="⛏,━,━,━,┓,┃,m,m,m,┃,┃,m,m,m,┃,┃,m,m,b,┃,┗,━,▾,━,┛",x=5,y=5,ftint={{r=0.5,g=0.5,b=1}}}
        },
        east={
            layers=helper{chars="⛏,━,━,━,┓,┃,m,m,m,┃,┃,m,m,m,▸,┃,m,m,b,┃,┗,━,━,━,┛",x=5,y=5,ftint={{r=0.5,g=0.5,b=1}}}
        },
        west={
            layers=helper{chars="⛏,━,━,━,┓,┃,m,m,m,┃,◂,m,m,m,┃,┃,m,m,b,┃,┗,━,━,━,┛",x=5,y=5,ftint={{r=0.5,g=0.5,b=1}}}
        }
    },
    idle_animation={
        north={
            layers=helper{chars="⛏,━,▴,━,┓,┃,m,m,m,┃,┃,m,m,m,┃,┃,m,m,b,┃,┗,━,━,━,┛",x=5,y=5}
        },
        south={
            layers=helper{chars="⛏,━,━,━,┓,┃,m,m,m,┃,┃,m,m,m,┃,┃,m,m,b,┃,┗,━,▾,━,┛",x=5,y=5}
        },
        east={
            layers=helper{chars="⛏,━,━,━,┓,┃,m,m,m,┃,┃,m,m,m,▸,┃,m,m,b,┃,┗,━,━,━,┛",x=5,y=5}
        },
        west={
            layers=helper{chars="⛏,━,━,━,┓,┃,m,m,m,┃,◂,m,m,m,┃,┃,m,m,b,┃,┗,━,━,━,┛",x=5,y=5}
        }
    },
}
data.raw["mining-drill"]["big-mining-drill"].wet_mining_graphics_set={
    animation={
        north={
            layers=helper{chars="⛏,━,▴,━,┓,⊢,m,m,m,⊣,┃,m,m,m,┃,┃,m,m,b,┃,┗,⊥,━,⊥,┛",x=5,y=5,ftint={{r=0.5,g=0.5,b=1}}}
        },
        south={
            layers=helper{chars="⛏,⊤,━,⊤,┓,┃,m,m,m,┃,┃,m,m,m,┃,⊢,m,m,b,⊣,┗,━,▾,━,┛",x=5,y=5,ftint={{r=0.5,g=0.5,b=1}}}
        },
        east={
            layers=helper{chars="⛏,━,━,⊤,┓,⊢,m,m,m,┃,┃,m,m,m,▸,⊢,m,m,b,┃,┗,━,━,⊥,┛",x=5,y=5,ftint={{r=0.5,g=0.5,b=1}}}
        },
        west={
            layers=helper{chars="⛏,⊤,━,━,┓,┃,m,m,m,⊣,◂,m,m,m,┃,┃,m,m,b,⊣,┗,⊥,━,━,┛",x=5,y=5,ftint={{r=0.5,g=0.5,b=1}}}
        }
    },
    idle_animation={
        north={
            layers=helper{chars="⛏,━,▴,━,┓,⊢,m,m,m,⊣,┃,m,m,m,┃,┃,m,m,b,┃,┗,⊥,━,⊥,┛",x=5,y=5}
        },
        south={
            layers=helper{chars="⛏,⊤,━,⊤,┓,┃,m,m,m,┃,┃,m,m,m,┃,⊢,m,m,b,⊣,┗,━,▾,━,┛",x=5,y=5}
        },
        east={
            layers=helper{chars="⛏,━,━,⊤,┓,⊢,m,m,m,┃,┃,m,m,m,▸,⊢,m,m,b,┃,┗,━,━,⊥,┛",x=5,y=5}
        },
        west={
            layers=helper{chars="⛏,⊤,━,━,┓,┃,m,m,m,⊣,◂,m,m,m,┃,┃,m,m,b,⊣,┗,⊥,━,━,┛",x=5,y=5}
        }
    },
}
data.raw["corpse"]["big-mining-drill-remnants"].animation={layers=helper{chars="∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,⛏,∅,∅,∅,∅,∅,∅,∅,∅,∅,b,∅,∅",x=5,y=5,ftint={{r=1,g=0.3,b=0.5}}}}


--data.raw["mining-drill"]["electric-mining-drill"].output_fluid_box.pipe_covers=nil
--data.raw["mining-drill"]["electric-mining-drill"].output_fluid_box.pipe_picture=nil
data.raw["mining-drill"]["big-mining-drill"].input_fluid_box.pipe_covers=nil
data.raw["mining-drill"]["big-mining-drill"].input_fluid_box.pipe_picture=nil
data.raw["mining-drill"]["big-mining-drill"].working_sound.sound_accents[1].play_for_working_visualisation=nil
data.raw["mining-drill"]["big-mining-drill"].integration_patch=nil


data.raw["segmented-unit"]["small-demolisher"].animation={layers={helper{chars="🐌",x=1,y=1,cres=8,ftint={{r=0.7,g=0.6,b=0.6}}}[2]}}
data.raw["segmented-unit"]["medium-demolisher"].animation={layers={helper{chars="🐌",x=1,y=1,cres=6,ftint={{r=0.8,g=0.6,b=0.6}}}[2]}}
data.raw["segmented-unit"]["big-demolisher"].animation={layers={helper{chars="🐌",x=1,y=1,cres=4,ftint={{r=0.9,g=0.6,b=0.6}}}[2]}}

segmentcount=1
for segmentname,segmenttable in pairs(data.raw["segment"]) do
    if string.find(segmentname,".*small.*") ~= nil then
        segmenttable.animation = {filename= "__pixeltorio_base_ent__/graphics/tileset/" .. "segments" .. ".png",width=resolution,height=resolution,scale=64/resolution,direction_count=8,tint={r=0.7,g=0.6,b=0.6}}
        segmentcount = segmentcount+1
    end
    if string.find(segmentname,".*medium.*") ~= nil then
        segmenttable.animation = {filename= "__pixeltorio_base_ent__/graphics/tileset/" .. "segments" .. ".png",width=resolution,height=resolution,scale=96/resolution,direction_count=8,tint={r=0.8,g=0.6,b=0.6}}
        segmentcount = segmentcount+1
    end
    if string.find(segmentname,".*big.*") ~= nil then
        segmenttable.animation = {filename= "__pixeltorio_base_ent__/graphics/tileset/" .. "segments" .. ".png",width=resolution,height=resolution,scale=128/resolution,direction_count=8,tint={r=0.9,g=0.6,b=0.6}}
        segmentcount = segmentcount+1
    end
end

data.raw["corpse"]["small-demolisher-trail-lower"].ground_patch={layers=helper{chars="🕳",x=1,y=1,cres=9,ftint={{r=0.2,g=0.2,b=0.2}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["corpse"]["small-demolisher-trail-upper"].ground_patch={layers=helper{chars="🕳",x=1,y=1,cres=9,ftint={{r=0.2,g=0,b=0}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["corpse"]["medium-demolisher-trail-lower"].ground_patch={layers=helper{chars="🕳",x=1,y=1,cres=6,ftint={{r=0.2,g=0.2,b=0.2}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["corpse"]["medium-demolisher-trail-upper"].ground_patch={layers=helper{chars="🕳",x=1,y=1,cres=6,ftint={{r=0.2,g=0,b=0}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["corpse"]["big-demolisher-trail-lower"].ground_patch={layers=helper{chars="🕳",x=1,y=1,cres=4.5,ftint={{r=0.2,g=0.2,b=0.2}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["corpse"]["big-demolisher-trail-upper"].ground_patch={layers=helper{chars="🕳",x=1,y=1,cres=4.5,ftint={{r=0.2,g=0,b=0}},btint={{r=0,g=0,b=0,a=0}}}}

data.raw["smoke-with-trigger"]["small-demolisher-ash-cloud-trail"].animation={layers={helper{chars="⌇",x=1,y=1,ftint={{r=1,g=0.63,b=0.63}}}[2]}}
data.raw["smoke-with-trigger"]["medium-demolisher-ash-cloud-trail"].animation={layers={helper{chars="⌇",x=1,y=1,ftint={{r=1,g=0.63,b=0.63}}}[2]}}
data.raw["smoke-with-trigger"]["big-demolisher-ash-cloud-trail"].animation={layers={helper{chars="⌇",x=1,y=1,ftint={{r=1,g=0.63,b=0.63}}}[2]}}

data.raw["simple-entity"]["small-demolisher-corpse"].pictures={layers=helper{chars="⛰,⛰,⛰,⛰,⛰,⛰,⛰,⛰,⛰",cres=32,ftint={{r=0.5,g=0.3,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["simple-entity"]["medium-demolisher-corpse"].pictures={layers=helper{chars="⛰,⛰,⛰,⛰,⛰,⛰,⛰,⛰,⛰",cres=24,ftint={{r=0.5,g=0.3,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["simple-entity"]["big-demolisher-corpse"].pictures={layers=helper{chars="⛰,⛰,⛰,⛰,⛰,⛰,⛰,⛰,⛰",cres=16,ftint={{r=0.5,g=0.3,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}

data.raw["corpse"]["small-demolisher-fissure-scorchmark"].animation=nil
data.raw["corpse"]["small-demolisher-fissure-scorchmark"].decay_animation=nil
data.raw["corpse"]["small-demolisher-fissure-scorchmark"].ground_patch={
            layers={
                helper{chars="🕳",x=1,y=1,cres=8,ftint={{r=1,g=0.5,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}[2],
                helper{chars="ኊ",x=1,y=1,cres=16,ftint={{r=1,g=1,b=0.5}},offy=0.375,btint={{r=0,g=0,b=0,a=0}}}[2],
            }
}

data.raw["corpse"]["medium-demolisher-fissure-scorchmark"].animation=nil
data.raw["corpse"]["medium-demolisher-fissure-scorchmark"].decay_animation=nil
data.raw["corpse"]["medium-demolisher-fissure-scorchmark"].ground_patch={
            layers={
                helper{chars="🕳",x=1,y=1,cres=4,ftint={{r=1,g=0.5,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}[2],
                helper{chars="ኊ",x=1,y=1,cres=8,ftint={{r=1,g=1,b=0.5}},offy=0.375,btint={{r=0,g=0,b=0,a=0}}}[2],
            }
}

data.raw["corpse"]["big-demolisher-fissure-scorchmark"].animation=nil
data.raw["corpse"]["big-demolisher-fissure-scorchmark"].decay_animation=nil
data.raw["corpse"]["big-demolisher-fissure-scorchmark"].ground_patch={
            layers={
                helper{chars="🕳",x=1,y=1,cres=2,ftint={{r=1,g=0.5,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}[2],
                helper{chars="ኊ",x=1,y=1,cres=4,ftint={{r=1,g=1,b=0.5}},offy=0.375,btint={{r=0,g=0,b=0,a=0}}}[2],
            }
}


data.raw["cliff"]["cliff-vulcanus"].orientations={
    north_to_none={
        pictures={sheet={layers=helper{chars="🏔,🏔,≞,🏔,🏔,🗻,≞,🗻,🗻",btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=16,
        collision_bounding_box={{-1,-1.5},{2.5,0},0.125}
    },
    north_to_south={
        pictures={sheet={layers=helper{chars="🏔,🏔,🏔,🏔,🏔,🏔,🏔,🏔",x=2,y=4,btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-1,-2},{1,2},0}
    },
    north_to_east={
        pictures={sheet={layers=helper{chars="🏔,🏔,≞,🏔,🏔,🏔,≞,🏔,🏔",offx=1,offy=-1,btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-0.5,-1},{3,0.5},0.125} --
    },
    north_to_west={
        pictures={sheet={layers=helper{chars="≞,🏔,🏔,🏔,🏔,🏔,🏔,🏔,≞",offx=-1,offy=-1,btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-2.5,-2},{1,-0.5},0.875}
    },
    south_to_north={
        pictures={sheet={layers=helper{chars="🏔,🏔,🏔,🏔,🏔,🏔,🏔,🏔",x=2,y=4,btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-1,-2},{1,2},0}
    },
    south_to_none={
        pictures={sheet={layers=helper{chars="🗻,🗻,≞,🗻,🏔,🏔,≞,🏔,🏔",offx=-1,offy=1,btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-2.5,0},{0.5,1.5},0.125}
    },
    south_to_east={
        pictures={sheet={layers=helper{chars="≞,🏔,🏔,🏔,🏔,🏔,🏔,🏔,≞",offx=1,offy=1,btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-0.5,0.5},{3,2},0.875} --
    },
    south_to_west={
        pictures={sheet={layers=helper{chars="🏔,🏔,≞,🏔,🏔,🏔,≞,🏔,🏔",offx=-1,offy=1,btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-2.5,0.5},{1,2},0.125}
    },
    east_to_north={
        pictures={sheet={layers=helper{chars="🏔,🏔,≞,🏔,🏔,🏔,≞,🏔,🏔",offx=1,offy=-1,btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-1,-2},{2.5,-0.5},0.125}
    },
    east_to_south={
        pictures={sheet={layers=helper{chars="≞,🏔,🏔,🏔,🏔,🏔,🏔,🏔,≞",offy=1,offx=1,btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-1,0.5},{2.5,2},0.875}
    },
    east_to_none={
        pictures={sheet={layers=helper{chars="≞,🏔,🏔,🗻,🏔,🏔,🗻,🗻,≞",offy=1,offx=1,btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=16,
        collision_bounding_box={{-0.5,0},{2,1.5},0.875}
    },
    east_to_west={
        pictures={sheet={layers=helper{chars="🏔,🏔,🏔,🏔",x=4,y=1,btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-2,-0.5},{2,0.5},0}
    },
    west_to_north={
        pictures={sheet={layers=helper{chars="≞,🏔,🏔,🏔,🏔,🏔,🏔,🏔,≞",offx=-1,offy=-1,btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-3,-1},{0.5,0.5},0.875}--
    },
    west_to_south={
        pictures={sheet={layers=helper{chars="🏔,🏔,≞,🏔,🏔,🏔,≞,🏔,🏔",offx=-1,offy=1,btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-3,0.5},{0.5,2},0.125}--
    },
    west_to_east={
        pictures={sheet={layers=helper{chars="🏔,🏔,🏔,🏔,🏔,🏔,🏔,🏔,🏔,🏔,🏔,🏔",x=4,y=3,btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-2,-1.5},{2,1.5},0}
    },
    west_to_none={
        pictures={sheet={layers=helper{chars="🏔,🗻,🏔,🗻,🏔,🗻",x=2,y=3,offx=-1,btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=16,
        collision_bounding_box={{-2,-1.5},{0,1.5},0}
    },
    none_to_north={
        pictures={sheet={layers=helper{chars="≞,🏔,🏔,🗻,🏔,🏔,🗻,🗻,≞",offx=-1,offy=-1,btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=16,
        collision_bounding_box={{-2.5,-1.5},{1,0},0.875}
    },
    none_to_south={
        pictures={sheet={layers=helper{chars="≞,🗻,🗻,🏔,🏔,🗻,🏔,🏔,≞",offy=1,offx=1,btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=16,
        collision_bounding_box={{-1,0},{2,1.5},0.875}
    },
    none_to_east={
        pictures={sheet={layers=helper{chars="🗻,🏔,🗻,🏔,🗻,🏔",x=2,y=3,offx=1,btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=16,
        collision_bounding_box={{0,-1.5},{2,1.5},0}
    },
    none_to_west={
        pictures={sheet={layers=helper{chars="🏔,🏔,≞,🏔,🏔,🗻,≞,🗻,🗻",offx=-1,offy=1,btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=16,
        collision_bounding_box={{-2.5,0},{0.5,1.5},0.125}
    },
}

data.raw["cliff"]["crater-cliff"].orientations={
    north_to_none={
        pictures={sheet={layers=helper{chars="🏔,🏔,≞,🏔,🏔,🗻,≞,🗻,🗻",ftint={{r=0.5,g=0.4,b=0.4}},btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=16,
        collision_bounding_box={{-1,-1.5},{2.5,0},0.125}
    },
    north_to_south={
        pictures={sheet={layers=helper{chars="🗻,🗻,🏔,🏔,🏔,🏔,🗻,🗻",x=2,y=4,ftint={{r=0.5,g=0.4,b=0.4}},btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-1,-2},{1,2},0}
    },
    north_to_east={
        pictures={sheet={layers=helper{chars="🗻,🗻,≞,🗻,🏔,🗻,≞,🗻,🗻",offx=1,offy=-1,ftint={{r=0.5,g=0.4,b=0.4}},btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-0.5,-1},{3,0.5},0.125} --
    },
    north_to_west={
        pictures={sheet={layers=helper{chars="≞,🗻,🗻,🗻,🏔,🗻,🗻,🗻,≞",offx=-1,offy=-1,ftint={{r=0.5,g=0.4,b=0.4}},btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-2.5,-2},{1,-0.5},0.875}
    },
    south_to_north={
        pictures={sheet={layers=helper{chars="🗻,🗻,🏔,🏔,🏔,🏔,🗻,🗻",x=2,y=4,ftint={{r=0.5,g=0.4,b=0.4}},btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-1,-2},{1,2},0}
    },
    south_to_none={
        pictures={sheet={layers=helper{chars="🗻,🗻,≞,🗻,🏔,🏔,≞,🏔,🏔",offx=-1,offy=1,ftint={{r=0.5,g=0.4,b=0.4}},btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-2.5,0},{0.5,1.5},0.125}
    },
    south_to_east={
        pictures={sheet={layers=helper{chars="≞,🗻,🗻,🗻,🏔,🗻,🗻,🗻,≞",offx=1,offy=1,ftint={{r=0.5,g=0.4,b=0.4}},btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-0.5,0.5},{3,2},0.875} --
    },
    south_to_west={
        pictures={sheet={layers=helper{chars="🗻,🗻,≞,🗻,🏔,🗻,≞,🗻,🗻",offx=-1,offy=1,ftint={{r=0.5,g=0.4,b=0.4}},btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-2.5,0.5},{1,2},0.125}
    },
    east_to_north={
        pictures={sheet={layers=helper{chars="🗻,🗻,≞,🗻,🏔,🗻,≞,🗻,🗻",offx=1,offy=-1,ftint={{r=0.5,g=0.4,b=0.4}},btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-1,-2},{2.5,-0.5},0.125}
    },
    east_to_south={
        pictures={sheet={layers=helper{chars="≞,🗻,🗻,🗻,🏔,🗻,🗻,🗻,≞",offy=1,offx=1,ftint={{r=0.5,g=0.4,b=0.4}},btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-1,0.5},{2.5,2},0.875}
    },
    east_to_none={
        pictures={sheet={layers=helper{chars="≞,🏔,🏔,🗻,🏔,🏔,🗻,🗻,≞",offy=1,offx=1,ftint={{r=0.5,g=0.4,b=0.4}},btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=16,
        collision_bounding_box={{-0.5,0},{2,1.5},0.875}
    },
    east_to_west={
        pictures={sheet={layers=helper{chars="🗻,🏔,🏔,🗻",x=4,y=1,ftint={{r=0.5,g=0.4,b=0.4}},btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-2,-0.5},{2,0.5},0}
    },
    west_to_north={
        pictures={sheet={layers=helper{chars="≞,🗻,🗻,🗻,🏔,🗻,🗻,🗻,≞",offx=-1,offy=-1,ftint={{r=0.5,g=0.4,b=0.4}},btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-3,-1},{0.5,0.5},0.875}--
    },
    west_to_south={
        pictures={sheet={layers=helper{chars="🗻,🗻,≞,🗻,🏔,🗻,≞,🗻,🗻",offx=-1,offy=1,ftint={{r=0.5,g=0.4,b=0.4}},btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-3,0.5},{0.5,2},0.125}--
    },
    west_to_east={
        pictures={sheet={layers=helper{chars="🗻,🏔,🏔,🗻,🗻,🏔,🏔,🗻,🗻,🏔,🏔,🗻",x=4,y=3,ftint={{r=0.5,g=0.4,b=0.4}},btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=32,
        collision_bounding_box={{-2,-1.5},{2,1.5},0}
    },
    west_to_none={
        pictures={sheet={layers=helper{chars="🏔,🗻,🏔,🗻,🏔,🗻",x=2,y=3,offx=-1,ftint={{r=0.5,g=0.4,b=0.4}},btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=16,
        collision_bounding_box={{-2,-1.5},{0,1.5},0}
    },
    none_to_north={
        pictures={sheet={layers=helper{chars="≞,🏔,🏔,🗻,🏔,🏔,🗻,🗻,≞",offx=-1,offy=-1,ftint={{r=0.5,g=0.4,b=0.4}},btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=16,
        collision_bounding_box={{-2.5,-1.5},{1,0},0.875}
    },
    none_to_south={
        pictures={sheet={layers=helper{chars="≞,🗻,🗻,🏔,🏔,🗻,🏔,🏔,≞",offy=1,offx=1,ftint={{r=0.5,g=0.4,b=0.4}},btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=16,
        collision_bounding_box={{-1,0},{2,1.5},0.875}
    },
    none_to_east={
        pictures={sheet={layers=helper{chars="🗻,🏔,🗻,🏔,🗻,🏔",x=2,y=3,offx=1,ftint={{r=0.5,g=0.4,b=0.4}},btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=16,
        collision_bounding_box={{0,-1.5},{2,1.5},0}
    },
    none_to_west={
        pictures={sheet={layers=helper{chars="🏔,🏔,≞,🏔,🏔,🗻,≞,🗻,🗻",offx=-1,offy=1,ftint={{r=0.5,g=0.4,b=0.4}},btint={{r=0,g=0,b=0,a=0}}}}},
        fill_volume=16,
        collision_bounding_box={{-2.5,0},{0.5,1.5},0.125}
    },
}


data.raw["tile"]["lava-hot"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "≈" .. ".png"
        }
    },
    material_texture_width_in_tiles=1,
    material_texture_height_in_tiles=1,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "≈" .. ".png"
    }
}
data.raw["tile"]["lava-hot"].tint={r=1,g=0.63,b=0.63}
data.raw["tile"]["lava-hot"].effect=nil

data.raw["tile"]["lava"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "≈" .. ".png"
        }
    },
    material_texture_width_in_tiles=1,
    material_texture_height_in_tiles=1,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "≈" .. ".png"
    }
}
data.raw["tile"]["lava"].tint={r=1,g=0.5,b=0.5}
data.raw["tile"]["lava"].effect=nil




volcanicsymbol = {"♒","ኊ","ኊ","ኊ","background",
                  "♒","background","background","☸","background",
                  "て","ኊ","て","て","background",
                  "background","background"}

volcaniccount=1
volcaniccolors={{r=0.1,g=0.1,b=0.1},  {r=0.3,g=0.1,b=0.1},  {r=0.2,g=0.1,b=0.1},  {r=0.1,g=0.1,b=0.1},  {r=0,g=0,b=0},
                {r=0.15,g=0.15,b=0.15},  {r=0,g=0,b=0},  {r=0,g=0,b=0},  {r=0.13,g=0.09,b=0.09},  {r=0.1,g=0.1,b=0.1},
                {r=0.25,g=0.1,b=0.1},  {r=0.1,g=0.1,b=0.1},  {r=0.1,g=0.1,b=0.1},  {r=0.2,g=0.1,b=0.1},  {r=0.13,g=0.09,b=0.09},
                {r=0.15,g=0.1,b=0.1},  {r=0.15,g=0.12,b=0.12}}
for volcanicname,volcanictable in pairs(data.raw["tile"]) do
    if string.find(volcanicname,".*volcanic.*") ~= nil then
        volcanictable.variants={
            empty_transitions=true,
            main={
                {
                size=1,
                count=1,
                picture="__pixeltorio_base_ent__/graphics/tileset/" .. volcanicsymbol[volcaniccount] .. ".png"
                }
            },
            material_texture_width_in_tiles=1,
            material_texture_height_in_tiles=1,
            material_background={
                count=1,
                picture="__pixeltorio_base_ent__/graphics/tileset/" .. volcanicsymbol[volcaniccount] .. ".png"
            }
        }
        volcanictable.effect = nil
        volcanictable.tint = volcaniccolors[volcaniccount]
        volcaniccount = volcaniccount+1
    end
end

data.raw["tile"]["foundation"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "⊠" .. ".png"
        }
    },
    material_texture_width_in_tiles=1,
    material_texture_height_in_tiles=1,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "⊠" .. ".png"
    }
}
data.raw["tile"]["foundation"].tint={r=0.2,g=0.15,b=0.2}
data.raw["tile"]["foundation"].effect=nil











for railname,railtable in pairs(data.raw["elevated-straight-rail"]["elevated-straight-rail"].pictures) do
    if type(railtable) == "table" then --make sure its a table
        for subrailname,subrailtable in pairs(railtable) do
            if type(subrailtable) == "table" then
                if (string.find(subrailname,".*back.*") ~= nil) or (string.find(subrailname,".*tie.*") ~= nil) or (string.find(subrailname,".*stone.*") ~= nil) then 
                    subrailtable.filename='__pixeltorio_base_ent__/graphics/tileset/bigdummy.png'
                    subrailtable.x=0
                    subrailtable.y=0
                    subrailtable.filenames=nil
                    if subrailtable.layers then
                        subrailtable.layers=nil
                        subrailtable.width=1
                        subrailtable.height=1
                    end
                end
                if (string.find(subrailname,".*metal.*") ~= nil) then
                    subrailtable.tint={r=1,g=0.5,b=0.5}
                end
            end  
        end
        if string.find(railname,".*endings.*") ~= nil then
            data.raw["elevated-straight-rail"]["elevated-straight-rail"].pictures[railname]=nil
        end
    end
end
for fencename,fencetable in pairs(data.raw["elevated-straight-rail"]["elevated-straight-rail"].fence_pictures) do
    if type(fencetable) == "table" then
        if (string.find(fencename,".*side.*") ~= nil) then 
            for sidename,sidetable in pairs(fencetable) do 
                if (string.find(sidename,".*fence.*") ~= nil) then
                    for fenname,fentable in pairs(sidetable) do 
                        for dirname,dirtable in pairs(fentable) do 
                             for sheetame,sheettable in pairs(dirtable) do 
                                sheettable.filename='__pixeltorio_base_ent__/graphics/tileset/bigdummy.png'
                                sheettable.x=0
                                sheettable.y=0
                            end
                        end
                    end
                end
                if (string.find(sidename,".*ends.*") ~= nil) then
                    for subname,subtable in pairs(sidetable) do 
                        for fenname,fentable in pairs(subtable) do 
                            for dirname,dirtable in pairs(fentable) do 
                                for sheetame,sheettable in pairs(dirtable) do 
                                    sheettable.filename='__pixeltorio_base_ent__/graphics/tileset/bigdummy.png'
                                    sheettable.x=0
                                    sheettable.y=0
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

for railname,railtable in pairs(data.raw["elevated-half-diagonal-rail"]["elevated-half-diagonal-rail"].pictures) do
    if type(railtable) == "table" then --make sure its a table
        for subrailname,subrailtable in pairs(railtable) do
            if type(subrailtable) == "table" then
                if (string.find(subrailname,".*back.*") ~= nil) or (string.find(subrailname,".*tie.*") ~= nil) or (string.find(subrailname,".*stone.*") ~= nil) then 
                    subrailtable.filename='__pixeltorio_base_ent__/graphics/tileset/bigdummy.png'
                    subrailtable.x=0
                    subrailtable.y=0
                    subrailtable.filenames=nil
                    if subrailtable.layers then
                        subrailtable.layers=nil
                        subrailtable.width=1
                        subrailtable.height=1
                    end
                end
                if (string.find(subrailname,".*metal.*") ~= nil) then
                    subrailtable.tint={r=1,g=0.5,b=0.5}
                end
            end  
        end
        if string.find(railname,".*endings.*") ~= nil then
            data.raw["elevated-half-diagonal-rail"]["elevated-half-diagonal-rail"].pictures[railname]=nil
        end
    end
end
for fencename,fencetable in pairs(data.raw["elevated-half-diagonal-rail"]["elevated-half-diagonal-rail"].fence_pictures) do
    if type(fencetable) == "table" then
        if (string.find(fencename,".*side.*") ~= nil) then 
            for sidename,sidetable in pairs(fencetable) do 
                if (string.find(sidename,".*fence.*") ~= nil) then
                    for fenname,fentable in pairs(sidetable) do 
                        for dirname,dirtable in pairs(fentable) do 
                             for sheetame,sheettable in pairs(dirtable) do
                                sheettable.filename='__pixeltorio_base_ent__/graphics/tileset/bigdummy.png'
                                sheettable.x=0
                                sheettable.y=0
                            end
                        end
                    end
                end
                if (string.find(sidename,".*ends.*") ~= nil) then
                    for subname,subtable in pairs(sidetable) do 
                        for fenname,fentable in pairs(subtable) do 
                            for dirname,dirtable in pairs(fentable) do 
                                for sheetame,sheettable in pairs(dirtable) do 
                                    sheettable.filename='__pixeltorio_base_ent__/graphics/tileset/bigdummy.png'
                                    sheettable.x=0
                                    sheettable.y=0
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

for railname,railtable in pairs(data.raw["elevated-curved-rail-a"]["elevated-curved-rail-a"].pictures) do
    if type(railtable) == "table" then --make sure its a table
        for subrailname,subrailtable in pairs(railtable) do
            if type(subrailtable) == "table" then
                if (string.find(subrailname,".*back.*") ~= nil) or (string.find(subrailname,".*tie.*") ~= nil) or (string.find(subrailname,".*stone.*") ~= nil) then 
                    subrailtable.filename='__pixeltorio_base_ent__/graphics/tileset/bigdummy.png'
                    subrailtable.x=0
                    subrailtable.y=0
                    subrailtable.filenames=nil
                    if subrailtable.layers then
                        subrailtable.layers=nil
                        subrailtable.width=1
                        subrailtable.height=1
                    end
                end
                if (string.find(subrailname,".*metal.*") ~= nil) then
                    subrailtable.tint={r=1,g=0.5,b=0.5}
                end
            end  
        end
        if string.find(railname,".*endings.*") ~= nil then
            data.raw["elevated-curved-rail-a"]["elevated-curved-rail-a"].pictures[railname]=nil
        end
    end
end
for fencename,fencetable in pairs(data.raw["elevated-curved-rail-a"]["elevated-curved-rail-a"].fence_pictures) do
    if type(fencetable) == "table" then
        if (string.find(fencename,".*side.*") ~= nil) then 
            for sidename,sidetable in pairs(fencetable) do 
                if (string.find(sidename,".*fence.*") ~= nil) then
                    for fenname,fentable in pairs(sidetable) do 
                        for dirname,dirtable in pairs(fentable) do 
                             for sheetame,sheettable in pairs(dirtable) do 
                                sheettable.filename='__pixeltorio_base_ent__/graphics/tileset/bigdummy.png'
                                sheettable.x=0
                                sheettable.y=0
                            end
                        end
                    end
                end
                if (string.find(sidename,".*ends.*") ~= nil) then
                    for subname,subtable in pairs(sidetable) do 
                        for fenname,fentable in pairs(subtable) do 
                            for dirname,dirtable in pairs(fentable) do 
                                for sheetame,sheettable in pairs(dirtable) do 
                                    sheettable.filename='__pixeltorio_base_ent__/graphics/tileset/bigdummy.png'
                                    sheettable.x=0
                                    sheettable.y=0
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

for railname,railtable in pairs(data.raw["elevated-curved-rail-b"]["elevated-curved-rail-b"].pictures) do
    if type(railtable) == "table" then --make sure its a table
        for subrailname,subrailtable in pairs(railtable) do
            if type(subrailtable) == "table" then
                if (string.find(subrailname,".*back.*") ~= nil) or (string.find(subrailname,".*tie.*") ~= nil) or (string.find(subrailname,".*stone.*") ~= nil) or (string.find(subrailname,".*water.*") ~= nil) then 
                    subrailtable.filename='__pixeltorio_base_ent__/graphics/tileset/bigdummy.png'
                    subrailtable.x=0
                    subrailtable.y=0
                    subrailtable.filenames=nil
                    if subrailtable.layers then
                        subrailtable.layers=nil
                        subrailtable.width=1
                        subrailtable.height=1
                    end
                end
                if (string.find(subrailname,".*metal.*") ~= nil) then
                    subrailtable.tint={r=1,g=0.5,b=0.5}
                end
            end  
        end
        if string.find(railname,".*endings.*") ~= nil then
            data.raw["elevated-curved-rail-b"]["elevated-curved-rail-b"].pictures[railname]=nil
        end
    end
end
for fencename,fencetable in pairs(data.raw["elevated-curved-rail-b"]["elevated-curved-rail-b"].fence_pictures) do
    if type(fencetable) == "table" then
        if (string.find(fencename,".*side.*") ~= nil) then 
            for sidename,sidetable in pairs(fencetable) do 
                if (string.find(sidename,".*fence.*") ~= nil) then
                    for fenname,fentable in pairs(sidetable) do 
                        for dirname,dirtable in pairs(fentable) do 
                             for sheetame,sheettable in pairs(dirtable) do 
                                sheettable.filename='__pixeltorio_base_ent__/graphics/tileset/bigdummy.png'
                                sheettable.x=0
                                sheettable.y=0
                            end
                        end
                    end
                end
                if (string.find(sidename,".*ends.*") ~= nil) then
                    for subname,subtable in pairs(sidetable) do 
                        for fenname,fentable in pairs(subtable) do 
                            for dirname,dirtable in pairs(fentable) do 
                                for sheetame,sheettable in pairs(dirtable) do 
                                    sheettable.filename='__pixeltorio_base_ent__/graphics/tileset/bigdummy.png'
                                    sheettable.x=0
                                    sheettable.y=0
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

data.raw["rail-support"]["rail-support"].graphics_set={structure={layers=helper{chars="s,s,s,s,s,s,s,s,s",dir=48,ftint={{r=1,g=0.5,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}}

for railname,railtable in pairs(data.raw["rail-ramp"]["rail-ramp"].pictures) do
    if type(railtable) == "table" then --make sure its a table
        for subrailname,subrailtable in pairs(railtable) do
            if type(subrailtable) == "table" then
                if (string.find(subrailname,".*stone.*") ~= nil) or (string.find(subrailname,".*shadow.*") ~= nil) or (string.find(subrailname,".*water.*") ~= nil) then 
                    subrailtable.filename='__pixeltorio_base_ent__/graphics/tileset/bigdummy.png'
                    subrailtable.x=0
                    subrailtable.y=0
                    subrailtable.filenames=nil
                    if subrailtable.layers then
                        subrailtable.layers=nil
                        subrailtable.width=1
                        subrailtable.height=1
                    end
                end
                if (string.find(subrailname,".*background.*") ~= nil) then
                    if (string.find(railname,".*west.*") ~= nil) then
                        railtable[subrailname]={sheet={layers=helper{chars="r,r,┃,≞,≞,≞,≞,≞,≞,≞,≞,≞,≞,≞,r,r,\z
                                                                            r,≞,┃,≞,≞,≞,≞,┃,≞,≞,≞,≞,≞,≞,≞,r,\z
                                                                            r,≞,┃,≞,≞,≞,≞,┃,≞,≞,≞,≞,≞,≞,≞,r,\z
                                                                            r,r,≞,≞,≞,≞,≞,≞,≞,≞,≞,≞,≞,≞,r,r",x=16,y=4,ftint={{r=1,g=1,b=0.5}}}}}
                    end
                    if (string.find(railname,".*east.*") ~= nil) then
                        railtable[subrailname]={sheet={layers=helper{chars="r,r,≞,≞,≞,≞,≞,≞,≞,≞,≞,≞,≞,┃,r,r,\z
                                                                            r,≞,≞,≞,≞,≞,≞,≞,┃,≞,≞,≞,≞,┃,≞,r,\z
                                                                            r,≞,≞,≞,≞,≞,≞,≞,┃,≞,≞,≞,≞,┃,≞,r,\z
                                                                            r,r,≞,≞,≞,≞,≞,≞,≞,≞,≞,≞,≞,≞,r,r",x=16,y=4,ftint={{r=1,g=1,b=0.5}}}}}
                    end
                    if (string.find(railname,".*south.*") ~= nil) then
                        railtable[subrailname]={sheet={layers=helper{chars="r,r,r,r,\z
                                                                            r,≞,≞,r,\z
                                                                            ≞,≞,≞,≞,\z
                                                                            ≞,≞,≞,≞,\z
                                                                            ≞,≞,≞,≞,\z
                                                                            ≞,≞,≞,≞,\z
                                                                            ≞,╱,╲,≞,\z
                                                                            ≞,≞,≞,≞,\z
                                                                            ≞,≞,≞,≞,\z
                                                                            ≞,≞,≞,≞,\z
                                                                            ≞,≞,≞,≞,\z
                                                                            ≞,╱,╲,≞,\z
                                                                            ≞,≞,≞,≞,\z
                                                                            ╱,≞,≞,╲,\z
                                                                            r,≞,≞,r,\z
                                                                            r,r,r,r",x=4,y=16,ftint={{r=1,g=1,b=0.5}}}}}
                    end
                    if (string.find(railname,".*north.*") ~= nil) then
                        railtable[subrailname]={sheet={layers=helper{chars="r,r,r,r,\z
                                                                            r,╱,╲,r,\z
                                                                            ≞,≞,≞,≞,\z
                                                                            ╱,≞,≞,╲,\z
                                                                            ≞,≞,≞,≞,\z
                                                                            ≞,≞,≞,≞,\z
                                                                            ≞,≞,≞,≞,\z
                                                                            ≞,≞,≞,≞,\z
                                                                            ≞,╱,╲,≞,\z
                                                                            ≞,≞,≞,≞,\z
                                                                            ≞,≞,≞,≞,\z
                                                                            ≞,≞,≞,≞,\z
                                                                            ≞,≞,≞,≞,\z
                                                                            ≞,≞,≞,≞,\z
                                                                            r,≞,≞,r,\z
                                                                            r,r,r,r",x=4,y=16,ftint={{r=1,g=1,b=0.5}}}}}
                    end
                end
                if (string.find(subrailname,".*tie.*") ~= nil) then
                    railtable[subrailname]=table.deepcopy(data.raw["rail-ramp"]["rail-ramp"].pictures[railname].segment_visualisation_middle)
                    railtable[subrailname].tint={r=1,g=1,b=0.5}
                end
            end  
        end
        if string.find(railname,".*endings.*") ~= nil then
            data.raw["rail-ramp"]["rail-ramp"].pictures[railname]=nil
        end
    end
end
for fencename,fencetable in pairs(data.raw["rail-ramp"]["rail-ramp"].fence_pictures) do
    if type(fencetable) == "table" then
        if (string.find(fencename,".*side.*") ~= nil) then 
            for sidename,sidetable in pairs(fencetable) do 
                if (string.find(sidename,".*fence.*") ~= nil) then
                    for fenname,fentable in pairs(sidetable) do 
                        if type(fentable) == "table" then
                            fentable.filename='__pixeltorio_base_ent__/graphics/tileset/bigdummy.png'
                            fentable.x=0
                            fentable.y=0
                        end
                    end
                end
                if (string.find(sidename,".*ends.*") ~= nil) then
                    for subname,subtable in pairs(sidetable) do 
                        for fenname,fentable in pairs(subtable) do 
                            if type(fentable) == "table" then
                                fentable.filename='__pixeltorio_base_ent__/graphics/tileset/bigdummy.png'
                                fentable.x=0
                                fentable.y=0
                            end
                        end
                    end
                end
            end
        end
    end
end



for i,deconame in pairs(data.raw["optimized-decorative"]) do
    deconame.stateless_visualisation=nil
    deconame.stateless_visualisation_variations=nil
    for j,decopic in ipairs(deconame.pictures) do
        decopic.filename="__pixeltorio_base_ent__/graphics/tileset/bigdummy.png"
        decopic.position={0,0}
        decopic.x=0
        decopic.y=0
    end
end



data.raw["tile"]["space-platform-foundation"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "⊞" .. ".png"
        }
    },
    material_texture_width_in_tiles=1,
    material_texture_height_in_tiles=1,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "⊞" .. ".png"
    }
}
data.raw["tile"]["space-platform-foundation"].tint={r=0.3,g=0.3,b=0.3}
data.raw["tile"]["space-platform-foundation"].effect=nil





