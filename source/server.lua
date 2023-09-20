local function init()
    if not _VERSION:find("5.4") then
        return error("LUA 5.4 Must be enabled, Please don't remove it!")
    end

    if table.type(config) == "empty" or config == nil then
        return error("Config returned broken or empty, please make sure it is proper.")
    end

    print("spoodyBus started successfully!")
end

---@param source number
lib.callback.register("spoodyBus:FetchCash", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    return xPlayer.getMoney()
end)

---@param price number
RegisterNetEvent("spoodyBus:pay", function(price)
    local source <const> = source
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeAccountMoney('money', price)
end)

CreateThread(init)
