local fuledvehiclesHelper = require "celmi/fuledVehicles/fuledvehicles_helper"

local resourceStorage = {
    coal = 0,
    diesel = 0,
    electricity = 0,
    coalCapacity = 500,
    dieselCapacity = 500,
    electricityCapacity = 500,
}

local resourceConsumer = {
    ["coal"] = {
        "industry/fuelStation/trainCoalFuelStation_1.con",
    },
    ["diesel"] = {
        "industry/fuelStation/trainDieselFuelStation_1.con",
    },
    ["electricity"] = {
        "industry/powerPlant/coalPowerPlant_1.con",
        "industry/powerPlant/dieselPowerPlant_1.con"
    },
}

local recourceIndicator = nil

local function contains(arr,val)
    for _,v in pairs(arr) do
        if v == val then return true end
    end
    return false
end

function data()
    return {
        handleEvent = function (_, id, name, param)
            if id == "SimCargoSystem" and name == "OnToArriveAtDestination" then
                local cargo = fuledvehiclesHelper.getCargoObject(param)
                local target = fuledvehiclesHelper.getConstructionObject(cargo.targetEntity)
                for k,v in pairs(resourceConsumer) do
                    if contains(v, target.fileName) then
                        local capacityKey = k .. "Capacity"
                        if resourceStorage[capacityKey] and resourceStorage[k] and resourceStorage[k] < resourceStorage[capacityKey] then
                            resourceStorage[k] = resourceStorage[k] + 1
                        end
                    end
                end

            end
        end,

        save = function()
            return resourceStorage
        end,

        load = function(loadedState)
            resourceStorage = loadedState or {coal = 0,diesel = 0,electricity = 0,coalCapacity = 500,dieselCapacity = 500,electricityCapacity = 500,}
        end,

        guiUpdate = function()

            if not recourceIndicator then
                recourceIndicator = {coal = nil,diesel = nil, electricity = nil}
				local line = api.gui.comp.Component.new("VerticalLine")
                local line2 = api.gui.comp.Component.new("VerticalLine")
                local iconCoal = api.gui.comp.ImageView.new("ui/hud/cargo_coal.tga")
                local iconDiesel = api.gui.comp.ImageView.new("ui/hud/cargo_fuel.tga")
                local iconElectricity = api.gui.comp.ImageView.new("ui/button/large/rail_electricity.tga")

				recourceIndicator.coal = api.gui.comp.TextView.new("recourceIndicator.coal")
                recourceIndicator.diesel = api.gui.comp.TextView.new("recourceIndicator.diesel")
                recourceIndicator.electricity = api.gui.comp.TextView.new("recourceIndicator.electricity")

				local gameInfoLayout = api.gui.util.getById("gameInfo"):getLayout()
				gameInfoLayout:addItem(line)
				gameInfoLayout:addItem(iconCoal)
				gameInfoLayout:addItem(recourceIndicator.coal)
                gameInfoLayout:addItem(iconDiesel)
                gameInfoLayout:addItem(recourceIndicator.diesel)
                gameInfoLayout:addItem(iconElectricity)
                gameInfoLayout:addItem(recourceIndicator.electricity)
                gameInfoLayout:addItem(line2)
            end


            if recourceIndicator then
                recourceIndicator.coal:setText(tostring(resourceStorage.coal))
                recourceIndicator.diesel:setText(tostring(resourceStorage.diesel))
                recourceIndicator.electricity:setText(tostring(resourceStorage.electricity))
            end
        end
    }
end