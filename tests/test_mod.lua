---Executes the mod with a strict stand-in for the documented Foundation API.
---Run from the repository root with: lua tests/test_mod.lua

local expectedTargets = {
    NAME_LIST_ENGLISH = true,
    NAME_LIST_FRENCH = true,
    NAME_LIST_GERMAN = true,
    NAME_LIST_ITALIAN = true,
    NAME_LIST_NORSE = true,
    NAME_LIST_PLAYER = true,
    NAME_LIST_SPANISH = true,
    NAME_LIST_VILLAGE = true,
}

---Builds all permitted full names independently from the source data.
---@param firstNames table Gender-specific first names.
---@param gender string Nickname pool key.
---@param article string Gender-specific article.
---@return table allowed Set of permitted full names.
local function permittedNames(firstNames, gender, article)
    local pools = dofile("scripts/name_data/nicknames.lua")
    local allowed = {}
    for _, firstName in ipairs(firstNames) do
        for _, poolName in ipairs({gender, "common", "noPrefix"}) do
            for _, nickname in ipairs(pools[poolName]) do
                local prefix = ""
                if poolName ~= "noPrefix" then
                    prefix = article .. " "
                end
                allowed[firstName .. " " .. prefix .. nickname] = true
            end
        end
    end
    return allowed
end

local permittedMale = permittedNames(dofile("scripts/name_data/male_names.lua"), "male", "der")
local permittedFemale = permittedNames(dofile("scripts/name_data/female_names.lua"), "female", "die")

---Checks the size, contents, and dense string-list shape expected by NAME_LIST.
---@param names table Generated list.
---@param allowed table Set of permitted full names.
local function checkNames(names, allowed)
    assert(type(names) == "table" and #names == 5000, "Expected 5000 names per gender")
    local count = 0
    for key, name in pairs(names) do
        assert(type(key) == "number" and key % 1 == 0 and key >= 1 and key <= 5000)
        assert(type(name) == "string" and allowed[name], "Invalid generated name: " .. tostring(name))
        count = count + 1
    end
    assert(count == 5000)
end

---Loads the real entry point and validates every asset override it submits.
local function checkEntryPoint()
    local seen = {}
    local mod = {}

    ---Loads a mod-relative Lua file with the mod instance as its argument.
    function mod:dofile(path)
        return assert(loadfile(path))(self)
    end

    ---Rejects unknown IDs, unexpected properties, and malformed name lists.
    function mod:overrideAsset(asset)
        assert(expectedTargets[asset.Id], "Unknown NAME_LIST asset: " .. tostring(asset.Id))
        assert(not seen[asset.Id], "Duplicate override: " .. asset.Id)
        for key in pairs(asset) do
            assert(key == "Id" or key == "MaleNameList" or key == "FemaleNameList")
        end
        checkNames(asset.MaleNameList, permittedMale)
        checkNames(asset.FemaleNameList, permittedFemale)
        seen[asset.Id] = true
    end

    foundation = {}
    ---Returns the test mod instance through Foundation's entry-point API.
    function foundation.createMod()
        return mod
    end

    dofile("mod.lua")
    for id in pairs(expectedTargets) do
        assert(seen[id], "Missing override: " .. id)
    end
end

math.randomseed(42)
checkEntryPoint()

local originalRandom = math.random
---Selects the first pool entry to exercise the lower random-index boundary.
function math.random(upper)
    assert(upper > 0)
    return 1
end
checkEntryPoint()

---Selects the last pool entry to exercise the upper random-index boundary.
function math.random(upper)
    assert(upper > 0)
    return upper
end
checkEntryPoint()
math.random = originalRandom

print("Passed: entry point, eight overrides, 5000 names per gender, gender pools, index boundaries")
