local fuledvehiclesHelper = require "celmi/fuledVehicles/fuledvehicles_helper"

function data()
    return {
        handleEvent = function (_, id, name, param)
            if id == "SimCargoSystem" and name == "OnToArriveAtDestination" then
                local cargo = fuledvehiclesHelper.getCargoObject(param)
                local target = fuledvehiclesHelper.getConstructionObject(cargo.targetEntity)
                print("cargo arrived at:", target.fileName)
            end
        end
    }
end