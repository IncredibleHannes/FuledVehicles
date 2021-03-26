
local fuledVehiclesTests = {}

fuledVehiclesTests[#fuledVehiclesTests + 1] = function()
    print("Hallo World")
end

return {
    test = function()
        for k,v in pairs(fuledVehiclesTests) do
            print("Running test: " .. tostring(k))
            v()
        end
    end
}
