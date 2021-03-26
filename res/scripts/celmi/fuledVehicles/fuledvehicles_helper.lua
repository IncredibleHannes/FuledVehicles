local lib = {}

function lib.getCargoObject(id)
    return game.interface.getEntity(id)
end

function lib.getConstructionObject(id)
    return game.interface.getEntity(id)
end


return lib