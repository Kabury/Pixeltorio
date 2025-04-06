local resolution = 32

function removeFirst(tbl,val)
    for i,v in ipairs(tbl) do
        if v == val then
            return table.remove(tbl,i)
        end
    end
end

function deep_tint (tabl, tint)  --thx darkfrei
    for i,  v in pairs (tabl) do
        if type (v) == "table" then
            deep_tint (v, tint)
        end
    end
    if tabl.picture then
        tabl.tint = tint
    end
end

function helper(arg)
    local chars,ftint,x,y,btint,b,offx,offy,var,dir,fram,cwidth,cheight,cres = arg.chars,arg.ftint,arg.x,arg.y,arg.btint,arg.b,arg.offx,arg.offy,arg.var,arg.dir,arg.fram,arg.cwidth,arg.cheight,arg.cres
    if chars == nil then chars = "a," end
    if b == nil then b = "background" end
    if x == nil then x = 3 end
    if y == nil then y = 3 end
    if ftint == nil then ftint = {{r=0.5,g=0.5,b=0.5}} end
    if btint == nil then btint = {{r=0,g=0,b=0}} end
    if offx == nil then offx = 0 end
    if offy == nil then offy = 0 end
    if var == nil then var = 1 end
    if dir == nil then dir = 1 end
    if fram == nil then fram = 1 end
    if cwidth == nil then cwidth = 1 end
    if cheight == nil then cheight = 1 end
    if cres == nil then cres = resolution end
    allen = x*y
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
    layerstable = {}
    local i = 1
    for char in string.gmatch(chars,'([^,]+)') do
        xcord=(i-1)%x - 1 + offx
        ycord=math.floor((i-1)/x) - 1 + offy
        if x%2 == 0 then xcord = xcord + 0.5 end
        if y%2 == 0 then ycord = ycord + 0.5 end
        if x == 1 then xcord = xcord + 1 end
        if y == 1 then ycord = ycord + 1 end
        if x == 4 then xcord = xcord - 1 end
        if y == 4 then ycord = ycord - 1 end
        if x == 5 then xcord = xcord - 1 end
        if y == 5 then ycord = ycord - 1 end
        if x == 9 then xcord = xcord - 3 end
        if y == 9 then ycord = ycord - 3 end
        if x == 11 then xcord = xcord - 4 end
        if y == 11 then ycord = ycord - 4 end
        if char == " " then char = "≞" end
        if b == " " then b = "≞" end
        layerstable[i*2-1] =   {filename = "__pixeltorio_base_ent__/graphics/tileset/" .. b .. ".png",width=resolution*cwidth,height=resolution*cheight,scale=32/cres,tint=btint[i],shift={xcord,ycord},variation_count=var,direction_count=dir,frame_count=fram,priority="extra-high-no-scale",animation_speed=1/180}
        layerstable[i*2] = {filename = "__pixeltorio_base_ent__/graphics/tileset/" .. char .. ".png",width=resolution*cwidth,height=resolution*cheight,scale=32/cres,tint=ftint[i],shift={xcord,ycord},variation_count=var,direction_count=dir,frame_count=fram,priority="extra-high-no-scale",animation_speed=1/180}
        i=i+1
    end
    return layerstable
end

data.raw["character"]["character"].animations={
    {
        idle_with_gun={
            layers=helper{chars="@,⦯",x=1,y=2,ftint={{r=1,g=1,b=1}},btint={{r=0,g=0,b=0,a=0}},offy=-1}
        },
        mining_with_tool={
            layers=helper{chars="@,⦯",x=1,y=2,ftint={{r=1,g=1,b=1}},btint={{r=0,g=0,b=0,a=0}},offy=-1}
        },
        running_with_gun={
            filename="__pixeltorio_base_ent__/graphics/tileset/character.png",width=resolution*1,height=resolution*2,scale=32/resolution,line_length=18,frame_count=1,shift={0,-1},direction_count=18
        }
    }
}

data.raw["accumulator"]["accumulator"].chargable_graphics={
    picture={layers=helper{chars="⚡,%,%,%",x=2,y=2}},
    charge_animation={layers=helper{chars="⚡,%,%,%",x=2,y=2,ftint={{r=1,g=1,b=0.5}}}},
    discharge_animation={layers=helper{chars="⚡,%,%,%",x=2,y=2,ftint={{r=1,g=0.5,b=0.5}}}}
}
data.raw["corpse"]["accumulator-remnants"].animation={layers=helper{chars="%,∅,∅,∅",x=2,y=2,ftint={{r=1,g=0.3,b=0.5}}}}


data.raw["assembling-machine"]["assembling-machine-1"].graphics_set={
    animation={layers=helper{chars="⚙,a,a,a,a,a,a,a,1",ftint={{r=1,g=0.5,b=0.5}}}},
    idle_animation={layers=helper{chars="⚙,a,a,a,a,a,a,a,1"}},
}
data.raw["corpse"]["assembling-machine-1-remnants"].animation={layers=helper{chars="⚙,∅,∅,∅,∅,∅,∅,∅,1",ftint={{r=1,g=0.3,b=0.5}}}}

data.raw["assembling-machine"]["assembling-machine-2"].graphics_set={
    animation={layers=helper{chars="⚙,a,a,a,a,a,a,a,2",ftint={{r=0.5,g=0.5,b=1}}}},
    idle_animation={layers=helper{chars="⚙,a,a,a,a,a,a,a,2"}},
}
data.raw["assembling-machine"]["assembling-machine-2"].fluid_boxes[1].pipe_covers={
    north={layers=helper{chars="⊤",x=1,y=1,offy=1}},
    south={layers=helper{chars="⊥",x=1,y=1,offy=-1}},
    east={layers=helper{chars="⊣",x=1,y=1,offx=-1}},
    west={layers=helper{chars="⊢",x=1,y=1,offx=1}}
}
data.raw["assembling-machine"]["assembling-machine-2"].fluid_boxes[1].pipe_picture=data.raw["assembling-machine"]["assembling-machine-2"].fluid_boxes[1].pipe_covers
data.raw["assembling-machine"]["assembling-machine-2"].fluid_boxes[1].render_layer="higher-object-above"
data.raw["assembling-machine"]["assembling-machine-2"].fluid_boxes[2].pipe_covers={
    north={layers=helper{chars="⊤",x=1,y=1,offy=1}},
    south={layers=helper{chars="⊥",x=1,y=1,offy=-1}},
    east={layers=helper{chars="⊣",x=1,y=1,offx=-1}},
    west={layers=helper{chars="⊢",x=1,y=1,offx=1}}
}
data.raw["assembling-machine"]["assembling-machine-2"].fluid_boxes[2].pipe_picture=data.raw["assembling-machine"]["assembling-machine-2"].fluid_boxes[1].pipe_covers
data.raw["assembling-machine"]["assembling-machine-2"].fluid_boxes[2].render_layer="higher-object-above"
data.raw["corpse"]["assembling-machine-2-remnants"].animation={layers=helper{chars="⚙,∅,∅,∅,∅,∅,∅,∅,2",ftint={{r=1,g=0.3,b=0.5}}}}


data.raw["assembling-machine"]["assembling-machine-3"].graphics_set={
    animation={layers=helper{chars="⚙,a,a,a,a,a,a,a,3",ftint={{r=1,g=1,b=0.5}}}},
    idle_animation={layers=helper{chars="⚙,a,a,a,a,a,a,a,3"}},
}
data.raw["assembling-machine"]["assembling-machine-3"].fluid_boxes[1].pipe_covers={
    north={layers=helper{chars="⊤",x=1,y=1,offy=1}},
    south={layers=helper{chars="⊥",x=1,y=1,offy=-1}},
    east={layers=helper{chars="⊣",x=1,y=1,offx=-1}},
    west={layers=helper{chars="⊢",x=1,y=1,offx=1}}
}
data.raw["assembling-machine"]["assembling-machine-3"].fluid_boxes[1].pipe_picture=data.raw["assembling-machine"]["assembling-machine-2"].fluid_boxes[1].pipe_covers
data.raw["assembling-machine"]["assembling-machine-3"].fluid_boxes[1].render_layer="higher-object-above"
data.raw["assembling-machine"]["assembling-machine-3"].fluid_boxes[2].pipe_covers={
    north={layers=helper{chars="⊤",x=1,y=1,offy=1}},
    south={layers=helper{chars="⊥",x=1,y=1,offy=-1}},
    east={layers=helper{chars="⊣",x=1,y=1,offx=-1}},
    west={layers=helper{chars="⊢",x=1,y=1,offx=1}}
}
data.raw["assembling-machine"]["assembling-machine-3"].fluid_boxes[2].pipe_picture=data.raw["assembling-machine"]["assembling-machine-2"].fluid_boxes[1].pipe_covers
data.raw["assembling-machine"]["assembling-machine-3"].fluid_boxes[2].render_layer="higher-object-above"
data.raw["corpse"]["assembling-machine-3-remnants"].animation={layers=helper{chars="⚙,∅,∅,∅,∅,∅,∅,∅,3",ftint={{r=1,g=0.3,b=0.5}}}}

data.raw["assembling-machine"]["centrifuge"].graphics_set={
    animation={layers=helper{chars="⚙,c,c,c,⮔,c,c,c,c",ftint={{r=0.5,g=1,b=0.5}}}},
    idle_animation={layers=helper{chars="⚙,c,c,c,⮔,c,c,c,c"}},
}
data.raw["corpse"]["centrifuge-remnants"].animation={layers=helper{chars="⚙,∅,∅,∅,⮔,∅,∅,∅,∅",ftint={{r=1,g=0.3,b=0.5}}}}

data.raw["assembling-machine"]["chemical-plant"].graphics_set={
    animation={
        north={
            layers=helper{chars="⊤,c,⊤,c,⌬,c,⊤,c,⊤",ftint={{r=1,g=1,b=0.5}}}
        },
        south={
            layers=helper{chars="⊥,c,⊥,c,⌬,c,⊥,c,⊥",ftint={{r=1,g=1,b=0.5}}}
        },
        east={
            layers=helper{chars="⊣,c,⊣,c,⌬,c,⊣,c,⊣",ftint={{r=1,g=1,b=0.5}}}
        },
        west={
            layers=helper{chars="⊢,c,⊢,c,⌬,c,⊢,c,⊢",ftint={{r=1,g=1,b=0.5}}}
        }
    },
    idle_animation={
        north={
            layers=helper{chars="⊤,c,⊤,c,⌬,c,⊤,c,⊤"}
        },
        south={
            layers=helper{chars="⊥,c,⊥,c,⌬,c,⊥,c,⊥"}
        },
        east={
            layers=helper{chars="⊣,c,⊣,c,⌬,c,⊣,c,⊣"}
        },
        west={
            layers=helper{chars="⊢,c,⊢,c,⌬,c,⊢,c,⊢"}
        }
    },
}
data.raw["corpse"]["chemical-plant-remnants"].animation={layers=helper{chars="∅,∅,∅,∅,⌬,∅,∅,∅,∅",ftint={{r=1,g=0.3,b=0.5}}}}

for name,table in pairs(data.raw["assembling-machine"]["chemical-plant"].fluid_boxes) do
    table.pipe_covers=nil
    table.pipe_picture=nil
end



data.raw["assembling-machine"]["oil-refinery"].graphics_set={
    animation={
        north={
            layers=helper{chars="⊥,r,⊥,r,⊥,r,r,r,r,r,r,r,⚗,r,r,r,r,🔥,r,r,r,⊥,r,⊥,r",x=5,y=5,ftint={{r=1,g=1,b=0.5}}}
        },
        south={
            layers=helper{chars="r,⊤,r,⊤,r,r,r,r,r,r,r,r,⚗,r,r,r,r,🔥,r,r,⊤,r,⊤,r,⊤",x=5,y=5,ftint={{r=1,g=1,b=0.5}}}
        },
        east={
            layers=helper{chars="r,r,r,r,⊢,⊢,r,r,r,r,r,r,⚗,r,⊢,⊢,r,🔥,r,r,r,r,r,r,⊢",x=5,y=5,ftint={{r=1,g=1,b=0.5}}}
        },
        west={
            layers=helper{chars="⊣,r,r,r,r,r,r,r,r,⊣,⊣,r,⚗,r,r,r,r,🔥,r,⊣,⊣,r,r,r,r",x=5,y=5,ftint={{r=1,g=1,b=0.5}}}
        }
    },
    idle_animation={
        north={
            layers=helper{chars="⊥,r,⊥,r,⊥,r,r,r,r,r,r,r,⚗,r,r,r,r,r,r,r,r,⊤,r,⊤,r",x=5,y=5}
        },
        south={
            layers=helper{chars="r,⊥,r,⊥,r,r,r,r,r,r,r,r,⚗,r,r,r,r,r,r,r,⊤,r,⊤,r,⊤",x=5,y=5}
        },
        east={
            layers=helper{chars="r,r,r,r,⊢,⊣,r,r,r,r,r,r,⚗,r,⊢,⊣,r,r,r,r,r,r,r,r,⊢",x=5,y=5}
        },
        west={
            layers=helper{chars="⊣,r,r,r,r,r,r,r,r,⊢,⊣,r,⚗,r,r,r,r,r,r,⊢,⊣,r,r,r,r",x=5,y=5}
        }
    },
}
data.raw["corpse"]["oil-refinery-remnants"].animation={layers=helper{chars="∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,⚗,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅",x=5,y=5,ftint={{r=1,g=0.3,b=0.5}}}}


for name,table in pairs(data.raw["assembling-machine"]["oil-refinery"].fluid_boxes) do
    table.pipe_covers=nil
    table.pipe_picture=nil
end



data.raw["lab"]["lab"].on_animation={
    layers=helper{chars="l,l,l,l,ᛟ,l,l,l,l",ftint={{r=1,g=1,b=1}}}
}

data.raw["lab"]["lab"]. off_animation={
    layers=helper{chars="l,l,l,l,ᛟ,l,l,l,l"}
}
data.raw["corpse"]["lab-remnants"].animation={layers=helper{chars="∅,∅,∅,∅,ᛟ,∅,∅,∅,∅",ftint={{r=1,g=0.3,b=0.5}}}}


data.raw["beacon"]["beacon"].graphics_set={
    animation_list={
        {animation={layers=helper{chars="b,Ɨ,b,b,Ɨ,b,b,b,b"}}}
    }
}
data.raw["corpse"]["beacon-remnants"].animation={layers=helper{chars="∅,∅,∅,∅,Ɨ,∅,∅,b,∅",ftint={{r=1,g=0.3,b=0.5}}}}

data.raw["furnace"]["stone-furnace"].graphics_set={
    animation={layers=helper{chars="♨,f,f,s",x=2,y=2,ftint={{r=1,g=1,b=0.5}}}},
    idle_animation={layers=helper{chars="♨,f,f,s",x=2,y=2}},
}
data.raw["corpse"]["stone-furnace-remnants"].animation={layers=helper{chars="♨,∅,s,∅",x=2,y=2,ftint={{r=1,g=0.3,b=0.5}}}}

data.raw["furnace"]["steel-furnace"].graphics_set={
    animation={layers=helper{chars="♨,f,f,ß",x=2,y=2,ftint={{r=0.5,g=1,b=0.5}}}},
    idle_animation={layers=helper{chars="♨,f,f,ß",x=2,y=2}},
}
data.raw["corpse"]["steel-furnace-remnants"].animation={layers=helper{chars="♨,∅,ß,∅",x=2,y=2,ftint={{r=1,g=0.3,b=0.5}}}}

data.raw["furnace"]["electric-furnace"].graphics_set={
    animation={layers=helper{chars="♨,f,f,f,f,f,f,f,e",ftint={{r=0.5,g=0.5,b=1}}}},
    idle_animation={layers=helper{chars="♨,f,f,f,f,f,f,f,e"}},
}
data.raw["corpse"]["electric-furnace-remnants"].animation={layers=helper{chars="∅,∅,∅,∅,♨,∅,∅,e,∅",ftint={{r=1,g=0.3,b=0.5}}}}

data.raw["reactor"]["nuclear-reactor"].picture={
    layers=helper{chars="🌡,n,🌡,n,🌡,n,⚡,n,n,n,🌡,n,☄,n,🌡,n,n,n,n,n,🌡,n,🌡,n,🌡",x=5,y=5}
}

