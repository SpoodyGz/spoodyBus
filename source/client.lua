---@author Spoody
local index = nil

---@param args table
local function confirm(args)
    TriggerServerEvent("spoodyBus:pay", args.price)

    local ped <const> = PlayerPedId()
    local location <const> = args.location

    if lib.progressCircle({
        duration = config.settings.wait,
        position = 'middle',
        useWhileDead = false,
        label = 'Waiting for the bus...',
        canCancel = false,
        disable = {
            move = true,
        },
        anim = {
            dict = 'anim@heists@heist_corona@team_idles@male_a',
            clip = 'idle'
        },
    }) 
    
    then 
        DoScreenFadeOut(500)
        Wait(500)
        SetEntityCoords(ped, args.location)
        Wait(1000)
        DoScreenFadeIn(1500)
        config.notify("You have travelled to " ..args.label.. "!")
    end

end

---@param args table
local function attempt(args)
    if table.type(args) == "empty" or args == nil then
        return error("Something went wrong :/")
    end

    local cash = lib.callback.await("spoodyBus:FetchCash")

    if cash then
        if tonumber(cash) >= args.price then
            confirm(args)
        else 
            config.notify("You don't have enough cash.")
        end
    end
end

---@param index string
local function interact(index)
    local options = {}

    if index ~= nil then
        lib.hideTextUI()

        for key, value in pairs(config.locations) do
            table.insert(options, {
                title = key.. " - $" ..value.price,
                event = "confirm",
                args = {
                    location = value.location,
                    price = value.price,
                    label = key,
                }
            })
        end

        lib.registerContext({
            id = 'bus',
            title = index,
            options = options
        })

        lib.showContext('bus')
    else 
        return error("Something went wrong :/") 
    end
end

local function init()
    if table.type(config) == "empty" or config == nil then
        return error("Your config is broken, fix it!")
    end

    for key, value in next, config.locations do

        local stops = lib.points.new({
            coords = value.location,
            distance = tonumber(config.settings.distance)
        })

        function stops:onEnter()
            index = key

            lib.showTextUI(tostring(config.settings.inform), {
                position = 'right-center',
            })
        end

        function stops:onExit()
            index = nil

            lib.hideTextUI()
        end

        function stops:nearby()
            if IsControlJustPressed(0, 38) then
                if not IsPedInAnyVehicle(PlayerPedId(), false) then
                    interact(key)
                else
                    config.notify("You cannot use the bus stop whilst in a vehicle!")
                end
            end
        end
    end
end

---@param args table | location, price
RegisterNetEvent("confirm", function(args)
    if args.label ~= index then
        local alert <const> = lib.alertDialog({
            header = 'Travel to ' ..args.label.. "?",
            content = 'Would you like to purchase a $' ..args.price.. " bus ticket to " ..args.label.. "?",
            centered = true,
            cancel = true, 
            labels = {confirm = "Yes", cancel = "No"}
        })

        if alert == "confirm" then
            attempt(args)
        end
    else 
        config.notify("You are already at this location!")
    end
end)

CreateThread(init)
