local mod = ...

local nicknames = mod:dofile("scripts/name_data/nicknames.lua")
local maleFirstNames = mod:dofile("scripts/name_data/male_names.lua")
local femaleFirstNames = mod:dofile("scripts/name_data/female_names.lua")

local GENERATED_NAME_COUNT = 5000

local TARGET_NAME_LISTS = {
    "NAME_LIST_ENGLISH",
    "NAME_LIST_FRENCH",
    "NAME_LIST_GERMAN",
    "NAME_LIST_ITALIAN",
    "NAME_LIST_NORSE",
    "NAME_LIST_PLAYER",
    "NAME_LIST_SPANISH",
    "NAME_LIST_VILLAGE",
}

---Combines gendered, common, and prefix-free nickname pools into one list.
---@param genderedNicknames table List of gender-specific nicknames.
---@param commonNicknames table List of shared adjective-style nicknames.
---@param noPrefixNicknames table List of nicknames that stand without an article.
---@param prefix string Article prepended to gendered and common nicknames.
---@return table nicknames Combined nickname list.
local function combineNicknames(genderedNicknames, commonNicknames, noPrefixNicknames, prefix)
    local combinedNicknames = {}

    for i = 1, #genderedNicknames do
        table.insert(combinedNicknames, prefix .. " " .. genderedNicknames[i])
    end

    for i = 1, #commonNicknames do
        table.insert(combinedNicknames, prefix .. " " .. commonNicknames[i])
    end

    for i = 1, #noPrefixNicknames do
        table.insert(combinedNicknames, noPrefixNicknames[i])
    end

    return combinedNicknames
end

---Builds random full names from first names and nicknames.
---@param firstNames table List of first names.
---@param nicknamePool table List of already formatted nicknames.
---@param count number Number of generated names.
---@return table names Generated full names.
local function buildGeneratedNames(firstNames, nicknamePool, count)
    local names = {}

    for i = 1, count do
        local nicknameIndex = math.random(#nicknamePool)
        local firstNameIndex = math.random(#firstNames)
        table.insert(names, firstNames[firstNameIndex] .. " " .. nicknamePool[nicknameIndex])
    end

    return names
end

---Builds the male and female name lists used by Foundation NAME_LIST assets.
---@return table maleNames Generated masculine villager names.
---@return table femaleNames Generated feminine villager names.
local function buildNameLists()
    local femaleNicknames = combineNicknames(nicknames.female, nicknames.common, nicknames.noPrefix, "die")
    local maleNicknames = combineNicknames(nicknames.male, nicknames.common, nicknames.noPrefix, "der")

    return buildGeneratedNames(maleFirstNames, maleNicknames, GENERATED_NAME_COUNT),
        buildGeneratedNames(femaleFirstNames, femaleNicknames, GENERATED_NAME_COUNT)
end

local maleNames, femaleNames = buildNameLists()

for i = 1, #TARGET_NAME_LISTS do
    mod:overrideAsset({
        Id = TARGET_NAME_LISTS[i],
        MaleNameList = maleNames,
        FemaleNameList = femaleNames,
    })
end

return {
    buildNameLists = buildNameLists,
    targetNameLists = TARGET_NAME_LISTS,
}