data.raw["reactor"]["nuclear-reactor"].working_light_picture={
    layers=helper{chars="🌡,n,🌡,n,🌡,n,⚡,n,n,n,🌡,n,☄,n,🌡,n,n,n,n,n,🌡,n,🌡,n,🌡",x=5,y=5,ftint={{r=0.5,g=1,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}
}
data.raw["corpse"]["nuclear-reactor-remnants"].animation={layers=helper{chars="∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,☄,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅",x=5,y=5,ftint={{r=1,g=0.3,b=0.5}}}}


--data.raw["reactor"]["nuclear-reactor"].light=nil
data.raw["reactor"]["nuclear-reactor"].connection_patches_connected=nil
data.raw["reactor"]["nuclear-reactor"].connection_patches_disconnected=nil
data.raw["reactor"]["nuclear-reactor"].lower_layer_picture=nil
data.raw["reactor"]["nuclear-reactor"].heat_connection_patches_connected=nil
data.raw["reactor"]["nuclear-reactor"].heat_connection_patches_disconnected=nil
data.raw["reactor"]["nuclear-reactor"].heat_lower_layer_picture=nil
data.raw["reactor"]["nuclear-reactor"].heat_buffer.heat_picture=nil



data.raw["generator"]["steam-engine"].vertical_animation={
    layers=helper{chars="⚡,⊥,e,e,e,e,e,❋,e,e,e,e,e,⊤,e",x=3,y=5,ftint={{r=0.7,g=1,b=0.5}}}
}

data.raw["generator"]["steam-engine"].horizontal_animation={
    layers=helper{chars="⚡,e,e,e,e,⊣,e,❋,e,⊢,e,e,e,e,e",x=5,y=3,ftint={{r=0.7,g=1,b=0.5}}}
}
data.raw["generator"]["steam-engine"].fluid_box.pipe_covers=nil
data.raw["generator"]["steam-engine"].fluid_box.pipe_picture=nil
data.raw["corpse"]["steam-engine-remnants"].animation={layers=helper{chars="∅,∅,∅,∅,❋,∅,∅,∅,∅",ftint={{r=1,g=0.3,b=0.5}}}} --should fix this later

data.raw["generator"]["steam-turbine"].horizontal_animation={
    layers=helper{chars="⚡,t,t,,t,t,⊣,t,❊,t,⊢,t,t,t,t,t",x=5,y=3,ftint={{r=1,g=0.7,b=0.5}}}
}

data.raw["generator"]["steam-turbine"].vertical_animation={
    layers=helper{chars="⚡,⊥,t,t,t,t,t,❊,t,t,t,t,t,⊤,t",x=3,y=5,ftint={{r=1,g=0.7,b=0.5}}}
}

data.raw["generator"]["steam-turbine"].fluid_box.pipe_covers=nil
data.raw["generator"]["steam-turbine"].fluid_box.pipe_picture=nil
data.raw["corpse"]["steam-turbine-remnants"].animation={layers=helper{chars="∅,∅,∅,∅,❊,∅,∅,∅,∅",ftint={{r=1,g=0.3,b=0.5}}}} --should fix this later

data.raw["solar-panel"]["solar-panel"].picture={
    layers=helper{chars="⚡,s,s,s,☀,s,s,s,s",ftint={{r=1,g=1,b=1}}}
}
data.raw["corpse"]["solar-panel-remnants"].animation={layers=helper{chars="∅,∅,∅,∅,☀,∅,∅,∅,∅",ftint={{r=1,g=0.3,b=0.5}}}}


data.raw["resource"]["coal"].stages.sheet={filename="__pixeltorio_base_ent__/graphics/tileset/resource.png",width=resolution,height=resolution,scale=32/resolution,variation_count=3,tint={r=0.5,g=0.5,b=0.5}}
data.raw["resource"]["coal"].stage_counts={3000,1000,500}
data.raw["resource"]["coal"].randomize_visual_position=false

data.raw["resource"]["copper-ore"].stages.sheet={filename="__pixeltorio_base_ent__/graphics/tileset/resource.png",width=resolution,height=resolution,scale=32/resolution,variation_count=3,tint={r=1,g=0.63,b=0.3}}
data.raw["resource"]["copper-ore"].stage_counts={3000,1000,500}
data.raw["resource"]["copper-ore"].randomize_visual_position=false

data.raw["resource"]["iron-ore"].stages.sheet={filename="__pixeltorio_base_ent__/graphics/tileset/resource.png",width=resolution,height=resolution,scale=32/resolution,variation_count=3,tint={r=0.5,g=0.63,b=1}}
data.raw["resource"]["iron-ore"].stage_counts={3000,1000,500}
data.raw["resource"]["iron-ore"].randomize_visual_position=false

data.raw["resource"]["stone"].stages.sheet={filename="__pixeltorio_base_ent__/graphics/tileset/resource.png",width=resolution,height=resolution,scale=32/resolution,variation_count=3,tint={r=0.87,g=0.87,b=0.63}}
data.raw["resource"]["stone"].stage_counts={3000,1000,500}
data.raw["resource"]["stone"].randomize_visual_position=false

data.raw["resource"]["uranium-ore"].stages.sheet={filename="__pixeltorio_base_ent__/graphics/tileset/resource.png",width=resolution,height=resolution,scale=32/resolution,variation_count=3,tint={r=0.5,g=1,b=0.5}}
data.raw["resource"]["uranium-ore"].stage_counts={3000,1000,500}
data.raw["resource"]["uranium-ore"].randomize_visual_position=false
data.raw["resource"]["uranium-ore"].stages_effect=nil


data.raw["resource"]["crude-oil"].stages.sheet=nil
data.raw["resource"]["crude-oil"].stages.sheets=helper{chars="💧",x=1,y=1,ftint={{r=1,g=0.3,b=1}},btint={{r=0,g=0,b=0,a=0}}}
data.raw["resource"]["crude-oil"].randomize_visual_position=false
data.raw["resource"]["crude-oil"].stateless_visualisation=nil


data.raw["unit-spawner"]["biter-spawner"].graphics_set={
    animations={
        sheets=helper{chars="⚠,s,s,s,s,s,b,b,b,s,s,b,b,b,s,s,b,b,b,s,s,s,s,s,🐜",x=5,y=5,ftint={{r=1,g=0.5,b=0.5}}}
    }
}
data.raw["corpse"]["biter-spawner-corpse"].animation={layers=helper{chars="☠,☠,☠,☠,☠,☠,ƀ,ƀ,ƀ,☠,☠,ƀ,👑,ƀ,☠,☠,ƀ,ƀ,ƀ,☠,☠,☠,☠,☠,☠",x=5,y=5,ftint={{r=1,g=0.3,b=0.5}}}}
data.raw["corpse"]["biter-spawner-corpse"].decay_animation=nil

data.raw["unit"]["small-biter"].run_animation={
    layers=helper{chars="b",x=1,y=1,ftint={{r=1,g=1,b=1}},btint={{r=0,g=0,b=0,a=0}}}
}
data.raw["unit"]["small-biter"].attack_parameters.animation={
    layers=helper{chars="b",x=1,y=1,ftint={{r=1,g=0.5,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}
}
data.raw["corpse"]["small-biter-corpse"].animation={layers=helper{chars="ƀ",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["corpse"]["small-biter-corpse"].decay_animation=nil
data.raw["corpse"]["small-biter-corpse"].direction_shuffle=nil



data.raw["unit"]["medium-biter"].run_animation={
    layers=helper{chars="b,b",x=2,y=1,ftint={{r=1,g=0.75,b=0.75}},btint={{r=0,g=0,b=0,a=0}}}
}
data.raw["unit"]["medium-biter"].attack_parameters.animation={
    layers=helper{chars="b,b",x=2,y=1,ftint={{r=1,g=0.25,b=0.25}},btint={{r=0,g=0,b=0,a=0}}}
}
data.raw["corpse"]["medium-biter-corpse"].animation={layers=helper{chars="ƀ,ƀ",x=2,y=1,ftint={{r=1,g=0.3,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["corpse"]["medium-biter-corpse"].decay_animation=nil
data.raw["corpse"]["medium-biter-corpse"].direction_shuffle=nil



data.raw["unit"]["big-biter"].run_animation={
    layers=helper{chars="B,B",x=2,y=1,ftint={{r=1,g=1,b=1}},btint={{r=0,g=0,b=0,a=0}}}
}
data.raw["unit"]["big-biter"].attack_parameters.animation={
    layers=helper{chars="B,B",x=2,y=1,ftint={{r=1,g=0.5,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}
}
data.raw["corpse"]["big-biter-corpse"].animation={layers=helper{chars="Ƀ,Ƀ",x=2,y=1,ftint={{r=1,g=0.3,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["corpse"]["big-biter-corpse"].decay_animation=nil
data.raw["corpse"]["big-biter-corpse"].direction_shuffle=nil



data.raw["unit"]["behemoth-biter"].run_animation={
    layers=helper{chars="B,B,B,B",x=2,y=2,ftint={{r=1,g=0.75,b=0.75}},btint={{r=0,g=0,b=0,a=0}}}
}
data.raw["unit"]["behemoth-biter"].attack_parameters.animation={
    layers=helper{chars="B,B,B,B",x=2,y=2,ftint={{r=1,g=0.25,b=0.25}},btint={{r=0,g=0,b=0,a=0}}}
}
data.raw["corpse"]["behemoth-biter-corpse"].animation={layers=helper{chars="Ƀ,Ƀ,Ƀ,Ƀ",x=2,y=2,ftint={{r=1,g=0.3,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["corpse"]["behemoth-biter-corpse"].decay_animation=nil
data.raw["corpse"]["behemoth-biter-corpse"].direction_shuffle=nil



data.raw["unit"]["small-spitter"].run_animation={
    layers=helper{chars="s",x=1,y=1,ftint={{r=1,g=1,b=1}},btint={{r=0,g=0,b=0,a=0}}}
}
data.raw["unit"]["small-spitter"].attack_parameters.animation={
    layers=helper{chars="s",x=1,y=1,ftint={{r=1,g=0.5,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}
}
data.raw["unit"]["small-spitter"].alternative_attacking_frame_sequence=nil
data.raw["corpse"]["small-spitter-corpse"].animation={layers=helper{chars="ꞩ",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["corpse"]["small-spitter-corpse"].decay_animation=nil
data.raw["corpse"]["small-spitter-corpse"].direction_shuffle=nil



data.raw["unit"]["medium-spitter"].run_animation={
    layers=helper{chars="s,s",x=2,y=1,ftint={{r=1,g=0.75,b=0.75}},btint={{r=0,g=0,b=0,a=0}}}
}
data.raw["unit"]["medium-spitter"].attack_parameters.animation={
    layers=helper{chars="s,s",x=2,y=1,ftint={{r=1,g=0.25,b=0.25}},btint={{r=0,g=0,b=0,a=0}}}
}
data.raw["unit"]["medium-spitter"].alternative_attacking_frame_sequence=nil
data.raw["corpse"]["medium-spitter-corpse"].animation={layers=helper{chars="ꞩ,ꞩ",x=2,y=1,ftint={{r=1,g=0.3,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["corpse"]["medium-spitter-corpse"].decay_animation=nil
data.raw["corpse"]["medium-spitter-corpse"].direction_shuffle=nil



data.raw["unit"]["big-spitter"].run_animation={
    layers=helper{chars="S,S,S",x=3,y=1,ftint={{r=1,g=1,b=1}},btint={{r=0,g=0,b=0,a=0}}}
}
data.raw["unit"]["big-spitter"].attack_parameters.animation={
    layers=helper{chars="S,S,S",x=3,y=1,ftint={{r=1,g=0.5,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}
}
data.raw["unit"]["big-spitter"].alternative_attacking_frame_sequence=nil
data.raw["corpse"]["big-spitter-corpse"].animation={layers=helper{chars="Ꞩ,Ꞩ,Ꞩ",x=3,y=1,ftint={{r=1,g=0.3,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["corpse"]["big-spitter-corpse"].decay_animation=nil
data.raw["corpse"]["big-spitter-corpse"].direction_shuffle=nil



data.raw["unit"]["behemoth-spitter"].run_animation={
    layers=helper{chars="S,S,S,S",x=4,y=1,ftint={{r=1,g=0.75,b=0.75}},btint={{r=0,g=0,b=0,a=0}}}
}
data.raw["unit"]["behemoth-spitter"].attack_parameters.animation={
    layers=helper{chars="S,S,S,S",x=4,y=1,ftint={{r=1,g=0.25,b=0.25}},btint={{r=0,g=0,b=0,a=0}}}
}
data.raw["unit"]["behemoth-spitter"].alternative_attacking_frame_sequence=nil
data.raw["corpse"]["behemoth-spitter-corpse"].animation={layers=helper{chars="Ꞩ,Ꞩ,Ꞩ,Ꞩ",x=4,y=1,ftint={{r=1,g=0.3,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["corpse"]["behemoth-spitter-corpse"].decay_animation=nil
data.raw["corpse"]["behemoth-spitter-corpse"].direction_shuffle=nil



data.raw["unit-spawner"]["spitter-spawner"].graphics_set={
    animations={
        sheets=helper{chars="⚠,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,🐜",x=5,y=5,ftint={{r=1,g=0.75,b=0.5}}}
    }
}
data.raw["corpse"]["spitter-spawner-corpse"].animation={layers=helper{chars="☠,☠,☠,☠,☠,☠,ꞩ,ꞩ,ꞩ,☠,☠,ꞩ,👑,ꞩ,☠,☠,ꞩ,ꞩ,ꞩ,☠,☠,☠,☠,☠,☠",x=5,y=5,ftint={{r=1,g=0.3,b=0.5}}}}
data.raw["corpse"]["spitter-spawner-corpse"].decay_animation=nil



data.raw["turret"]["small-worm-turret"].graphics_set.base_visualisation={
    animation={layers=helper{chars="🐛,w,w,1",x=2,y=2,ftint={{r=0.5,g=0.5,b=1}}}}
}
data.raw["turret"]["small-worm-turret"].folded_animation={layers=helper{chars="🐛,w,w,1",x=2,y=2,ftint={{r=0.5,g=0.5,b=1}}}}
data.raw["turret"]["small-worm-turret"].preparing_animation=nil
data.raw["turret"]["small-worm-turret"].prepared_animation=nil
data.raw["turret"]["small-worm-turret"].prepared_alternative_animation=nil
data.raw["turret"]["small-worm-turret"].starting_attack_animation=nil
data.raw["turret"]["small-worm-turret"].attacking_animation=nil
data.raw["turret"]["small-worm-turret"].ending_attack_animation=nil
data.raw["turret"]["small-worm-turret"].folding_animation=nil
data.raw["turret"]["small-worm-turret"].integration=nil
--removeFirst(data.raw["turret"]["small-worm-turret"].flags,"placeable-off-grid")
data.raw["corpse"]["small-worm-corpse"].animation={layers=helper{chars="🐛,☠,☠,☠",x=2,y=2,ftint={{r=1,g=0.3,b=0.5}}}}
data.raw["corpse"]["small-worm-corpse"].decay_animation=nil
data.raw["corpse"]["small-worm-corpse-burrowed"].animation={layers=helper{chars="🐛,☠,☠,☠",x=2,y=2,ftint={{r=1,g=0.3,b=0.5}}}}
data.raw["corpse"]["small-worm-corpse-burrowed"].decay_animation=nil
data.raw["corpse"]["small-worm-corpse"].ground_patch=nil
data.raw["corpse"]["small-worm-corpse"].ground_patch_decay=nil
data.raw["corpse"]["small-worm-corpse-burrowed"].ground_patch=nil
data.raw["corpse"]["small-worm-corpse-burrowed"].ground_patch_decay=nil


data.raw["turret"]["medium-worm-turret"].graphics_set.base_visualisation={
    animation={layers=helper{chars="🐛,w,w,w,w,2",x=3,y=2,ftint={{r=0.5,g=0.5,b=1}}}}
}
data.raw["turret"]["medium-worm-turret"].folded_animation={layers=helper{chars="🐛,w,w,w,w,2",x=3,y=2,ftint={{r=0.5,g=0.5,b=1}}}}
data.raw["turret"]["medium-worm-turret"].preparing_animation=nil
data.raw["turret"]["medium-worm-turret"].prepared_animation=nil
data.raw["turret"]["medium-worm-turret"].prepared_alternative_animation=nil
data.raw["turret"]["medium-worm-turret"].starting_attack_animation=nil
data.raw["turret"]["medium-worm-turret"].attacking_animation=nil
data.raw["turret"]["medium-worm-turret"].ending_attack_animation=nil
data.raw["turret"]["medium-worm-turret"].folding_animation=nil
data.raw["turret"]["medium-worm-turret"].integration=nil
--removeFirst(data.raw["turret"]["medium-worm-turret"].flags,"placeable-off-grid")
data.raw["corpse"]["medium-worm-corpse"].animation={layers=helper{chars="🐛,☠,☠,☠,☠,☠",x=3,y=2,ftint={{r=1,g=0.3,b=0.5}}}}
data.raw["corpse"]["medium-worm-corpse"].decay_animation=nil
data.raw["corpse"]["medium-worm-corpse-burrowed"].animation={layers=helper{chars="🐛,☠,☠,☠,☠,☠",x=3,y=2,ftint={{r=1,g=0.3,b=0.5}}}}
data.raw["corpse"]["medium-worm-corpse-burrowed"].decay_animation=nil
data.raw["corpse"]["medium-worm-corpse"].ground_patch=nil
data.raw["corpse"]["medium-worm-corpse"].ground_patch_decay=nil
data.raw["corpse"]["medium-worm-corpse-burrowed"].ground_patch=nil
data.raw["corpse"]["medium-worm-corpse-burrowed"].ground_patch_decay=nil


data.raw["turret"]["big-worm-turret"].graphics_set.base_visualisation={
    animation={layers=helper{chars="🐛,W,W,W,W,W,W,W,3",ftint={{r=0.5,g=0.5,b=1}}}}
}
data.raw["turret"]["big-worm-turret"].folded_animation={layers=helper{chars="🐛,W,W,W,W,W,W,W,3",ftint={{r=0.5,g=0.5,b=1}}}}
data.raw["turret"]["big-worm-turret"].preparing_animation=nil
data.raw["turret"]["big-worm-turret"].prepared_animation=nil
data.raw["turret"]["big-worm-turret"].prepared_alternative_animation=nil
data.raw["turret"]["big-worm-turret"].starting_attack_animation=nil
data.raw["turret"]["big-worm-turret"].attacking_animation=nil
data.raw["turret"]["big-worm-turret"].ending_attack_animation=nil
data.raw["turret"]["big-worm-turret"].folding_animation=nil
data.raw["turret"]["big-worm-turret"].integration=nil
--removeFirst(data.raw["turret"]["big-worm-turret"].flags,"placeable-off-grid")
data.raw["corpse"]["big-worm-corpse"].animation={layers=helper{chars="🐛,☠,☠,☠,☠,☠,☠,☠,☠",x=3,y=3,ftint={{r=1,g=0.3,b=0.5}}}}
data.raw["corpse"]["big-worm-corpse"].decay_animation=nil
data.raw["corpse"]["big-worm-corpse-burrowed"].animation={layers=helper{chars="🐛,☠,☠,☠,☠,☠,☠,☠,☠",x=3,y=3,ftint={{r=1,g=0.3,b=0.5}}}}
data.raw["corpse"]["big-worm-corpse-burrowed"].decay_animation=nil
data.raw["corpse"]["big-worm-corpse"].ground_patch=nil
data.raw["corpse"]["big-worm-corpse"].ground_patch_decay=nil
data.raw["corpse"]["big-worm-corpse-burrowed"].ground_patch=nil
data.raw["corpse"]["big-worm-corpse-burrowed"].ground_patch_decay=nil



data.raw["turret"]["behemoth-worm-turret"].graphics_set.base_visualisation={
    animation={layers=helper{chars="🐛,W,W,W,W,W,W,W,4",ftint={{r=0.5,g=0.5,b=1}}}}
}
data.raw["turret"]["behemoth-worm-turret"].folded_animation={layers=helper{chars="🐛,W,W,W,W,W,W,W,4",ftint={{r=0.5,g=0.5,b=1}}}}
data.raw["turret"]["behemoth-worm-turret"].preparing_animation=nil
data.raw["turret"]["behemoth-worm-turret"].prepared_animation=nil
data.raw["turret"]["behemoth-worm-turret"].prepared_alternative_animation=nil
data.raw["turret"]["behemoth-worm-turret"].starting_attack_animation=nil
data.raw["turret"]["behemoth-worm-turret"].attacking_animation=nil
data.raw["turret"]["behemoth-worm-turret"].ending_attack_animation=nil
data.raw["turret"]["behemoth-worm-turret"].folding_animation=nil
data.raw["turret"]["behemoth-worm-turret"].integration=nil
--removeFirst(data.raw["turret"]["behemoth-worm-turret"].flags,"placeable-off-grid")
data.raw["corpse"]["behemoth-worm-corpse"].animation={layers=helper{chars="🐛,☠,☠,☠,☠,☠,☠,☠,☠",x=3,y=3,ftint={{r=1,g=0.3,b=0.5}}}}
data.raw["corpse"]["behemoth-worm-corpse"].decay_animation=nil
data.raw["corpse"]["behemoth-worm-corpse-burrowed"].animation={layers=helper{chars="🐛,☠,☠,☠,☠,☠,☠,☠,☠",x=3,y=3,ftint={{r=1,g=0.3,b=0.5}}}}
data.raw["corpse"]["behemoth-worm-corpse-burrowed"].decay_animation=nil
data.raw["corpse"]["behemoth-worm-corpse"].ground_patch=nil
data.raw["corpse"]["behemoth-worm-corpse"].ground_patch_decay=nil
data.raw["corpse"]["behemoth-worm-corpse-burrowed"].ground_patch=nil
data.raw["corpse"]["behemoth-worm-corpse-burrowed"].ground_patch_decay=nil



for i,deconame in pairs(data.raw["optimized-decorative"]) do
    for j,decopic in ipairs(deconame.pictures) do
        decopic.filename="__pixeltorio_base_ent__/graphics/tileset/bigdummy.png"
        decopic.position={0,0}
        decopic.x=0
        decopic.y=0
    end
end

data.raw["electric-pole"]["small-electric-pole"].pictures={layers=helper{chars="∫",x=1,y=1}}
data.raw["electric-pole"]["small-electric-pole"].connection_points={
    {wire={copper={0,0},red={-0.2,-0.2},green={0.2,0.2}},
    shadow={copper={0,0},red={-0.2,-0.2},green={0.2,0.2}}}
}
data.raw["corpse"]["small-electric-pole-remnants"].animation={layers=helper{chars="∫",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}
data.raw["corpse"]["small-electric-pole-remnants"].animation_overlay=nil



data.raw["electric-pole"]["medium-electric-pole"].pictures={layers=helper{chars="⨍",x=1,y=1}}
data.raw["electric-pole"]["medium-electric-pole"].connection_points={
    {wire={copper={0,0},red={-0.2,-0.2},green={0.2,0.2}},
    shadow={copper={0,0},red={-0.2,-0.2},green={0.2,0.2}}}
}
data.raw["corpse"]["medium-electric-pole-remnants"].animation={layers=helper{chars="⨍",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}
data.raw["corpse"]["medium-electric-pole-remnants"].animation_overlay=nil



data.raw["electric-pole"]["big-electric-pole"].pictures={layers=helper{chars="⨕,⨕,⨕,⨕",x=2,y=2}}
data.raw["electric-pole"]["big-electric-pole"].connection_points={
    {wire={copper={-0.5,-0.5},red={-0.7,-0.7},green={-0.3,-0.3}},
    shadow={copper={-0.5,-0.5},red={-0.7,-0.7},green={-0.3,-0.3}}}
}
data.raw["corpse"]["big-electric-pole-remnants"].animation={layers=helper{chars="⨕,∅,∅,∅",x=2,y=2,ftint={{r=1,g=0.3,b=0.5}}}}
data.raw["corpse"]["big-electric-pole-remnants"].animation_overlay=nil



data.raw["electric-pole"]["substation"].pictures={layers=helper{chars="⨎,⨎,⨎,⨎",x=2,y=2}}
data.raw["electric-pole"]["substation"].connection_points={
    {wire={copper={-0.5,-0.5},red={-0.7,-0.7},green={-0.3,-0.3}},
    shadow={copper={-0.5,-0.5},red={-0.7,-0.7},green={-0.3,-0.3}}}
}
data.raw["corpse"]["substation-remnants"].animation={layers=helper{chars="⨎,∅,∅,∅",x=2,y=2,ftint={{r=1,g=0.3,b=0.5}}}}
data.raw["corpse"]["substation-remnants"].animation_overlay=nil



data.raw["container"]["wooden-chest"].picture={layers=helper{chars="☐",x=1,y=1,ftint={{r=0.5,g=0.25,b=0.25}}}}
data.raw["container"]["iron-chest"].picture={layers=helper{chars="☐",x=1,y=1,ftint={{r=0.25,g=0.25,b=0.5}}}}
data.raw["container"]["steel-chest"].picture={layers=helper{chars="☐",x=1,y=1,ftint={{r=0.5,g=0.5,b=0.5}}}}
data.raw["logistic-container"]["active-provider-chest"].picture={layers=helper{chars="☒",x=1,y=1,ftint={{r=1,g=0.5,b=1}}}}
data.raw["logistic-container"]["active-provider-chest"].animation=nil
data.raw["logistic-container"]["passive-provider-chest"].picture={layers=helper{chars="☒",x=1,y=1,ftint={{r=1,g=0.5,b=0.5}}}}
data.raw["logistic-container"]["passive-provider-chest"].animation=nil
data.raw["logistic-container"]["buffer-chest"].picture={layers=helper{chars="☒",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}}
data.raw["logistic-container"]["buffer-chest"].animation=nil
data.raw["logistic-container"]["requester-chest"].picture={layers=helper{chars="☒",x=1,y=1,ftint={{r=0.5,g=0.75,b=1}}}}
data.raw["logistic-container"]["requester-chest"].animation=nil
data.raw["logistic-container"]["storage-chest"].picture={layers=helper{chars="☒",x=1,y=1,ftint={{r=1,g=1,b=0.5}}}}
data.raw["logistic-container"]["storage-chest"].animation=nil

data.raw["corpse"]["wooden-chest-remnants"].animation={layers=helper{chars="☐",x=2,y=2,ftint={{r=1,g=0.3,b=0.5}}}}
data.raw["corpse"]["iron-chest-remnants"].animation={layers=helper{chars="☐",x=2,y=2,ftint={{r=1,g=0.3,b=0.5}}}}
data.raw["corpse"]["steel-chest-remnants"].animation={layers=helper{chars="☐",x=2,y=2,ftint={{r=1,g=0.3,b=0.5}}}}
data.raw["corpse"]["active-provider-chest-remnants"].animation={layers=helper{chars="☒",x=2,y=2,ftint={{r=1,g=0.3,b=0.5}}}}
data.raw["corpse"]["passive-provider-chest-remnants"].animation={layers=helper{chars="☒",x=2,y=2,ftint={{r=1,g=0.3,b=0.5}}}}
data.raw["corpse"]["buffer-chest-remnants"].animation={layers=helper{chars="☒",x=2,y=2,ftint={{r=1,g=0.3,b=0.5}}}}
data.raw["corpse"]["requester-chest-remnants"].animation={layers=helper{chars="☒",x=2,y=2,ftint={{r=1,g=0.3,b=0.5}}}}
data.raw["corpse"]["storage-chest-remnants"].animation={layers=helper{chars="☒",x=2,y=2,ftint={{r=1,g=0.3,b=0.5}}}}



data.raw["mining-drill"]["burner-mining-drill"].graphics_set={
    animation={
        north={
            layers=helper{chars="▴,m,⛏,b",x=2,y=2,ftint={{r=1,g=1,b=0.5}}}
        },
        south={
            layers=helper{chars="⛏,b,m,▾",x=2,y=2,ftint={{r=1,g=1,b=0.5}}}
        },
        east={
            layers=helper{chars="⛏,▸,m,b",x=2,y=2,ftint={{r=1,g=1,b=0.5}}}
        },
        west={
            layers=helper{chars="⛏,m,◂,b",x=2,y=2,ftint={{r=1,g=1,b=0.5}}}
        }
    },
    idle_animation={
        north={
            layers=helper{chars="▴,m,⛏,b",x=2,y=2}
        },
        south={
            layers=helper{chars="⛏,b,m,▾",x=2,y=2}
        },
        east={
            layers=helper{chars="⛏,▸,m,b",x=2,y=2}
        },
        west={
            layers=helper{chars="⛏,m,◂,b",x=2,y=2}
        }
    },
}
data.raw["corpse"]["burner-mining-drill-remnants"].animation={layers=helper{chars="⛏,∅,b,∅",x=2,y=2,ftint={{r=1,g=0.3,b=0.5}}}}

data.raw["mining-drill"]["electric-mining-drill"].graphics_set={
    animation={
        north={
            layers=helper{chars="⛏,▴,m,m,m,m,m,m,e",ftint={{r=0.5,g=0.5,b=1}}}
        },
        south={
            layers=helper{chars="⛏,m,m,m,m,m,m,▾,e",ftint={{r=0.5,g=0.5,b=1}}}
        },
        east={
            layers=helper{chars="⛏,m,m,m,m,▸,m,m,e",ftint={{r=0.5,g=0.5,b=1}}}
        },
        west={
            layers=helper{chars="⛏,m,m,◂,m,m,m,m,e",ftint={{r=0.5,g=0.5,b=1}}}
        }
    },
    idle_animation={
        north={
            layers=helper{chars="⛏,▴,m,m,m,m,m,m,e"}
        },
        south={
            layers=helper{chars="⛏,m,m,m,m,m,m,▾,e"}
        },
        east={
            layers=helper{chars="⛏,m,m,m,m,▸,m,m,e"}
        },
        west={
            layers=helper{chars="⛏,m,m,◂,m,m,m,m,e"}
        }
    },
}
data.raw["mining-drill"]["electric-mining-drill"].wet_mining_graphics_set={
    animation={
        north={
            layers=helper{chars="⛏,▴,m,⊢,m,⊣,m,⊥,e",ftint={{r=0.5,g=0.5,b=1}}}
        },
        south={
            layers=helper{chars="⛏,⊤,m,⊢,m,⊣,m,▾,e",ftint={{r=0.5,g=0.5,b=1}}}
        },
        east={
            layers=helper{chars="⛏,⊤,m,⊢,m,▸,m,⊥,e",ftint={{r=0.5,g=0.5,b=1}}}
        },
        west={
            layers=helper{chars="⛏,⊤,m,◂,m,⊣,m,⊥,e",ftint={{r=0.5,g=0.5,b=1}}}
        }
    },
    idle_animation={
        north={
            layers=helper{chars="⛏,▴,m,⊢,m,⊣,m,⊥,e"}
        },
        south={
            layers=helper{chars="⛏,⊤,m,⊢,m,⊣,m,▾,e"}
        },
        east={
            layers=helper{chars="⛏,⊤,m,⊢,m,▸,m,⊥,e"}
        },
        west={
            layers=helper{chars="⛏,⊤,m,◂,m,⊣,m,⊥,e"}
        }
    },
}
data.raw["corpse"]["electric-mining-drill-remnants"].animation={layers=helper{chars="∅,∅,∅,∅,⛏,∅,∅,e,∅",ftint={{r=1,g=0.3,b=0.5}}}}


--data.raw["mining-drill"]["electric-mining-drill"].output_fluid_box.pipe_covers=nil
--data.raw["mining-drill"]["electric-mining-drill"].output_fluid_box.pipe_picture=nil
data.raw["mining-drill"]["electric-mining-drill"].input_fluid_box.pipe_covers=nil
data.raw["mining-drill"]["electric-mining-drill"].input_fluid_box.pipe_picture=nil



data.raw["mining-drill"]["pumpjack"].graphics_set={
    animation={
        north={
            layers=helper{chars="⛏,p,⊥,p,p,p,p,p,m",ftint={{r=1,g=1,b=0.5}}}
        },
        south={
            layers=helper{chars="⛏,p,p,p,p,p,⊤,p,m",ftint={{r=1,g=1,b=0.5}}}
        },
        east={
            layers=helper{chars="⛏,p,⊢,p,p,p,p,p,m",ftint={{r=1,g=1,b=0.5}}}
        },
        west={
            layers=helper{chars="⛏,p,p,p,p,p,⊣,p,m",ftint={{r=1,g=1,b=0.5}}}
        }
    },
    idle_animation={
        north={
            layers=helper{chars="⛏,p,⊥,p,p,p,p,p,m"}
        },
        south={
            layers=helper{chars="⛏,p,p,p,p,p,⊤,p,m"}
        },
        east={
            layers=helper{chars="⛏,p,⊢,p,p,p,p,p,m"}
        },
        west={
            layers=helper{chars="⛏,p,p,p,p,p,⊣,p,m"}
        }
    },
}
data.raw["mining-drill"]["pumpjack"].base_picture=nil
data.raw["mining-drill"]["pumpjack"].output_fluid_box.pipe_covers=nil
data.raw["mining-drill"]["pumpjack"].output_fluid_box.pipe_picture=nil
--data.raw["mining-drill"]["pumpjack"].input_fluid_box.pipe_covers=nil
--data.raw["mining-drill"]["pumpjack"].input_fluid_box.pipe_picture=nil
data.raw["corpse"]["pumpjack-remnants"].animation={layers=helper{chars="∅,∅,∅,∅,⛏,∅,∅,p,∅",ftint={{r=1,g=0.3,b=0.5}}}}


data.raw["rocket-silo"]["rocket-silo"].base_day_sprite={
layers=helper{chars="r,r,r,╱,─,╲,r,r,r,r,r,┌,⡪,⡪,⡪,┐,r,r,r,┌,⡪,⡪,⡪,⡪,⡪,┐,r,╱,⡪,⡪,⡪,⡪,⡪,⡪,⡪,╲,│,⡪,⡪,⡪,⡪,⡪,⡪,⡪,│,╲,⡪,⡪,⡪,⡪,⡪,⡪,⡪,╱,r,└,⡪,⡪,⡪,⡪,⡪,┘,r,r,r,└,⡪,⡪,⡪,┘,r,r,r,r,r,╲,─,╱,r,r,r",x=9,y=9}
}

data.raw["rocket-silo"]["rocket-silo"].base_night_sprite={
    layers=helper{chars="r,r,r,╱,─,╲,r,r,r,r,r,┌,≞,≞,≞,┐,r,r,r,┌,≞,≞,≞,≞,≞,┐,r,╱,≞,≞,≞,≞,≞,≞,≞,╲,│,≞,≞,≞,≞,≞,≞,≞,│,╲,≞,≞,≞,≞,≞,≞,≞,╱,r,└,≞,≞,≞,≞,≞,┘,r,r,r,└,≞,≞,≞,┘,r,r,r,r,r,╲,─,╱,r,r,r",x=9,y=9}
}
data.raw["corpse"]["rocket-silo-remnants"].animation={layers=helper{chars="∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,🚀,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅,∅",x=9,y=9,ftint={{r=1,g=0.3,b=0.5}}}} --should improve this later


data.raw["rocket-silo"]["rocket-silo"].arm_01_back_animation=nil
data.raw["rocket-silo"]["rocket-silo"].arm_02_right_animation=nil
data.raw["rocket-silo"]["rocket-silo"].arm_03_front_animation=nil
data.raw["rocket-silo"]["rocket-silo"].shadow_sprite=nil
data.raw["rocket-silo"]["rocket-silo"].hole_sprite=nil
data.raw["rocket-silo"]["rocket-silo"].hole_light_sprite=nil
data.raw["rocket-silo"]["rocket-silo"].base_front_sprite=nil
data.raw["rocket-silo"]["rocket-silo"].red_lights_back_sprites=nil
data.raw["rocket-silo"]["rocket-silo"].red_lights_front_sprites=nil
data.raw["rocket-silo"]["rocket-silo"].satellite_animation=nil
data.raw["rocket-silo"]["rocket-silo"].satellite_shadow_animation=nil

data.raw["boiler"]["boiler"].pictures={
    north={
        structure={
            layers=helper{chars="b,⊥,b,⊢,🔥,⊣",x=3,y=2}
        },
        fire={
            layers=helper{chars="b,⊥,b,⊢,🔥,⊣",x=3,y=2,ftint={{r=1,g=0.5,b=0.5}}}
        }
    },
    south={
        structure={
            layers=helper{chars="⊢,🔥,⊣,b,⊤,b",x=3,y=2}
        },
        fire={
            layers=helper{chars="⊢,🔥,⊣,b,⊤,b",x=3,y=2,ftint={{r=1,g=0.5,b=0.5}}}
        }
    },
    east={
        structure={
            layers=helper{chars="⊤,b,🔥,⊢,⊥,b",x=2,y=3}
        },
        fire={
            layers=helper{chars="⊤,b,🔥,⊢,⊥,b",x=2,y=3,ftint={{r=1,g=0.5,b=0.5}}}
        }
    },
    west={
        structure={
            layers=helper{chars="b,⊤,⊣,🔥,b,⊥",x=2,y=3}
        },
        fire={
            layers=helper{chars="b,⊤,⊣,🔥,b,⊥",x=2,y=3,ftint={{r=1,g=0.5,b=0.5}}}
        }
    }
}
data.raw["boiler"]["boiler"].fluid_box.pipe_picture=nil
data.raw["boiler"]["boiler"].fluid_box.pipe_covers=nil
data.raw["boiler"]["boiler"].output_fluid_box.pipe_picture=nil
data.raw["boiler"]["boiler"].output_fluid_box.pipe_covers=nil
data.raw["corpse"]["boiler-remnants"].animation={layers=helper{chars="b,∅,🔥,∅",x=2,y=2,ftint={{r=1,g=0.3,b=0.5}}}} --should fix later


data.raw["boiler"]["heat-exchanger"].pictures={
    north={
        structure={
            layers=helper{chars="h,⊥,h,⊢,🌡,⊣",x=3,y=2}
        },
        fire={
            layers=helper{chars="h,⊥,h,⊢,🌡,⊣",x=3,y=2,ftint={{r=1,g=0.5,b=0.5}}}
        }
    },
    south={
        structure={
            layers=helper{chars="⊢,🌡,⊣,h,⊤,h",x=3,y=2}
        },
        fire={
            layers=helper{chars="⊢,🌡,⊣,h,⊤,h",x=3,y=2,ftint={{r=1,g=0.5,b=0.5}}}
        }
    },
    east={
        structure={
            layers=helper{chars="⊤,h,🌡,⊢,⊥,h",x=2,y=3}
        },
        fire={
            layers=helper{chars="⊤,h,🌡,⊢,⊥,h",x=2,y=3,ftint={{r=1,g=0.5,b=0.5}}}
        }
    },
    west={
        structure={
            layers=helper{chars="h,⊤,⊣,🌡,h,⊥",x=2,y=3}
        },
        fire={
            layers=helper{chars="h,⊤,⊣,🌡,h,⊥",x=2,y=3,ftint={{r=1,g=0.5,b=0.5}}}
        }
    }
}
data.raw["boiler"]["heat-exchanger"].fluid_box.pipe_picture=nil
data.raw["boiler"]["heat-exchanger"].fluid_box.pipe_covers=nil
data.raw["boiler"]["heat-exchanger"].output_fluid_box.pipe_picture=nil
data.raw["boiler"]["heat-exchanger"].output_fluid_box.pipe_covers=nil
data.raw["boiler"]["heat-exchanger"].energy_source.heat_picture=nil
data.raw["boiler"]["heat-exchanger"].energy_source.heat_glow=nil
data.raw["corpse"]["heat-exchanger-remnants"].animation={layers=helper{chars="h,∅,🌡,∅",x=2,y=2,ftint={{r=1,g=0.3,b=0.5}}}} --should fix later


data.raw["heat-pipe"]["heat-pipe"].connection_sprites={
    single={sheet=helper{chars="￮",x=1,y=1,ftint={{r=1,g=0.87,b=0.87}}}[2]},
    straight_vertical={sheet=helper{chars="┃",x=1,y=1,ftint={{r=1,g=0.87,b=0.87}}}[2]},
    straight_horizontal={sheet=helper{chars="━",x=1,y=1,ftint={{r=1,g=0.87,b=0.87}}}[2]},
    corner_right_down={sheet=helper{chars="┏",x=1,y=1,ftint={{r=1,g=0.87,b=0.87}}}[2]},
    corner_left_down={sheet=helper{chars="┓",x=1,y=1,ftint={{r=1,g=0.87,b=0.87}}}[2]},
    corner_right_up={sheet=helper{chars="┗",x=1,y=1,ftint={{r=1,g=0.87,b=0.87}}}[2]},
    corner_left_up={sheet=helper{chars="┛",x=1,y=1,ftint={{r=1,g=0.87,b=0.87}}}[2]},
    t_up={sheet=helper{chars="┻",x=1,y=1,ftint={{r=1,g=0.87,b=0.87}}}[2]},
    t_right={sheet=helper{chars="┣",x=1,y=1,ftint={{r=1,g=0.87,b=0.87}}}[2]},
    t_down={sheet=helper{chars="┳",x=1,y=1,ftint={{r=1,g=0.87,b=0.87}}}[2]},
    t_left={sheet=helper{chars="┫",x=1,y=1,ftint={{r=1,g=0.87,b=0.87}}}[2]},
    ending_up={sheet=helper{chars="╹",x=1,y=1,ftint={{r=1,g=0.87,b=0.87}}}[2]},
    ending_right={sheet=helper{chars="╺",x=1,y=1,ftint={{r=1,g=0.87,b=0.87}}}[2]},
    ending_down={sheet=helper{chars="╻",x=1,y=1,ftint={{r=1,g=0.87,b=0.87}}}[2]},
    ending_left={sheet=helper{chars="╸",x=1,y=1,ftint={{r=1,g=0.87,b=0.87}}}[2]},
    cross={sheet=helper{chars="╋",x=1,y=1,ftint={{r=1,g=0.87,b=0.87}}}[2]},
}

data.raw["heat-pipe"]["heat-pipe"].heat_glow_sprites={
    single={sheet=helper{chars="￮",x=1,y=1,ftint={{r=1,g=0.63,b=0.63}}}[2]},
    straight_vertical={sheet=helper{chars="┃",x=1,y=1,ftint={{r=1,g=0.63,b=0.63}}}[2]},
    straight_horizontal={sheet=helper{chars="━",x=1,y=1,ftint={{r=1,g=0.63,b=0.63}}}[2]},
    corner_right_down={sheet=helper{chars="┏",x=1,y=1,ftint={{r=1,g=0.63,b=0.63}}}[2]},
    corner_left_down={sheet=helper{chars="┓",x=1,y=1,ftint={{r=1,g=0.63,b=0.63}}}[2]},
    corner_right_up={sheet=helper{chars="┗",x=1,y=1,ftint={{r=1,g=0.63,b=0.63}}}[2]},
    corner_left_up={sheet=helper{chars="┛",x=1,y=1,ftint={{r=1,g=0.63,b=0.63}}}[2]},
    t_up={sheet=helper{chars="┻",x=1,y=1,ftint={{r=1,g=0.63,b=0.63}}}[2]},
    t_right={sheet=helper{chars="┣",x=1,y=1,ftint={{r=1,g=0.63,b=0.63}}}[2]},
    t_down={sheet=helper{chars="┳",x=1,y=1,ftint={{r=1,g=0.63,b=0.63}}}[2]},
    t_left={sheet=helper{chars="┫",x=1,y=1,ftint={{r=1,g=0.63,b=0.63}}}[2]},
    ending_up={sheet=helper{chars="╹",x=1,y=1,ftint={{r=1,g=0.63,b=0.63}}}[2]},
    ending_right={sheet=helper{chars="╺",x=1,y=1,ftint={{r=1,g=0.63,b=0.63}}}[2]},
    ending_down={sheet=helper{chars="╻",x=1,y=1,ftint={{r=1,g=0.63,b=0.63}}}[2]},
    ending_left={sheet=helper{chars="╸",x=1,y=1,ftint={{r=1,g=0.63,b=0.63}}}[2]},
    cross={sheet=helper{chars="╋",x=1,y=1,ftint={{r=1,g=0.63,b=0.63}}}[2]},
}
data.raw["corpse"]["heat-pipe-remnants"].animation={layers=helper{chars="￮",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}

data.raw["pipe"]["pipe"].pictures={
    straight_vertical_single={layers=helper{chars="￮",x=1,y=1}},
    straight_vertical_single_visualization={layers=helper{chars="￮",x=1,y=1}},
    straight_vertical_single_disabled_visualization={layers=helper{chars="￮",x=1,y=1}},
    straight_vertical={layers=helper{chars="┃",x=1,y=1}},
    straight_vertical_visualization={layers=helper{chars="┃",x=1,y=1}},
    straight_vertical_disabled_visualization={layers=helper{chars="┃",x=1,y=1}},
    straight_vertical_window={layers=helper{chars="┃",x=1,y=1}},
    straight_vertical_window_visualization={layers=helper{chars="┃",x=1,y=1}},
    straight_vertical_window_disabled_visualization={layers=helper{chars="┃",x=1,y=1}},
    straight_horizontal={layers=helper{chars="━",x=1,y=1}},
    straight_horizontal_visualization={layers=helper{chars="━",x=1,y=1}},
    straight_horizontal_disabled_visualization={layers=helper{chars="━",x=1,y=1}},
    straight_horizontal_window={layers=helper{chars="━",x=1,y=1}},
    straight_horizontal_window_visualization={layers=helper{chars="━",x=1,y=1}},
    straight_horizontal_window_disabled_visualization={layers=helper{chars="━",x=1,y=1}},
    corner_down_right={layers=helper{chars="┏",x=1,y=1}},
    corner_down_right_visualization={layers=helper{chars="┏",x=1,y=1}},
    corner_down_right_disabled_visualization={layers=helper{chars="┏",x=1,y=1}},
    corner_down_left={layers=helper{chars="┓",x=1,y=1}},
    corner_down_left_visualization={layers=helper{chars="┓",x=1,y=1}},
    corner_down_left_disabled_visualization={layers=helper{chars="┓",x=1,y=1}},
    corner_up_right={layers=helper{chars="┗",x=1,y=1}},
    corner_up_right_visualization={layers=helper{chars="┗",x=1,y=1}},
    corner_up_right_disabled_visualization={layers=helper{chars="┗",x=1,y=1}},
    corner_up_left={layers=helper{chars="┛",x=1,y=1}},
    corner_up_left_visualization={layers=helper{chars="┛",x=1,y=1}},
    corner_up_left_disabled_visualization={layers=helper{chars="┛",x=1,y=1}},
    t_up={layers=helper{chars="┻",x=1,y=1}},
    t_up_visualization={layers=helper{chars="┻",x=1,y=1}},
    t_up_disabled_visualization={layers=helper{chars="┻",x=1,y=1}},
    t_right={layers=helper{chars="┣",x=1,y=1}},
    t_right_visualization={layers=helper{chars="┣",x=1,y=1}},
    t_right_disabled_visualization={layers=helper{chars="┣",x=1,y=1}},
    t_down={layers=helper{chars="┳",x=1,y=1}},
    t_down_visualization={layers=helper{chars="┳",x=1,y=1}},
    t_down_disabled_visualization={layers=helper{chars="┳",x=1,y=1}},
    t_left={layers=helper{chars="┫",x=1,y=1}},
    t_left_visualization={layers=helper{chars="┫",x=1,y=1}},
    t_left_disabled_visualization={layers=helper{chars="┫",x=1,y=1}},
    ending_up={layers=helper{chars="╹",x=1,y=1}},
    ending_up_visualization={layers=helper{chars="╹",x=1,y=1}},
    ending_up_disabled_visualization={layers=helper{chars="╹",x=1,y=1}},
    ending_right={layers=helper{chars="╺",x=1,y=1}},
    ending_right_visualization={layers=helper{chars="╺",x=1,y=1}},
    ending_right_disabled_visualization={layers=helper{chars="╺",x=1,y=1}},
    ending_down={layers=helper{chars="╻",x=1,y=1}},
    ending_down_visualization={layers=helper{chars="╻",x=1,y=1}},
    ending_down_disabled_visualization={layers=helper{chars="╻",x=1,y=1}},
    ending_left={layers=helper{chars="╸",x=1,y=1}},
    ending_left_visualization={layers=helper{chars="╸",x=1,y=1}},
    ending_left_disabled_visualization={layers=helper{chars="╸",x=1,y=1}},
    cross={layers=helper{chars="╋",x=1,y=1}},
    cross_visualization={layers=helper{chars="╋",x=1,y=1}},
    cross_disabled_visualization={layers=helper{chars="╋",x=1,y=1}},
    vertical_window_background={layers=helper{chars="┃",x=1,y=1}},
    horizontal_window_background={layers=helper{chars="━",x=1,y=1}},
    low_temperature_flow={layers=helper{chars="━",x=1,y=1}},
    middle_temperature_flow={layers=helper{chars="━",x=1,y=1}},
    high_temperature_flow={layers=helper{chars="━",x=1,y=1}},
    gas_flow={layers=helper{chars="━",x=1,y=1}},
}
data.raw["pipe"]["pipe"].fluid_box.pipe_picture=nil
data.raw["pipe"]["pipe"].fluid_box.pipe_covers=nil
data.raw["corpse"]["pipe-remnants"].animation={layers=helper{chars="￮",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}


data.raw["pipe-to-ground"]["pipe-to-ground"].pictures={
    north={
        layers=helper{chars="⭻",x=1,y=1},
    },
    south={
        layers=helper{chars="⭽",x=1,y=1},
    },
    east={
        layers=helper{chars="⭼",x=1,y=1},
    },
    west={
        layers=helper{chars="⭺",x=1,y=1},
    }
}

data.raw["pipe-to-ground"]["pipe-to-ground"].visualization=data.raw["pipe-to-ground"]["pipe-to-ground"].pictures
data.raw["pipe-to-ground"]["pipe-to-ground"].disabled_visualization=data.raw["pipe-to-ground"]["pipe-to-ground"].pictures
data.raw["pipe-to-ground"]["pipe-to-ground"].fluid_box.pipe_picture=nil
data.raw["pipe-to-ground"]["pipe-to-ground"].fluid_box.pipe_covers=nil
data.raw["corpse"]["pipe-to-ground-remnants"].animation={layers=helper{chars="⭻",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}


data.raw["storage-tank"]["storage-tank"].pictures={
    picture={
        north={
            layers=helper{chars="┛,t,t,t,≞,t,t,t,┏",btint={{r=0,g=0,b=0},{r=0,g=0,b=0},{r=0,g=0,b=0},{r=0,g=0,b=0},{r=0,g=0,b=0,a=0},{r=0,g=0,b=0},{r=0,g=0,b=0},{r=0,g=0,b=0},{r=0,g=0,b=0}}},
        },
        south={
            layers=helper{chars="┛,t,t,t,≞,t,t,t,┏",btint={{r=0,g=0,b=0},{r=0,g=0,b=0},{r=0,g=0,b=0},{r=0,g=0,b=0},{r=0,g=0,b=0,a=0},{r=0,g=0,b=0},{r=0,g=0,b=0},{r=0,g=0,b=0},{r=0,g=0,b=0}}},
        },
        east={
            layers=helper{chars="t,t,┗,t,≞,t,┓,t,t",btint={{r=0,g=0,b=0},{r=0,g=0,b=0},{r=0,g=0,b=0},{r=0,g=0,b=0},{r=0,g=0,b=0,a=0},{r=0,g=0,b=0},{r=0,g=0,b=0},{r=0,g=0,b=0},{r=0,g=0,b=0}}},
        },
        west={
            layers=helper{chars="t,t,┗,t,≞,t,┓,t,t",btint={{r=0,g=0,b=0},{r=0,g=0,b=0},{r=0,g=0,b=0},{r=0,g=0,b=0},{r=0,g=0,b=0,a=0},{r=0,g=0,b=0},{r=0,g=0,b=0},{r=0,g=0,b=0},{r=0,g=0,b=0}}},
        }
    },
    window_background={layers=helper{chars="≞",x=1,y=1}},
    fluid_background={layers=helper{chars="≋",x=1,y=1}},
    --flow_sprite={layers=helper{chars="≋",x=1,y=1,btint={{r=0,g=0,b=0,a=0}}}},
    --gas_flow={layers=helper{chars="≋",x=1,y=1,btint={{r=0,g=0,b=0,a=0}}}},
}
data.raw["storage-tank"]["storage-tank"].window_bounding_box={{-0.5,-0.5},{0.5,0.5}}
data.raw["storage-tank"]["storage-tank"].fluid_box.pipe_picture=nil
data.raw["storage-tank"]["storage-tank"].fluid_box.pipe_covers=nil
data.raw["corpse"]["storage-tank-remnants"].animation={layers=helper{chars="∅,∅,∅,∅,≋,∅,∅,t,∅",ftint={{r=1,g=0.3,b=0.5}}}}


counter_a=1
counter_b=1
color_for_trees={{r=0.75,g=1,b=0.75},{r=0.87,g=1,b=0.75},{r=0.75,g=1,b=0.87},{r=0.63,g=1,b=0.75},{r=0.75,g=1,b=0.63},{r=0.63,g=1,b=0.63},{r=0.87,g=1,b=0.87},{r=0.5,g=1,b=0.75},{r=0.75,g=1,b=0.5},{r=0.5,g=1,b=0.5},{r=0.87,g=1,b=0.75},{r=0.5,g=1,b=0.87},{r=0.5,g=1,b=0.63},{r=0.63,g=1,b=0.75},{r=0.63,g=0.87,b=0.63},{r=0.5,g=0.87,b=0.5},{r=0.5,g=0.75,b=0.5}}
color_for_dead_trees={{r=0.5,g=0.25,b=0.25},{r=0.5,g=0.37,b=0.25},{r=0.5,g=0.25,b=0.37},}

for treename,treetable in pairs(data.raw["tree"]) do
    if treename ~= "dead-dry-hairy-tree" and treename ~= "dead-grey-trunk" and treename ~= "dead-tree-desert" and treename ~= "dry-hairy-tree" and treename ~= "dry-tree" then
        treetable.pictures={layers=helper{chars="⮝,⮝,⮝,⮝,↥,↥",x=2,y=3,offy=-1,ftint={color_for_trees[counter_a]},btint={{r=0,g=0,b=0,a=0}}}}
        treetable.variations=nil
        treetable.variation_weights=nil
        counter_a=counter_a+1
    elseif treename == "dry-hairy-tree" or treename == "dry-tree" then
        treetable.pictures={layers=helper{chars="↥,↥,↥,↥,↥,↥",x=2,y=3,offy=-1,ftint={color_for_trees[counter_a]},btint={{r=0,g=0,b=0,a=0}}}}
        treetable.variations=nil
        treetable.variation_weights=nil
        counter_a=counter_a+1
    else
        treetable.pictures={layers=helper{chars="≞,≞,╱,╱",x=2,y=2,offy=-1,ftint={color_for_dead_trees[counter_b]},btint={{r=0,g=0,b=0,a=0}}}}
        treetable.variations=nil
        treetable.variation_weights=nil
        counter_b=counter_b+1
    end
end

for corpsename,corpsetable in pairs(data.raw["corpse"]) do
    if string.find(corpsename,".*stump.*") ~= nil then
        corpsetable.animation={layers=helper{chars="￮",x=1,y=1,ftint={{r=0.5,g=0.25,b=0.25}},btint={{r=0,g=0,b=0,a=0}}}}
    end
end



data.raw["simple-entity"]["huge-rock"].pictures={layers=helper{chars="⛰,⛰,⛰,⛰,⛰,⛰,⛰,⛰,⛰,⛰,⛰,⛰",x=4,y=3,ftint={{r=0.5,g=0.5,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["simple-entity"]["big-rock"].pictures={layers=helper{chars="⛰,⛰,⛰,⛰,⛰,⛰,⛰,⛰,⛰",ftint={{r=0.5,g=0.5,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["simple-entity"]["big-sand-rock"].pictures={layers=helper{chars="⛰,⛰,⛰,⛰",x=2,y=2,ftint={{r=0.87,g=0.87,b=0.63}},btint={{r=0,g=0,b=0,a=0}}}}


data.raw["pump"]["pump"].animations={
    north={
        layers=helper{chars="p,p",x=1,y=2}
    },
    south={
        layers=helper{chars="p,p",x=1,y=2}
    },
    east={
        layers=helper{chars="p,p",x=2,y=1}
    },
    west={
        layers=helper{chars="p,p",x=2,y=1}
    }
}

data.raw["pump"]["pump"].fluid_animation={
    north={
        layers=helper{chars="p,p",x=1,y=2}
    },
    south={
        layers=helper{chars="p,p",x=1,y=2}
    },
    east={
        layers=helper{chars="p,p",x=2,y=1}
    },
    west={
        layers=helper{chars="p,p",x=2,y=1}
    }
}
data.raw["pump"]["pump"].glass_pictures=nil
data.raw["pump"]["pump"].fluid_box.pipe_picture=nil
data.raw["pump"]["pump"].fluid_box.pipe_covers=nil
data.raw["corpse"]["pump-remnants"].animation={layers=helper{chars="p",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}} --should fix this later


data.raw["offshore-pump"]["offshore-pump"].graphics_set={
    animation={
        north={
            layers=helper{chars="o,p",x=1,y=2,offy=-0.5}
        },
        south={
            layers=helper{chars="p,o",x=1,y=2,offy=0.5}
        },
        east={
            layers=helper{chars="p,o",x=2,y=1,offx=0.5}
        },
        west={
            layers=helper{chars="o,p",x=2,y=1,offx=-0.5}
        }
    },
    fluid_animation={
        north={
            layers=helper{chars="o,p",x=1,y=2,offy=-0.5}
        },
        south={
            layers=helper{chars="p,o",x=1,y=2,offy=0.5}
        },
        east={
            layers=helper{chars="p,o",x=2,y=1,offx=0.5}
        },
        west={
            layers=helper{chars="o,p",x=2,y=1,offx=-0.5}
        }
    },
}
data.raw["offshore-pump"]["offshore-pump"].fluid_box.pipe_picture=nil
data.raw["offshore-pump"]["offshore-pump"].fluid_box.pipe_covers=nil
data.raw["corpse"]["offshore-pump-remnants"].animation={layers=helper{chars="p",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}} --should fix this later



data.raw["trivial-smoke"]["fire-smoke-without-glow"].animation={layers={helper{chars="⌇",x=1,y=1}[2]}}
data.raw["trivial-smoke"]["fire-smoke"].animation={layers={helper{chars="⌇",x=1,y=1,ftint={{r=1,g=0.5,b=0.5}}}[2]}}
data.raw["trivial-smoke"]["fire-smoke"].glow_animation={layers={helper{chars="⌇",x=1,y=1,ftint={{r=1,g=0.3,b=0.3}}}[2]}}
data.raw["trivial-smoke"]["soft-fire-smoke"].animation={layers={helper{chars="⌇",x=1,y=1,ftint={{r=1,g=0.5,b=0.5}}}[2]}}
data.raw["trivial-smoke"]["soft-fire-smoke"].glow_animation={layers={helper{chars="⌇",x=1,y=1,ftint={{r=1,g=0.4,b=0.4}}}[2]}}
data.raw["trivial-smoke"]["fire-smoke-on-adding-fuel"].animation={layers={helper{chars="⌇",x=1,y=1,ftint={{r=1,g=0.4,b=0.4}}}[2]}}
data.raw["trivial-smoke"]["fire-smoke-on-adding-fuel"].glow_animation={layers={helper{chars="⌇",x=1,y=1,ftint={{r=1,g=0.25,b=0.25}}}[2]}}
data.raw["trivial-smoke"]["smoke"].animation={layers={helper{chars="⌇",x=1,y=1}[2]}}
data.raw["trivial-smoke"]["smoke-building"].animation={layers={helper{chars="⌇",x=1,y=1}[2]}}
data.raw["trivial-smoke"]["artillery-smoke"].animation={layers={helper{chars="⌇",x=1,y=1}[2]}}
data.raw["trivial-smoke"]["tank-smoke"].animation={layers={helper{chars="⌇",x=1,y=1}[2]}}
data.raw["trivial-smoke"]["train-smoke"].animation={layers={helper{chars="⌇",x=1,y=1}[2]}}
data.raw["trivial-smoke"]["turbine-smoke"].animation={layers={helper{chars="⌇",x=1,y=1}[2]}}
data.raw["trivial-smoke"]["smoke-train-stop"].animation={layers={helper{chars="⌇",x=1,y=1}[2]}}
data.raw["trivial-smoke"]["smoke-fast"].animation={layers={helper{chars="⌇",x=1,y=1}[2]}}
data.raw["trivial-smoke"]["light-smoke"].animation={layers={helper{chars="⌇",x=1,y=1}[2]}}
data.raw["trivial-smoke"]["car-smoke"].animation={layers={helper{chars="⌇",x=1,y=1}[2]}}
data.raw["trivial-smoke"]["smoke-fast"].animation={layers={helper{chars="⌇",x=1,y=1}[2]}}
data.raw["trivial-smoke"]["nuclear-smoke"].animation={layers={helper{chars="⌇",x=1,y=1,ftint={{r=0.87,g=0.87,b=0.5}}}[2]}}
data.raw["trivial-smoke"]["nuclear-smoke"].glow_animation={layers={helper{chars="⌇",x=1,y=1,ftint={{r=1,g=1,b=0.5}}}[2]}}
data.raw["trivial-smoke"]["poison-capsule-smoke"].animation={layers={helper{chars="⌇",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}[2]}}
data.raw["trivial-smoke"]["poison-capsule-particle-smoke"].animation={layers={helper{chars="⌇",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}[2]}}
data.raw["trivial-smoke"]["smoke-explosion-lower-particle-small"].animation={layers={helper{chars="⌇",x=1,y=1}[2]}}
data.raw["trivial-smoke"]["smoke-explosion-particle"].animation={layers={helper{chars="⌇",x=1,y=1}[2]}}
data.raw["trivial-smoke"]["smoke-explosion-particle-small"].animation={layers={helper{chars="⌇",x=1,y=1}[2]}}
data.raw["trivial-smoke"]["smoke-explosion-particle-stone-small"].animation={layers={helper{chars="⌇",x=1,y=1}[2]}}
data.raw["trivial-smoke"]["smoke-explosion-particle-tiny"].animation={layers={helper{chars="⌇",x=1,y=1}[2]}}
data.raw["trivial-smoke"]["small-dusty-explosion-smoke"].animation={layers={helper{chars="⌇",x=1,y=1}[2]}}
data.raw["smoke-with-trigger"]["crash-site-fire-smoke"].animation={layers={helper{chars="⌇",x=1,y=1,ftint={{r=1,g=0.5,b=0.5}}}[2]}}
data.raw["smoke-with-trigger"]["crash-site-explosion-smoke"].animation={layers={helper{chars="⌇",x=1,y=1}[2]}}
data.raw["smoke-with-trigger"]["poison-cloud"].animation={layers={helper{chars="⌇",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}[2]}}
data.raw["smoke-with-trigger"]["poison-cloud-visual-dummy"].animation={layers={helper{chars="⌇",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}[2]}}
data.raw["explosion"]["atomic-fire-smoke"].animations={layers={helper{chars="⌇",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}[2]}}
data.raw["explosion"]["atomic-nuke-shockwave"].animations={layers={helper{chars="⌇",x=1,y=1,ftint={{r=1,g=1,b=0.5}}}[2]}}

data.raw["transport-belt"]["transport-belt"].belt_animation_set={
    animation_set={
        filename="__pixeltorio_base_ent__/graphics/tileset/belt.png",width=resolution,height=resolution,scale=32/resolution,direction_count=13,tint={r=1,g=1,b=0.25}
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
data.raw["corpse"]["transport-belt-remnants"].animation={layers=helper{chars="▲",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}

data.raw["transport-belt"]["fast-transport-belt"].belt_animation_set={
    animation_set={
        filename="__pixeltorio_base_ent__/graphics/tileset/belt.png",width=resolution,height=resolution,scale=32/resolution,direction_count=13,tint={r=1,g=0.25,b=0.25}
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
data.raw["corpse"]["fast-transport-belt-remnants"].animation={layers=helper{chars="▲",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}

data.raw["transport-belt"]["express-transport-belt"].belt_animation_set={
    animation_set={
        filename="__pixeltorio_base_ent__/graphics/tileset/belt.png",width=resolution,height=resolution,scale=32/resolution,direction_count=13,tint={r=0.25,g=0.25,b=1}
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
data.raw["corpse"]["express-transport-belt-remnants"].animation={layers=helper{chars="▲",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}

data.raw["underground-belt"]["underground-belt"].structure={
    direction_in={
        north={layers=helper{chars="⨺1",x=1,y=1,ftint={{r=1,g=1,b=0.25}}}},
        south={layers=helper{chars="⨺2",x=1,y=1,ftint={{r=1,g=1,b=0.25}}}},
        east={layers=helper{chars="⨺3",x=1,y=1,ftint={{r=1,g=1,b=0.25}}}},
        west={layers=helper{chars="⨺4",x=1,y=1,ftint={{r=1,g=1,b=0.25}}}},
    },
    direction_out={
        north={layers=helper{chars="⨹2",x=1,y=1,ftint={{r=1,g=1,b=0.25}}}},
        south={layers=helper{chars="⨹1",x=1,y=1,ftint={{r=1,g=1,b=0.25}}}},
        east={layers=helper{chars="⨹4",x=1,y=1,ftint={{r=1,g=1,b=0.25}}}},
        west={layers=helper{chars="⨹3",x=1,y=1,ftint={{r=1,g=1,b=0.25}}}},
    }
}
data.raw["underground-belt"]["underground-belt"].belt_animation_set=nil
data.raw["corpse"]["underground-belt-remnants"].animation={layers=helper{chars="⨺",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}



data.raw["underground-belt"]["fast-underground-belt"].structure={
    direction_in={
        north={layers=helper{chars="⨺1",x=1,y=1,ftint={{r=1,g=0.25,b=0.25}}}},
        south={layers=helper{chars="⨺2",x=1,y=1,ftint={{r=1,g=0.25,b=0.25}}}},
        east={layers=helper{chars="⨺3",x=1,y=1,ftint={{r=1,g=0.25,b=0.25}}}},
        west={layers=helper{chars="⨺4",x=1,y=1,ftint={{r=1,g=0.25,b=0.25}}}},
    },
    direction_out={
        north={layers=helper{chars="⨹2",x=1,y=1,ftint={{r=1,g=0.25,b=0.25}}}},
        south={layers=helper{chars="⨹1",x=1,y=1,ftint={{r=1,g=0.25,b=0.25}}}},
        east={layers=helper{chars="⨹4",x=1,y=1,ftint={{r=1,g=0.25,b=0.25}}}},
        west={layers=helper{chars="⨹3",x=1,y=1,ftint={{r=1,g=0.25,b=0.25}}}},
    }
}
data.raw["underground-belt"]["fast-underground-belt"].belt_animation_set=nil
data.raw["corpse"]["fast-underground-belt-remnants"].animation={layers=helper{chars="⨺",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}


data.raw["underground-belt"]["express-underground-belt"].structure={
    direction_in={
        north={layers=helper{chars="⨺1",x=1,y=1,ftint={{r=0.25,g=0.25,b=1}}}},
        south={layers=helper{chars="⨺2",x=1,y=1,ftint={{r=0.25,g=0.25,b=1}}}},
        east={layers=helper{chars="⨺3",x=1,y=1,ftint={{r=0.25,g=0.25,b=1}}}},
        west={layers=helper{chars="⨺4",x=1,y=1,ftint={{r=0.25,g=0.25,b=1}}}},
    },
    direction_out={
        north={layers=helper{chars="⨹2",x=1,y=1,ftint={{r=0.25,g=0.25,b=1}}}},
        south={layers=helper{chars="⨹1",x=1,y=1,ftint={{r=0.25,g=0.25,b=1}}}},
        east={layers=helper{chars="⨹4",x=1,y=1,ftint={{r=0.25,g=0.25,b=1}}}},
        west={layers=helper{chars="⨹3",x=1,y=1,ftint={{r=0.25,g=0.25,b=1}}}},
    }
}
data.raw["underground-belt"]["express-underground-belt"].belt_animation_set=nil
data.raw["corpse"]["express-underground-belt-remnants"].animation={layers=helper{chars="⨺",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}


data.raw["splitter"]["splitter"].structure={
    north={layers=helper{chars="ṡ1,ṡ1",x=2,y=1,ftint={{r=1,g=1,b=0.25}}}},
    south={layers=helper{chars="ṡ2,ṡ2",x=2,y=1,ftint={{r=1,g=1,b=0.25}}}},
    east={layers=helper{chars="ṡ3,ṡ3",x=1,y=2,ftint={{r=1,g=1,b=0.25}}}},
    west={layers=helper{chars="ṡ4,ṡ4",x=1,y=2,ftint={{r=1,g=1,b=0.25}}}},
}
data.raw["splitter"]["splitter"].structure_patch=nil
data.raw["splitter"]["splitter"].belt_animation_set=nil
data.raw["corpse"]["splitter-remnants"].animation={layers=helper{chars="ṡ1",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}} --should fix later


data.raw["splitter"]["fast-splitter"].structure={
    north={layers=helper{chars="ṡ1,ṡ1",x=2,y=1,ftint={{r=1,g=0.25,b=0.25}}}},
    south={layers=helper{chars="ṡ2,ṡ2",x=2,y=1,ftint={{r=1,g=0.25,b=0.25}}}},
    east={layers=helper{chars="ṡ3,ṡ3",x=1,y=2,ftint={{r=1,g=0.25,b=0.25}}}},
    west={layers=helper{chars="ṡ4,ṡ4",x=1,y=2,ftint={{r=1,g=0.25,b=0.25}}}},
}
data.raw["splitter"]["fast-splitter"].structure_patch=nil
data.raw["splitter"]["fast-splitter"].belt_animation_set=nil
data.raw["corpse"]["fast-splitter-remnants"].animation={layers=helper{chars="ṡ1",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}} --should fix later



data.raw["splitter"]["express-splitter"].structure={
    north={layers=helper{chars="ṡ1,ṡ1",x=2,y=1,ftint={{r=0.25,g=0.25,b=1}}}},
    south={layers=helper{chars="ṡ2,ṡ2",x=2,y=1,ftint={{r=0.25,g=0.25,b=1}}}},
    east={layers=helper{chars="ṡ3,ṡ3",x=1,y=2,ftint={{r=0.25,g=0.25,b=1}}}},
    west={layers=helper{chars="ṡ4,ṡ4",x=1,y=2,ftint={{r=0.25,g=0.25,b=1}}}},
}
data.raw["splitter"]["express-splitter"].structure_patch=nil
data.raw["splitter"]["express-splitter"].belt_animation_set=nil
data.raw["corpse"]["express-splitter-remnants"].animation={layers=helper{chars="ṡ1",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}} --should fix later


data.raw["inserter"]["inserter"].platform_picture={
    north={layers=helper{chars="i1",x=1,y=1,ftint={{r=1,g=1,b=0.25}}}},
    south={layers=helper{chars="i2",x=1,y=1,ftint={{r=1,g=1,b=0.25}}}},
    east={layers=helper{chars="i3",x=1,y=1,ftint={{r=1,g=1,b=0.25}}}},
    west={layers=helper{chars="i4",x=1,y=1,ftint={{r=1,g=1,b=0.25}}}},
}
data.raw["inserter"]["inserter"].hand_base_picture=nil
data.raw["inserter"]["inserter"].hand_open_picture={layers=helper{chars="●",x=1,y=1,ftint={{r=1,g=1,b=0.25}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["inserter"]["inserter"].hand_closed_picture={layers=helper{chars="●",x=1,y=1,ftint={{r=1,g=1,b=0.25}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["inserter"]["inserter"].hand_base_shadow=nil
data.raw["inserter"]["inserter"].hand_open_shadow=nil
data.raw["inserter"]["inserter"].hand_closed_shadow=nil
data.raw["corpse"]["inserter-remnants"].animation={layers=helper{chars="i",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}



data.raw["inserter"]["long-handed-inserter"].platform_picture={
    north={layers=helper{chars="i1",x=1,y=1,ftint={{r=1,g=0.25,b=0.25}}}},
    south={layers=helper{chars="i2",x=1,y=1,ftint={{r=1,g=0.25,b=0.25}}}},
    east={layers=helper{chars="i3",x=1,y=1,ftint={{r=1,g=0.25,b=0.25}}}},
    west={layers=helper{chars="i4",x=1,y=1,ftint={{r=1,g=0.25,b=0.25}}}},
}
data.raw["inserter"]["long-handed-inserter"].hand_base_picture=nil
data.raw["inserter"]["long-handed-inserter"].hand_open_picture={layers=helper{chars="●",x=1,y=1,ftint={{r=1,g=0.25,b=0.25}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["inserter"]["long-handed-inserter"].hand_closed_picture={layers=helper{chars="●",x=1,y=1,ftint={{r=1,g=0.25,b=0.25}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["inserter"]["long-handed-inserter"].hand_base_shadow=nil
data.raw["inserter"]["long-handed-inserter"].hand_open_shadow=nil
data.raw["inserter"]["long-handed-inserter"].hand_closed_shadow=nil
data.raw["corpse"]["long-handed-inserter-remnants"].animation={layers=helper{chars="i",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}



data.raw["inserter"]["fast-inserter"].platform_picture={
    north={layers=helper{chars="i1",x=1,y=1,ftint={{r=0.25,g=0.25,b=1}}}},
    south={layers=helper{chars="i2",x=1,y=1,ftint={{r=0.25,g=0.25,b=1}}}},
    east={layers=helper{chars="i3",x=1,y=1,ftint={{r=0.25,g=0.25,b=1}}}},
    west={layers=helper{chars="i4",x=1,y=1,ftint={{r=0.25,g=0.25,b=1}}}},
}
data.raw["inserter"]["fast-inserter"].hand_base_picture=nil
data.raw["inserter"]["fast-inserter"].hand_open_picture={layers=helper{chars="●",x=1,y=1,ftint={{r=0.25,g=0.25,b=1}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["inserter"]["fast-inserter"].hand_closed_picture={layers=helper{chars="●",x=1,y=1,ftint={{r=0.25,g=0.25,b=1}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["inserter"]["fast-inserter"].hand_base_shadow=nil
data.raw["inserter"]["fast-inserter"].hand_open_shadow=nil
data.raw["inserter"]["fast-inserter"].hand_closed_shadow=nil
data.raw["corpse"]["fast-inserter-remnants"].animation={layers=helper{chars="i",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}


data.raw["inserter"]["burner-inserter"].platform_picture={
    north={layers=helper{chars="i1",x=1,y=1,ftint={{r=0.5,g=0.5,b=0.5}}}},
    south={layers=helper{chars="i2",x=1,y=1,ftint={{r=0.5,g=0.5,b=0.5}}}},
    east={layers=helper{chars="i3",x=1,y=1,ftint={{r=0.5,g=0.5,b=0.5}}}},
    west={layers=helper{chars="i4",x=1,y=1,ftint={{r=0.5,g=0.5,b=0.5}}}},
}
data.raw["inserter"]["burner-inserter"].hand_base_picture=nil
data.raw["inserter"]["burner-inserter"].hand_open_picture={layers=helper{chars="●",x=1,y=1,ftint={{r=0.5,g=0.5,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["inserter"]["burner-inserter"].hand_closed_picture={layers=helper{chars="●",x=1,y=1,ftint={{r=0.5,g=0.5,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["inserter"]["burner-inserter"].hand_base_shadow=nil
data.raw["inserter"]["burner-inserter"].hand_open_shadow=nil
data.raw["inserter"]["burner-inserter"].hand_closed_shadow=nil
data.raw["corpse"]["burner-inserter-remnants"].animation={layers=helper{chars="i",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}


data.raw["inserter"]["bulk-inserter"].platform_picture={
    north={layers=helper{chars="i1",x=1,y=1,ftint={{r=0.25,g=1,b=0.25}}}},
    south={layers=helper{chars="i2",x=1,y=1,ftint={{r=0.25,g=1,b=0.25}}}},
    east={layers=helper{chars="i3",x=1,y=1,ftint={{r=0.25,g=1,b=0.25}}}},
    west={layers=helper{chars="i4",x=1,y=1,ftint={{r=0.25,g=1,b=0.25}}}},
}
data.raw["inserter"]["bulk-inserter"].hand_base_picture=nil
data.raw["inserter"]["bulk-inserter"].hand_open_picture={layers=helper{chars="●",x=1,y=1,ftint={{r=0.25,g=1,b=0.25}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["inserter"]["bulk-inserter"].hand_closed_picture={layers=helper{chars="●",x=1,y=1,ftint={{r=0.25,g=1,b=0.25}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["inserter"]["bulk-inserter"].hand_base_shadow=nil
data.raw["inserter"]["bulk-inserter"].hand_open_shadow=nil
data.raw["inserter"]["bulk-inserter"].hand_closed_shadow=nil
data.raw["corpse"]["bulk-inserter-remnants"].animation={layers=helper{chars="i",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}


data.raw["roboport"]["roboport"].base_animation={
    layers=helper{chars="📶,b,Ɨ,b,b,◜,◝,b,b,◟,◞,b,b,b,b,b",x=4,y=4}
}
data.raw["roboport"]["roboport"].base=nil
data.raw["roboport"]["roboport"].base_patch=nil
data.raw["roboport"]["roboport"].door_animation_down=nil
data.raw["roboport"]["roboport"].door_animation_up=nil
data.raw["roboport"]["roboport"].recharging_animation=nil
data.raw["corpse"]["roboport-remnants"].animation={layers=helper{chars="∅,∅,∅,∅,∅,📶,∅,∅,∅,Ɨ,∅,∅,∅,∅,∅,∅",x=4,y=4,ftint={{r=1,g=0.3,b=0.5}}}}

data.raw["logistic-robot"]["logistic-robot"].idle_with_cargo={layers=helper{chars="ḣ",x=1,y=1,ftint={r=1,g=1,b=1},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["logistic-robot"]["logistic-robot"].in_motion_with_cargo={layers=helper{chars="ḣ",x=1,y=1,ftint={r=1,g=1,b=1},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["logistic-robot"]["logistic-robot"].idle={layers=helper{chars="ḣ",x=1,y=1,ftint={r=1,g=1,b=1},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["logistic-robot"]["logistic-robot"].in_motion={layers=helper{chars="ḣ",x=1,y=1,ftint={r=1,g=1,b=1},btint={{r=0,g=0,b=0,a=0}}}}


data.raw["logistic-robot"]["logistic-robot"].shadow_idle_with_cargo={layers=helper{chars="≞",x=1,y=1,ftint={r=1,g=1,b=1},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["logistic-robot"]["logistic-robot"].shadow_in_motion_with_cargo={layers=helper{chars="≞",x=1,y=1,ftint={r=1,g=1,b=1},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["logistic-robot"]["logistic-robot"].shadow_idle={layers=helper{chars="≞",x=1,y=1,ftint={r=1,g=1,b=1},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["logistic-robot"]["logistic-robot"].shadow_in_motion={layers=helper{chars="≞",x=1,y=1,ftint={r=1,g=1,b=1},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["corpse"]["logistic-robot-remnants"].animation={layers=helper{chars="ḣ",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}



data.raw["construction-robot"]["construction-robot"].working={layers=helper{chars="ṅ",x=1,y=1,ftint={r=1,g=1,b=1},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["construction-robot"]["construction-robot"].idle={layers=helper{chars="ṅ",x=1,y=1,ftint={r=1,g=1,b=1},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["construction-robot"]["construction-robot"].in_motion={layers=helper{chars="ṅ",x=1,y=1,ftint={r=1,g=1,b=1},btint={{r=0,g=0,b=0,a=0}}}}

data.raw["construction-robot"]["construction-robot"].shadow_working={layers=helper{chars="≞",x=1,y=1,ftint={r=1,g=1,b=1},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["construction-robot"]["construction-robot"].shadow_idle={layers=helper{chars="≞",x=1,y=1,ftint={r=1,g=1,b=1},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["construction-robot"]["construction-robot"].shadow_in_motion={layers=helper{chars="≞",x=1,y=1,ftint={r=1,g=1,b=1},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["corpse"]["construction-robot-remnants"].animation={layers=helper{chars="ṅ",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}


data.raw["radar"]["radar"].pictures={layers=helper{chars="r,r,r,r,📡,r,r,r,r",ftint={{r=0.5,g=1,b=1}}}}
data.raw["corpse"]["radar-remnants"].animation={layers=helper{chars="∅,∅,∅,∅,📡,∅,∅,∅,∅",ftint={{r=1,g=0.3,b=0.5}}}}

data.raw["wall"]["stone-wall"].pictures={
    single={layers=helper{chars="W",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}},
    straight_vertical={layers=helper{chars="W",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}},
    straight_horizontal={layers=helper{chars="W",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}},
    corner_right_down={layers=helper{chars="W",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}},
    corner_left_down={layers=helper{chars="W",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}},
    t_up={layers=helper{chars="W",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}},
    ending_right={layers=helper{chars="W",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}},
    ending_left={layers=helper{chars="W",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}},
    filling=nil,
    water_connection_patch={layers=helper{chars="W",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}},
    gate_connection_patch={layers=helper{chars="W",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}},
}
data.raw["corpse"]["wall-remnants"].animation={layers=helper{chars="W",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}

data.raw["gate"]["gate"].vertical_animation={layers=helper{chars="g",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}}
data.raw["gate"]["gate"].horizontal_animation=data.raw["gate"]["gate"].vertical_animation
data.raw["gate"]["gate"].vertical_rail_animation_left=data.raw["gate"]["gate"].vertical_animation
data.raw["gate"]["gate"].vertical_rail_animation_right=data.raw["gate"]["gate"].vertical_animation
data.raw["gate"]["gate"].horizontal_rail_animation_left=data.raw["gate"]["gate"].vertical_animation
data.raw["gate"]["gate"].horizontal_rail_animation_right=data.raw["gate"]["gate"].vertical_animation
data.raw["gate"]["gate"].vertical_rail_base={layers=helper{chars="g",x=1,y=1,ftint={{r=0.5,g=0.5,b=0.5}}}}
data.raw["gate"]["gate"].horizontal_rail_base=data.raw["gate"]["gate"].vertical_rail_base
data.raw["corpse"]["gate-remnants"].animation={layers=helper{chars="g",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}


data.raw["fire"]["acid-splash-fire-spitter-behemoth"].pictures={sheet=helper{chars="🔥",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}[2]}
data.raw["fire"]["acid-splash-fire-spitter-behemoth"].secondary_pictures={sheet=helper{chars="🔥",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}[2]}
data.raw["fire"]["acid-splash-fire-spitter-big"].pictures={sheet=helper{chars="🔥",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}[2]}
data.raw["fire"]["acid-splash-fire-spitter-big"].secondary_pictures={sheet=helper{chars="🔥",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}[2]}
data.raw["fire"]["acid-splash-fire-spitter-medium"].pictures={sheet=helper{chars="🔥",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}[2]}
data.raw["fire"]["acid-splash-fire-spitter-medium"].secondary_pictures={sheet=helper{chars="🔥",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}[2]}
data.raw["fire"]["acid-splash-fire-spitter-small"].pictures={sheet=helper{chars="🔥",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}[2]}
data.raw["fire"]["acid-splash-fire-spitter-small"].secondary_pictures={sheet=helper{chars="🔥",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}[2]}

data.raw["fire"]["acid-splash-fire-worm-behemoth"].pictures={sheet=helper{chars="🔥",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}[2]}
data.raw["fire"]["acid-splash-fire-worm-behemoth"].secondary_pictures={sheet=helper{chars="🔥",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}[2]}
data.raw["fire"]["acid-splash-fire-worm-big"].pictures={sheet=helper{chars="🔥",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}[2]}
data.raw["fire"]["acid-splash-fire-worm-big"].secondary_pictures={sheet=helper{chars="🔥",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}[2]}
data.raw["fire"]["acid-splash-fire-worm-medium"].pictures={sheet=helper{chars="🔥",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}[2]}
data.raw["fire"]["acid-splash-fire-worm-medium"].secondary_pictures={sheet=helper{chars="🔥",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}[2]}
data.raw["fire"]["acid-splash-fire-worm-small"].pictures={sheet=helper{chars="🔥",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}[2]}
data.raw["fire"]["acid-splash-fire-worm-small"].secondary_pictures={sheet=helper{chars="🔥",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}}}[2]}



data.raw["fire"]["crash-site-fire-flame"].pictures={sheet=helper{chars="🔥",x=1,y=1,ftint={{r=1,g=0.25,b=0.25}}}[2]}
data.raw["fire"]["crash-site-fire-flame"].smoke_source_pictures={sheet=helper{chars="⌇",x=1,y=1,ftint={{r=1,g=0.5,b=0.5}}}[2]}

data.raw["fire"]["fire-flame"].pictures={sheet=helper{chars="🔥",x=1,y=1,ftint={{r=1,g=0.25,b=0.25}}}[2]}
data.raw["fire"]["fire-flame"].burnt_patch_pictures={sheet=helper{chars="♒",x=1,y=1,ftint={{r=0.2,g=0,b=0}}}[2]}
data.raw["fire"]["fire-flame"].smoke_source_pictures={sheet=helper{chars="⌇",x=1,y=1,ftint={{r=1,g=0.5,b=0.5}}}[2]}

data.raw["fire"]["fire-flame-on-tree"].pictures={sheet=helper{chars="🔥",x=1,y=1,ftint={{r=1,g=0.25,b=0.25}}}[2]}
data.raw["fire"]["fire-flame-on-tree"].small_tree_fire_pictures={sheet=helper{chars="🔥",x=1,y=1,ftint={{r=1,g=0.25,b=0.25}}}[2]}
data.raw["fire"]["fire-flame-on-tree"].smoke_source_pictures={sheet=helper{chars="⌇",x=1,y=1,ftint={{r=1,g=0.5,b=0.5}}}[2]}




data.raw["stream"]["acid-stream-spitter-behemoth"].spine_animation={layers=helper{chars="➺",x=1,y=1,ftint={{r=0.5,g=1,b=0.3}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["stream"]["acid-stream-spitter-behemoth"].shadow=nil
data.raw["stream"]["acid-stream-spitter-behemoth"].particle=nil
data.raw["stream"]["acid-stream-spitter-behemoth"].particle_spawn_interval=6

data.raw["stream"]["acid-stream-spitter-big"].spine_animation={layers=helper{chars="➺",x=1,y=1,ftint={{r=0.5,g=1,b=0.3}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["stream"]["acid-stream-spitter-big"].shadow=nil
data.raw["stream"]["acid-stream-spitter-big"].particle=nil
data.raw["stream"]["acid-stream-spitter-big"].particle_spawn_interval=6

data.raw["stream"]["acid-stream-spitter-medium"].spine_animation={layers=helper{chars="➺",x=1,y=1,ftint={{r=0.5,g=1,b=0.3}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["stream"]["acid-stream-spitter-medium"].shadow=nil
data.raw["stream"]["acid-stream-spitter-medium"].particle=nil
data.raw["stream"]["acid-stream-spitter-medium"].particle_spawn_interval=6

data.raw["stream"]["acid-stream-spitter-small"].spine_animation={layers=helper{chars="➺",x=1,y=1,ftint={{r=0.5,g=1,b=0.3}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["stream"]["acid-stream-spitter-small"].shadow=nil
data.raw["stream"]["acid-stream-spitter-small"].particle=nil
data.raw["stream"]["acid-stream-spitter-small"].particle_spawn_interval=6

data.raw["stream"]["acid-stream-worm-behemoth"].spine_animation={layers=helper{chars="➺",x=1,y=1,ftint={{r=0.5,g=1,b=0.3}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["stream"]["acid-stream-worm-behemoth"].shadow=nil
data.raw["stream"]["acid-stream-worm-behemoth"].particle=nil
data.raw["stream"]["acid-stream-worm-behemoth"].particle_spawn_interval=6

data.raw["stream"]["acid-stream-worm-big"].spine_animation={layers=helper{chars="➺",x=1,y=1,ftint={{r=0.5,g=1,b=0.3}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["stream"]["acid-stream-worm-big"].shadow=nil
data.raw["stream"]["acid-stream-worm-big"].particle=nil
data.raw["stream"]["acid-stream-worm-big"].particle_spawn_interval=6

data.raw["stream"]["acid-stream-worm-medium"].spine_animation={layers=helper{chars="➺",x=1,y=1,ftint={{r=0.5,g=1,b=0.3}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["stream"]["acid-stream-worm-medium"].shadow=nil
data.raw["stream"]["acid-stream-worm-medium"].particle=nil
data.raw["stream"]["acid-stream-worm-medium"].particle_spawn_interval=6

data.raw["stream"]["acid-stream-worm-small"].spine_animation={layers=helper{chars="➺",x=1,y=1,ftint={{r=0.5,g=1,b=0.3}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["stream"]["acid-stream-worm-small"].shadow=nil
data.raw["stream"]["acid-stream-worm-small"].particle=nil
data.raw["stream"]["acid-stream-worm-small"].particle_spawn_interval=6



data.raw["stream"]["flamethrower-fire-stream"].spine_animation=nil
data.raw["stream"]["flamethrower-fire-stream"].shadow=nil
data.raw["stream"]["flamethrower-fire-stream"].particle={layers=helper{chars="🔥",x=1,y=1,ftint={{r=1,g=0.3,b=0.3}},btint={{r=0,g=0,b=0,a=0}}}}

data.raw["stream"]["handheld-flamethrower-fire-stream"].spine_animation=nil
data.raw["stream"]["handheld-flamethrower-fire-stream"].shadow=nil
data.raw["stream"]["handheld-flamethrower-fire-stream"].particle={layers=helper{chars="🔥",x=1,y=1,ftint={{r=1,g=0.3,b=0.3}},btint={{r=0,g=0,b=0,a=0}}}}

data.raw["stream"]["tank-flamethrower-fire-stream"].spine_animation=nil
data.raw["stream"]["tank-flamethrower-fire-stream"].shadow=nil
data.raw["stream"]["tank-flamethrower-fire-stream"].particle={layers=helper{chars="🔥",x=1,y=1,ftint={{r=1,g=0.3,b=0.3}},btint={{r=0,g=0,b=0,a=0}}}}

data.raw["sticker"]["acid-sticker-behemoth"].animation={layers=helper{chars="🔥",x=1,y=1,ftint={{r=0.5,g=1,b=0.3}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["sticker"]["acid-sticker-big"].animation={layers=helper{chars="🔥",x=1,y=1,ftint={{r=0.5,g=1,b=0.3}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["sticker"]["acid-sticker-medium"].animation={layers=helper{chars="🔥",x=1,y=1,ftint={{r=0.5,g=1,b=0.3}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["sticker"]["acid-sticker-small"].animation={layers=helper{chars="🔥",x=1,y=1,ftint={{r=0.5,g=1,b=0.3}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["sticker"]["fire-sticker"].animation={layers=helper{chars="🔥",x=1,y=1,ftint={{r=1,g=0.3,b=0.3}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["sticker"]["slowdown-sticker"].animation={layers=helper{chars="🔥",x=1,y=1,ftint={{r=0.3,g=0.3,b=1}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["sticker"]["stun-sticker"].animation={layers=helper{chars="🔥",x=1,y=1,ftint={{r=1,g=1,b=0.3}},btint={{r=0,g=0,b=0,a=0}}}}


data.raw["cliff"]["cliff"].orientations={
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


data.raw["lamp"]["small-lamp"].picture_off={layers=helper{chars="💡",x=1,y=1}}
data.raw["lamp"]["small-lamp"].picture_off={layers=helper{chars="💡",x=1,y=1,ftint={{r=1,g=1,b=1}}}}
data.raw["corpse"]["lamp-remnants"].animation={layers=helper{chars="💡",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}


data.raw["ammo-turret"]["gun-turret"].graphics_set.base_visualisation={
    animation={layers=helper{chars="⚔,t,t,🔫",x=2,y=2,ftint={{r=1,g=0.5,b=1}}}}
}
data.raw["ammo-turret"]["gun-turret"].folded_animation={layers=helper{chars="⚔,t,t,🔫",x=2,y=2,ftint={{r=1,g=0.5,b=1}}}}
data.raw["ammo-turret"]["gun-turret"].preparing_animation=nil
data.raw["ammo-turret"]["gun-turret"].prepared_animation=nil
data.raw["ammo-turret"]["gun-turret"].prepared_alternative_animation=nil
data.raw["ammo-turret"]["gun-turret"].starting_attack_animation=nil
data.raw["ammo-turret"]["gun-turret"].attacking_animation=nil
data.raw["ammo-turret"]["gun-turret"].ending_attack_animation=nil
data.raw["ammo-turret"]["gun-turret"].folding_animation=nil
data.raw["ammo-turret"]["gun-turret"].integration=nil
data.raw["corpse"]["gun-turret-remnants"].animation={layers=helper{chars="⚔,∅,🔫,∅",x=2,y=2,ftint={{r=1,g=0.3,b=0.5}}}}


data.raw["artillery-turret"]["artillery-turret"].base_picture={layers=helper{chars="⚔,t,t,t,t,t,t,t,💣",ftint={{r=1,g=0.5,b=1}}}}
data.raw["artillery-turret"]["artillery-turret"].cannon_base_pictures=nil
data.raw["artillery-turret"]["artillery-turret"].cannon_barrel_pictures={layers=helper{chars="∦,∦",x=1,y=2,ftint={{r=1,g=0.5,b=1}}}}
data.raw["corpse"]["artillery-turret-remnants"].animation={layers=helper{chars="∅,∅,∅,∅,⚔,∅,∅,💣,∅",ftint={{r=1,g=0.3,b=0.5}}}}


data.raw["electric-turret"]["laser-turret"].graphics_set.base_visualisation={
    animation={layers=helper{chars="⚔,⚡,t,⤓",x=2,y=2,ftint={{r=1,g=0.5,b=1}}}}
}
data.raw["electric-turret"]["laser-turret"].folded_animation={layers=helper{chars="⚔,⚡,t,⤓",x=2,y=2,ftint={{r=1,g=0.5,b=1}}}}
data.raw["electric-turret"]["laser-turret"].preparing_animation=nil
data.raw["electric-turret"]["laser-turret"].prepared_animation=nil
data.raw["electric-turret"]["laser-turret"].prepared_alternative_animation=nil
data.raw["electric-turret"]["laser-turret"].starting_attack_animation=nil
data.raw["electric-turret"]["laser-turret"].attacking_animation=nil
data.raw["electric-turret"]["laser-turret"].ending_attack_animation=nil
data.raw["electric-turret"]["laser-turret"].folding_animation=nil
data.raw["electric-turret"]["laser-turret"].integration=nil
data.raw["corpse"]["laser-turret-remnants"].animation={layers=helper{chars="⚔,∅,⤓,∅",x=2,y=2,ftint={{r=1,g=0.3,b=0.5}}}}


data.raw["fluid-turret"]["flamethrower-turret"].graphics_set.base_visualisation={
    animation={
        north={
            layers=helper{chars="⚔,t,t,🔥,⊢,⊣",x=2,y=3,ftint={{r=1,g=0.5,b=1}}}
        },
        south={
            layers=helper{chars="⊢,⊣,⚔,t,t,🔥",x=2,y=3,ftint={{r=1,g=0.5,b=1}}}
        },
        east={
            layers=helper{chars="⊤,⚔,t,⊥,t,🔥",x=3,y=2,ftint={{r=1,g=0.5,b=1}}}
        },
        west={
            layers=helper{chars="⚔,t,⊤,t,🔥,⊥",x=3,y=2,ftint={{r=1,g=0.5,b=1}}}
        }
    }
}

data.raw["fluid-turret"]["flamethrower-turret"].folded_animation={
        north={
            layers=helper{chars="⚔,t,t,🔥,⊢,⊣",x=2,y=3,ftint={{r=1,g=0.5,b=1}}}
        },
        south={
            layers=helper{chars="⊢,⊣,⚔,t,t,🔥",x=2,y=3,ftint={{r=1,g=0.5,b=1}}}
        },
        east={
            layers=helper{chars="⊤,⚔,t,⊥,t,🔥",x=3,y=2,ftint={{r=1,g=0.5,b=1}}}
        },
        west={
            layers=helper{chars="⚔,t,⊤,t,🔥,⊥",x=3,y=2,ftint={{r=1,g=0.5,b=1}}}
        }
}
data.raw["fluid-turret"]["flamethrower-turret"].preparing_animation=nil
data.raw["fluid-turret"]["flamethrower-turret"].prepared_animation=nil
data.raw["fluid-turret"]["flamethrower-turret"].prepared_alternative_animation=nil
data.raw["fluid-turret"]["flamethrower-turret"].starting_attack_animation=nil
data.raw["fluid-turret"]["flamethrower-turret"].attacking_animation=nil
data.raw["fluid-turret"]["flamethrower-turret"].ending_attack_animation=nil
data.raw["fluid-turret"]["flamethrower-turret"].folding_animation=nil
data.raw["fluid-turret"]["flamethrower-turret"].integration=nil

data.raw["fluid-turret"]["flamethrower-turret"].fluid_box.pipe_picture=nil
data.raw["fluid-turret"]["flamethrower-turret"].fluid_box.pipe_covers=nil
data.raw["corpse"]["flamethrower-turret-remnants"].animation={layers=helper{chars="⚔,∅,🔥,∅",x=2,y=2,ftint={{r=1,g=0.3,b=0.5}}}} --should fix later



data.raw["train-stop"]["train-stop"].animations={layers=helper{chars="⛔,🚆,🚆,⛔",x=2,y=2}}
data.raw["train-stop"]["train-stop"].rail_overlay_animations=nil
data.raw["train-stop"]["train-stop"].top_animations={
    north={
        layers=helper{chars="🚧,🚧",x=2,y=1,offx=-2}
    },
    south={
        layers=helper{chars="🚧,🚧",x=2,y=1,offx=2}
    },
    east={
        layers=helper{chars="🚧,🚧",x=1,y=2,offy=-2}
    },
    west={
        layers=helper{chars="🚧,🚧",x=1,y=2,offy=2} --⤫
    }
}
data.raw["corpse"]["train-stop-remnants"].animation={layers=helper{chars="⛔,∅,🚆,∅",x=2,y=2,ftint={{r=1,g=0.3,b=0.5}}}}
data.raw["corpse"]["train-stop-remnants"].animation_overlay=nil


data.raw["rail-signal"]["rail-signal"].ground_picture_set.structure={filename= "__pixeltorio_base_ent__/graphics/tileset/" .. "🚦1" .. ".png",width=resolution,height=resolution,scale=32/resolution,frame_count=4,tint={r=0.75,g=0.75,b=0.75}}
data.raw["rail-signal"]["rail-signal"].ground_picture_set.lights={
    red={light={intensity=1,size=3,color={r=1,g=0.5,b=0.5}}},
    green={light={intensity=1,size=3,color={r=0.5,g=1,b=0.5}}},
    blue={light={intensity=1,size=3,color={r=0.5,g=0.5,b=1}}},
    yellow={light={intensity=1,size=3,color={r=1,g=1,b=0.5}}},
}
data.raw["rail-signal"]["rail-signal"].ground_picture_set.circuit_connector={
    {
        sprites={
            led_red={layers=helper{chars="🚦",x=1,y=1,offx=1,ftint={{r=1,g=0.5,b=0.5}}}},
            led_green={layers=helper{chars="🚦",x=1,y=1,offx=1,ftint={{r=0.5,g=1,b=0.5}}}},
            led_blue={layers=helper{chars="🚦",x=1,y=1,offx=1,ftint={{r=0.5,g=0.5,b=1}}}},
            led_light={intensity=1,size=1}
        },
        points={
            wire={copper={0,0},red={-0.2,-0.2},green={0.2,0.2}},
            shadow={copper={0,0},red={-0.2,-0.2},green={0.2,0.2}}
        }
    }
}
data.raw["rail-signal"]["rail-signal"].ground_picture_set.rail_piece=nil  --you can't easily distinguish which rail the signal is from in corners, should fix
data.raw["rail-signal"]["rail-signal"].ground_picture_set.structure_align_to_animation_index={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
data.raw["rail-signal"]["rail-signal"].ground_picture_set.signal_color_to_structure_frame_index={green=1,yellow=2,red=0,blue=3,none=4}

data.raw["corpse"]["rail-signal-remnants"].animation={layers=helper{chars="🚦",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}




data.raw["rail-chain-signal"]["rail-chain-signal"].ground_picture_set.structure={filename= "__pixeltorio_base_ent__/graphics/tileset/" .. "⏱1" .. ".png",width=resolution,height=resolution,scale=32/resolution,frame_count=4,tint={r=0.75,g=0.75,b=0.75}}
data.raw["rail-chain-signal"]["rail-chain-signal"].ground_picture_set.lights={
    red={light={intensity=1,size=3,color={r=1,g=0.5,b=0.5}}},
    green={light={intensity=1,size=3,color={r=0.5,g=1,b=0.5}}},
    blue={light={intensity=1,size=3,color={r=0.5,g=0.5,b=1}}},
    yellow={light={intensity=1,size=3,color={r=1,g=1,b=0.5}}},
}
data.raw["rail-chain-signal"]["rail-chain-signal"].ground_picture_set.circuit_connector={
    {
        sprites={
            led_red={layers=helper{chars="⏱",x=1,y=1,offx=1,ftint={{r=1,g=0.5,b=0.5}}}},
            led_green={layers=helper{chars="⏱",x=1,y=1,offx=1,ftint={{r=0.5,g=1,b=0.5}}}},
            led_blue={layers=helper{chars="⏱",x=1,y=1,offx=1,ftint={{r=0.5,g=0.5,b=1}}}},
            led_light={intensity=1,size=1}
        },
        points={
            wire={copper={0,0},red={-0.2,-0.2},green={0.2,0.2}},
            shadow={copper={0,0},red={-0.2,-0.2},green={0.2,0.2}}
        }
    }
}
data.raw["rail-chain-signal"]["rail-chain-signal"].ground_picture_set.rail_piece=nil --you can't easily distinguish which rail the signal is from in corners, should fix
data.raw["rail-chain-signal"]["rail-chain-signal"].ground_picture_set.structure_align_to_animation_index={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
data.raw["rail-chain-signal"]["rail-chain-signal"].ground_picture_set.signal_color_to_structure_frame_index={green=1,yellow=2,red=0,blue=3,none=4}

data.raw["corpse"]["rail-chain-signal-remnants"].animation={layers=helper{chars="🚦",x=1,y=1,ftint={{r=1,g=0.3,b=0.5}}}}


data.raw["cargo-wagon"]["cargo-wagon"].pictures={rotated={layers=helper{chars="w,w,w,w,w,w,w,w,w,w,w,w",x=6,y=2,offx=-2,offy=-0.5}}}
data.raw["corpse"]["cargo-wagon-remnants"].animation={layers=helper{chars="w,w,w,w,w,w,∅,∅,∅,∅,∅,∅",x=6,y=2,offx=-2,offy=-0.5,ftint={{r=1,g=0.3,b=0.5}}}}


data.raw["fish"]["fish"].pictures={sheet={layers=helper{chars="🐟",x=1,y=1,btint={{r=0,g=0,b=0,a=0}}}}}



data.raw["tile"]["water"].variants={
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
data.raw["tile"]["water"].tint={r=0.5,g=0.5,b=1}
data.raw["tile"]["water"].effect=nil

data.raw["tile"]["deepwater"].variants={
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
data.raw["tile"]["deepwater"].tint={r=0.3,g=0.3,b=1,a=1}
data.raw["tile"]["deepwater"].effect=nil

data.raw["tile"]["water-green"].variants={
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
data.raw["tile"]["water-green"].tint={r=0.5,g=1,b=1,a=1}
data.raw["tile"]["water-green"].effect=nil


data.raw["tile"]["deepwater-green"].variants={
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
data.raw["tile"]["deepwater-green"].tint={r=0.3,g=1,b=1,a=1}
data.raw["tile"]["deepwater-green"].effect=nil


data.raw["tile"]["water-shallow"].variants={
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
data.raw["tile"]["water-shallow"].tint={r=0.75,g=0.75,b=1,a=1}
data.raw["tile"]["water-shallow"].effect=nil

data.raw["tile"]["water-mud"].variants={
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
data.raw["tile"]["water-mud"].tint={r=0.5,g=0.6,b=0.8}
data.raw["tile"]["water-mud"].effect=nil

dirtcount=1
dirtcolors={{r=0.025,g=0,b=0},{r=0.025,g=0.025,b=0},{r=0,g=0.025,b=0},{r=0.05,g=0,b=0},{r=0.05,g=0.05,b=0},{r=0,g=0.05,b=0},{r=0.075,g=0.05,b=0},{r=0.075,g=0.05,b=0}}
for dirtname,dirttable in pairs(data.raw["tile"]) do
    if string.find(dirtname,".*dirt.*") ~= nil then
        dirttable.variants={
            empty_transitions=true,
            main={
                {
                size=1,
                count=1,
                picture="__pixeltorio_base_ent__/graphics/tileset/" .. "background" .. ".png"
                }
            },
            material_texture_width_in_tiles=1,
            material_texture_height_in_tiles=1,
            material_background={
                count=1,
                picture="__pixeltorio_base_ent__/graphics/tileset/" .. "background" .. ".png"
            }
        }
        dirttable.effect = nil
        dirttable.tint = dirtcolors[dirtcount]
        dirtcount = dirtcount+1
    end
end


grasscount=1
grasscolors={{r=0,g=0.075,b=0},{r=0.05,g=0.075,b=0},{r=0,g=0.075,b=0.03},{r=0,g=0.05,b=0}}
for grassname,grasstable in pairs(data.raw["tile"]) do
    if string.find(grassname,".*grass.*") ~= nil then
        grasstable.variants={
            empty_transitions=true,
            main={
                {
                size=1,
                count=1,
                picture="__pixeltorio_base_ent__/graphics/tileset/" .. "background" .. ".png"
                }
            },
            material_texture_width_in_tiles=1,
            material_texture_height_in_tiles=1,
            material_background={
                count=1,
                picture="__pixeltorio_base_ent__/graphics/tileset/" .. "background" .. ".png"
            }
        }
        grasstable.effect = nil
        grasstable.tint = grasscolors[grasscount]
        grasscount = grasscount+1
    end
end

desertcount=1
desertcolors={{r=0.075,g=0,b=0},{r=0.075,g=0.05,b=0},{r=0.075,g=0,b=0.03},{r=0.075,g=0,b=0}}
for desertname,deserttable in pairs(data.raw["tile"]) do
    if string.find(desertname,".*desert.*") ~= nil then
        deserttable.variants={
            empty_transitions=true,
            main={
                {
                size=1,
                count=1,
                picture="__pixeltorio_base_ent__/graphics/tileset/" .. "background" .. ".png"
                }
            },
            material_texture_width_in_tiles=1,
            material_texture_height_in_tiles=1,
            material_background={
                count=1,
                picture="__pixeltorio_base_ent__/graphics/tileset/" .. "background" .. ".png"
            }
        }
        deserttable.effect = nil
        deserttable.tint = desertcolors[desertcount]
        desertcount = desertcount+1
    end
end


sandcount=1
sandcolors={{r=0.05,g=0.05,b=0},{r=0.05,g=0.035,b=0},{r=0.05,g=0.05,b=0.015},{r=0.035,g=0.05,b=0}}
for sandname,sandtable in pairs(data.raw["tile"]) do
    if string.find(sandname,".*sand.*") ~= nil then
        sandtable.variants={
            empty_transitions=true,
            main={
                {
                size=1,
                count=1,
                picture="__pixeltorio_base_ent__/graphics/tileset/" .. "background" .. ".png"
                }
            },
            material_texture_width_in_tiles=1,
            material_texture_height_in_tiles=1,
            material_background={
                count=1,
                picture="__pixeltorio_base_ent__/graphics/tileset/" .. "background" .. ".png"
            }
        }
        sandtable.effect = nil
        sandtable.tint = sandcolors[sandcount]
        sandcount = sandcount+1
    end
end




data.raw["tile"]["water-shallow"].variants={
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
data.raw["tile"]["water-shallow"].tint={r=0.75,g=0.75,b=1,a=1}
data.raw["tile"]["water-shallow"].effect=nil

data.raw["tile"]["water-wube"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "wubewater" .. ".png"
        }
    },
    material_texture_width_in_tiles=3,
    material_texture_height_in_tiles=3,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "wubewater" .. ".png"
    }
}
data.raw["tile"]["water-wube"].tint=nil
data.raw["tile"]["water-wube"].effect=nil


data.raw["tile"]["stone-path"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "⡪" .. ".png"
        }
    },
    material_texture_width_in_tiles=1,
    material_texture_height_in_tiles=1,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "⡪" .. ".png"
    }
}
data.raw["tile"]["stone-path"].tint={r=0.87,g=0.87,b=0.63}
data.raw["tile"]["stone-path"].effect=nil


data.raw["tile"]["landfill"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▦" .. ".png"
        }
    },
    material_texture_width_in_tiles=1,
    material_texture_height_in_tiles=1,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▦" .. ".png"
    }
}
data.raw["tile"]["landfill"].tint={r=0.2,g=0.2,b=0}
data.raw["tile"]["landfill"].effect=nil


data.raw["tile"]["concrete"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "⊡" .. ".png"
        }
    },
    material_texture_width_in_tiles=1,
    material_texture_height_in_tiles=1,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "⊡" .. ".png"
    }
}
data.raw["tile"]["concrete"].tint={r=0.2,g=0.2,b=0.2}
data.raw["tile"]["concrete"].effect=nil


data.raw["tile"]["hazard-concrete-right"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▨" .. ".png"
        }
    },
    material_texture_width_in_tiles=1,
    material_texture_height_in_tiles=1,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▨" .. ".png"
    }
}
data.raw["tile"]["hazard-concrete-right"].tint={r=0.4,g=0.4,b=0.1}
data.raw["tile"]["hazard-concrete-right"].effect=nil


data.raw["tile"]["hazard-concrete-left"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▧" .. ".png"
        }
    },
    material_texture_width_in_tiles=1,
    material_texture_height_in_tiles=1,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▧" .. ".png"
    }
}
data.raw["tile"]["hazard-concrete-left"].tint={r=0.4,g=0.4,b=0.1}
data.raw["tile"]["hazard-concrete-left"].effect=nil


data.raw["tile"]["refined-concrete"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▣" .. ".png"
        }
    },
    material_texture_width_in_tiles=1,
    material_texture_height_in_tiles=1,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▣" .. ".png"
    }
}
data.raw["tile"]["refined-concrete"].tint={r=0.2,g=0.2,b=0.2}
data.raw["tile"]["refined-concrete"].effect=nil


data.raw["tile"]["refined-hazard-concrete-right"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▨" .. ".png"
        }
    },
    material_texture_width_in_tiles=1,
    material_texture_height_in_tiles=1,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▨" .. ".png"
    }
}
data.raw["tile"]["refined-hazard-concrete-right"].tint={r=0.4,g=0.4,b=0.1}
data.raw["tile"]["refined-hazard-concrete-right"].effect=nil


data.raw["tile"]["refined-hazard-concrete-left"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▧" .. ".png"
        }
    },
    material_texture_width_in_tiles=1,
    material_texture_height_in_tiles=1,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▧" .. ".png"
    }
}
data.raw["tile"]["refined-hazard-concrete-left"].tint={r=0.4,g=0.4,b=0.1}
data.raw["tile"]["refined-hazard-concrete-left"].effect=nil


data.raw["tile"]["red-refined-concrete"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▣" .. ".png"
        }
    },
    material_texture_width_in_tiles=1,
    material_texture_height_in_tiles=1,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▣" .. ".png"
    }
}
data.raw["tile"]["red-refined-concrete"].tint={r=0.4,g=0.2,b=0.2}
data.raw["tile"]["red-refined-concrete"].effect=nil

data.raw["tile"]["orange-refined-concrete"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▣" .. ".png"
        }
    },
    material_texture_width_in_tiles=1,
    material_texture_height_in_tiles=1,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▣" .. ".png"
    }
}
data.raw["tile"]["orange-refined-concrete"].tint={r=0.4,g=0.3,b=0.2}
data.raw["tile"]["orange-refined-concrete"].effect=nil


data.raw["tile"]["yellow-refined-concrete"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▣" .. ".png"
        }
    },
    material_texture_width_in_tiles=1,
    material_texture_height_in_tiles=1,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▣" .. ".png"
    }
}
data.raw["tile"]["yellow-refined-concrete"].tint={r=0.4,g=0.4,b=0.2}
data.raw["tile"]["yellow-refined-concrete"].effect=nil


data.raw["tile"]["acid-refined-concrete"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▣" .. ".png"
        }
    },
    material_texture_width_in_tiles=1,
    material_texture_height_in_tiles=1,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▣" .. ".png"
    }
}
data.raw["tile"]["acid-refined-concrete"].tint={r=0.3,g=0.4,b=0.2}
data.raw["tile"]["acid-refined-concrete"].effect=nil


data.raw["tile"]["green-refined-concrete"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▣" .. ".png"
        }
    },
    material_texture_width_in_tiles=1,
    material_texture_height_in_tiles=1,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▣" .. ".png"
    }
}
data.raw["tile"]["green-refined-concrete"].tint={r=0.2,g=0.4,b=0.2}
data.raw["tile"]["green-refined-concrete"].effect=nil



data.raw["tile"]["cyan-refined-concrete"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▣" .. ".png"
        }
    },
    material_texture_width_in_tiles=1,
    material_texture_height_in_tiles=1,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▣" .. ".png"
    }
}
data.raw["tile"]["cyan-refined-concrete"].tint={r=0.2,g=0.4,b=0.4}
data.raw["tile"]["cyan-refined-concrete"].effect=nil


data.raw["tile"]["blue-refined-concrete"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▣" .. ".png"
        }
    },
    material_texture_width_in_tiles=1,
    material_texture_height_in_tiles=1,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▣" .. ".png"
    }
}
data.raw["tile"]["blue-refined-concrete"].tint={r=0.2,g=0.2,b=0.4}
data.raw["tile"]["blue-refined-concrete"].effect=nil


data.raw["tile"]["purple-refined-concrete"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▣" .. ".png"
        }
    },
    material_texture_width_in_tiles=1,
    material_texture_height_in_tiles=1,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▣" .. ".png"
    }
}
data.raw["tile"]["purple-refined-concrete"].tint={r=0.3,g=0.2,b=0.4}
data.raw["tile"]["purple-refined-concrete"].effect=nil


data.raw["tile"]["pink-refined-concrete"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▣" .. ".png"
        }
    },
    material_texture_width_in_tiles=1,
    material_texture_height_in_tiles=1,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▣" .. ".png"
    }
}
data.raw["tile"]["pink-refined-concrete"].tint={r=0.4,g=0.2,b=0.3}
data.raw["tile"]["pink-refined-concrete"].effect=nil


data.raw["tile"]["black-refined-concrete"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▣" .. ".png"
        }
    },
    material_texture_width_in_tiles=1,
    material_texture_height_in_tiles=1,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▣" .. ".png"
    }
}
data.raw["tile"]["black-refined-concrete"].tint={r=0.75,g=0.75,b=0.75}
data.raw["tile"]["black-refined-concrete"].effect=nil


data.raw["tile"]["brown-refined-concrete"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▣" .. ".png"
        }
    },
    material_texture_width_in_tiles=1,
    material_texture_height_in_tiles=1,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "▣" .. ".png"
    }
}
data.raw["tile"]["brown-refined-concrete"].tint={r=0.3,g=0.2,b=0.2}
data.raw["tile"]["brown-refined-concrete"].effect=nil


data.raw["tile"]["nuclear-ground"].variants={
    empty_transitions=true,
    main={
        {
        size=1,
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "☠" .. ".png"
        }
    },
    material_texture_width_in_tiles=1,
    material_texture_height_in_tiles=1,
    material_background={
        count=1,
        picture="__pixeltorio_base_ent__/graphics/tileset/" .. "☠" .. ".png"
    }
}
data.raw["tile"]["nuclear-ground"].tint={r=0.2,g=0.6,b=0.2}
data.raw["tile"]["nuclear-ground"].effect=nil




data.raw["container"]["factorio-logo-11tiles"].picture={layers=helper{chars="P,i,x,e,l,t,o,r,i,⚙,8",x=11,y=1,ftint={{r=1,g=0.5,b=0}}}}




for particlename,particletable in pairs(data.raw["optimized-particle"]) do
    if string.find(particlename,".*-.*") ~= nil then --will match everything
        particletable.pictures={
            sheets=helper{chars="·1",x=1,y=1,ftint={{r=0.25,g=0.25,b=0.25}},btint={{r=0,g=0,b=0,a=0}}}
        }
        particletable.shadows=nil
    end
end

for particlename,particletable in pairs(data.raw["particle-source"]) do
    if string.find(particlename,".*blood.*") ~= nil then --will match everything
        particletable.pictures={
            sheets=helper{chars="💧",x=1,y=1,ftint={{r=0.25,g=0.25,b=0.25}},btint={{r=0,g=0,b=0,a=0}}}
        }
        particletable.shadows=nil
    end
end


data.raw["projectile"]["grenade"].animation={layers=helper{chars="💣",x=1,y=1,btint={{r=0,g=0,b=0,a=0}}}}
data.raw["projectile"]["cluster-grenade"].animation={layers=helper{chars="💣",x=1,y=1,ftint={{r=1,g=0.5,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["projectile"]["cliff-explosives"].animation={layers=helper{chars="💣",x=1,y=1,ftint={{r=0.5,g=1,b=1}},btint={{r=0,g=0,b=0,a=0}}}}

data.raw["projectile"]["defender-capsule"].animation={layers=helper{chars="◒",x=1,y=1,ftint={{r=0.5,g=1,b=1}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["projectile"]["destroyer-capsule"].animation={layers=helper{chars="◒",x=1,y=1,ftint={{r=1,g=0.5,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["projectile"]["distractor-capsule"].animation={layers=helper{chars="◒",x=1,y=1,ftint={{r=1,g=1,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["projectile"]["poison-capsule"].animation={layers=helper{chars="◒",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["projectile"]["slowdown-capsule"].animation={layers=helper{chars="◒",x=1,y=1,ftint={{r=0.5,g=0.5,b=1}},btint={{r=0,g=0,b=0,a=0}}}}

data.raw["projectile"]["rocket"].animation={layers=helper{chars="🚀",x=1,y=1,btint={{r=0,g=0,b=0,a=0}}}}
data.raw["projectile"]["explosive-rocket"].animation={layers=helper{chars="🚀",x=1,y=1,ftint={{r=1,g=0.5,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["projectile"]["atomic-rocket"].animation={layers=helper{chars="🚀",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}

data.raw["projectile"]["cannon-projectile"].animation={layers=helper{chars="💣",x=1,y=1,btint={{r=0,g=0,b=0,a=0}}}}
data.raw["projectile"]["explosive-cannon-projectile"].animation={layers=helper{chars="💣",x=1,y=1,ftint={{r=1,g=0.5,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["projectile"]["explosive-uranium-cannon-projectile"].animation={layers=helper{chars="💣",x=1,y=1,ftint={{r=0.75,g=1,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["projectile"]["uranium-cannon-projectile"].animation={layers=helper{chars="💣",x=1,y=1,ftint={{r=0.5,g=1,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}

data.raw["projectile"]["shotgun-pellet"].animation={layers=helper{chars="·",x=1,y=1,btint={{r=0,g=0,b=0,a=0}}}}
data.raw["projectile"]["piercing-shotgun-pellet"].animation={layers=helper{chars="·",x=1,y=1,ftint={{r=1,g=0.5,b=0.5}},btint={{r=0,g=0,b=0,a=0}}}}


data.raw["car"]["car"].animation={layers=helper{chars="C,C,☸,☸",x=2,y=2,ftint={{r=1,g=1,b=1}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["car"]["car"].light_animation=nil
data.raw["corpse"]["car-remnants"].animation={layers=helper{chars="C,∅,☸,∅",x=2,y=2,ftint={{r=1,g=0.3,b=0.5}}}}

data.raw["car"]["tank"].animation={layers=helper{chars="T,T,T,T,☸,☸",x=2,y=3,ftint={{r=1,g=1,b=1}},btint={{r=0,g=0,b=0,a=0}}}}
data.raw["car"]["tank"].light_animation=nil
data.raw["corpse"]["tank-remnants"].animation={layers=helper{chars="T,∅,T,∅,☸,∅",x=2,y=3,ftint={{r=1,g=0.3,b=0.5}}}}



for legname,legtable in pairs(data.raw["spider-leg"]) do
    if string.find(legname,".*spidertron.*") ~= nil then
        legtable.graphics_set={
            upper_part={middle={layers=helper{chars="↥",x=1,y=1,ftint={{r=1,g=1,b=1}},btint={{r=0,g=0,b=0,a=0}}}}},
            lower_part={middle={layers=helper{chars="↧",x=1,y=1,ftint={{r=1,g=1,b=1}},btint={{r=0,g=0,b=0,a=0}}}}},
        }
    end
end



data.raw["spider-vehicle"]["spidertron"].graphics_set={
    animation={
        layers=helper{chars="🕷",x=1,y=1,ftint={{r=1,g=1,b=1}},btint={{r=0,g=0,b=0,a=0}},cres=16}
    }
}
