local function get()
    ESX = exports['es_extended']:getSharedObject()

    if IsDuplicityVersion() then
        ESX = exports['es_extended']:getSharedObject()
    end
end

config = {
    notify = function(message)
        ESX.ShowNotification(message)
    end,

    settings = {
        wait = (20 * 1000), -- How long do they have to wait until the bus picks em up?
        distance = 2.0, -- Distance check
        inform = "E - Bus Stop"
    },

    locations = {
        ["Grove Street"] = {
            price = 15,
            location = vec3(56.6413, -1540.1715, 29.2939)
        },
    
        ["East Los Santos"] = {
            price = 30,
            location = vec3(439.3373, -2033.2449, 23.5887),
        },
    
        ["LS Metro"] = {
            price = 25, 
            location = vec3(239.9515, -1198.6250, 29.2912)
        }
    }
}

get()