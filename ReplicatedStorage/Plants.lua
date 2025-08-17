-- Plants.lua
-- ModuleScript for plant data and functions

local Plants = {}

-- Plant types and their properties
Plants.Types = {
    ["Brainrot"] = {
        Name = "Brainrot",
        GrowthTime = 30,
        Value = 10,
        Model = "BrainrotPlant"
    },
    ["MegaBrainrot"] = {
        Name = "MegaBrainrot",
        GrowthTime = 60,
        Value = 25,
        Model = "MegaBrainrotPlant"
    }
}

-- Get plant data
function Plants.GetPlantData(plantType)
    return Plants.Types[plantType]
end

-- Get all plant types
function Plants.GetAllTypes()
    local types = {}
    for plantType, _ in pairs(Plants.Types) do
        table.insert(types, plantType)
    end
    return types
end

return Plants
