lock_license        = true -- true = license lock, false = growid lock

-- ================ DISCORD =========================
disable_webhook     = false -- WARNING !!! if disabled then you cant see list world
edited_webhook      = false
message_webhook     = "" -- if u enable edited webhook, fill this
webhookdc           = "https://discord.com/api/webhooks/"

-- ================ MODE =========================
-- auto_find_world true, auto find world, and place lock
-- auto_find_world false, bot clear world
auto_find_world     = false

-- ================ SETTING FIND AND LOCK WORLD =========================
create_farm         = 1 -- how many farm you want to create
letter              = 10 -- custom how many letter world
nonumber            = true -- set to false if WITH NUMBER, set to true if NO NUMBER

-- Fill this world list for bot clear world
list_world_clear    = {"WORLD1"}
limit_bot_per_world = 3
whiteListGrowid     = {"UrGrowid"}

-- =================GENERAL SETTING================================
-- OPTIONAL
save_seed           = true
remove_bot          = true -- remove bot after DF DONE

-- STORAGE WORLD SETTING
world_storage       = "" -- world to take jammer, wl, entrance, door
id_world_storage    = ""

world_seed          = "" -- world take seed 
id_world_seed       = "" -- id door world take seed 
move_direction      = 1 -- 1 = drop right, -1 = drop left

-- DELAY
delay_punch         = 170
delay_findpath      = 500
delay_collect       = 20
delay_joinworld     = 10000
delay_move_interval = 200
move_range          = 6
delay_wrench        = 5000
delay_reapply_lock  = 5000

trash_list          = {11, 10, 2914, 5024, 5026, 5028, 5030, 5032, 5034, 5036, 5038, 5040, 5042, 5044}

local script="clear"
getBot().auto_trash = false
getBot().collect_range = 3
getBot():setInterval(Action.collect, delay_collect/1000)
getBot():setInterval(Action.move, delay_move_interval/1000)
getBot().move_range = move_range
getBot().auto_reconnect = false

for i in pairs(list_world_clear) do
    list_world_clear[i] = list_world_clear[i]:upper()
end

world_seed = world_seed:upper()
id_world_seed = id_world_seed:upper()
nuked = false
levelWorld = false
maxlimit = false
index_world = 0

uptime = os.time()
list_time = {}
for i in pairs(list_world_clear) do
    table.insert(list_time, " ||???||")
end

wl_id = 242
jammer_id = 226
-- -=========================================================

function getUptime()
    textUptime = math.floor((os.time() - uptime) / 86400) .. " Days " .. math.floor((os.time() - uptime) % 86400 / 3600) .. " Hours " .. math.floor((os.time() - uptime) % 86400 % 3600 / 60) .. " Minutes"
    return textUptime
end

function getTextWorld()
    temp = ""
    
    for _, world in pairs(list_world_clear) do
        if auto_find_world then
            temp = temp .. _ ..". ||" .. world:upper() .. "||\n"
        else
            temp = temp .. _ ..". ||" .. world:upper() .. "|| | " .. list_time[_]
        end
    end
    return temp
end

function powershell(text, curent, textWorld)
    if disable_webhook == true then
        return
    end
    wh = Webhook.new(webhookdc)
    wh.embed1.use = true
    wh.username = "CLEAR LOGS"
    wh.embed1.title = "<:dirt:1022839909683302422> AUTO CLEAR v1.6 <:dirt:1022839909683302422>"
    wh.embed1.color = "4672231"
    wh.embed1.footer.text = os.date("!%a %b %d, %Y at %I:%M %p", os.time() + 7 * 60 * 60)
    wh.embed1:addField("<:megaphone:1164892284408582206> INFORMATION",text,false)
    wh.embed1:addField("<:bot:1119535018608435301> BOT","||"..getBot().name.."||",false)
    wh.embed1:addField("<a:online:1087347595287986236> STATUS",getBotStatus(),false)
    wh.embed1:addField("<:clock:1131558211485454459> UPTIME",getUptime(),false)
    wh.embed1:addField("<:world:996054982795198544> WORLD "..curent.."/"..#list_world_clear,textWorld,false)

    if edited_webhook then
        wh:edit(message_webhook)
    else
        wh:send()
    end
end

getposx = function()
    player = getBot():getWorld():getLocal()
    if player then
        return math.floor(player.posx/32)
    end
    return 0
end

getposy = function()
    player = getBot():getWorld():getLocal()
    if player then
        return math.floor(player.posy/32)
    end
    return 0
end

function getBotStatus()
    local status = getBot().status
    if status == BotStatus.online then
        return "online"
    elseif status == BotStatus.offline then
        return "offline"
    elseif status == BotStatus.wrong_password then
        return "wrong_password"
    elseif status == BotStatus.account_banned then
        return "account_banned"
    elseif status == BotStatus.location_banned then
        return "location_banned"
    elseif status == BotStatus.version_update then
        return "version_update"
    elseif status == BotStatus.advanced_account_protection then
        return "advanced_account_protection"
    elseif status == BotStatus.server_overload then
        return "login fail"
    elseif status == BotStatus.too_many_login then
        return "login fail"
    elseif status == BotStatus.maintenance then
        return "maintenance"
    elseif status == BotStatus.server_busy then
        return "login fail"
    elseif status == BotStatus.guest_limit then
        return "guest_limit"
    elseif status == BotStatus.http_block then
        return "http_block"
    elseif status == BotStatus.bad_name_length then
        return "bad_name_length"
    elseif status == BotStatus.invalid_account then
        return "invalid_account"
    elseif status == BotStatus.error_connecting then
        return "error_connecting"
    elseif status == BotStatus.changing_subserver then
        return "changing sub_server"
    elseif status == BotStatus.logon_fail then
        return "login fail"
    else
        return "unknown_status"
    end
end

function logToTxt(farm_world)
    local file = io.open("DF_" .. getBot().name .. ".txt", "a")
    file:write("\n\"" .. farm_world .. "\",")
    file:close()
end

addEvent(Event.variantlist, function(variant, netid)
    if variant:get(0):getString() == "OnConsoleMessage" then
        if variant:get(1):getString():lower():find("inaccessible") then
            nuked = true
        end
        if variant:get(1):getString():lower():find("can't enter") then
            levelWorld = true
        end
        if variant:get(1):getString():lower():find("oops,") then
            maxlimit=true
        end
    end
end)

function join(worldmu)
    while not nuked and not levelWorld and not maxlimit and getBot():getWorld().name:lower() ~= worldmu:lower() do
        getBot():warp(worldmu:upper())
        listenEvents(10)
        while getBotStatus() ~= "online" or getBot():getPing() == 0 do
            powershell("Reconnecting", index_world, getTextWorld())
            while getBot().google_status == 1 do
                sleep(1000)
            end
            if getBot().google_status ~= 1 then
                getBot():connect()
                sleep(10000)
            end
        end
    end

    if not nuked and not levelWorld and not maxlimit then
        return true
    else
        nuked = false
        levelWorld = false
        maxlimit = false
        return false
    end
end

function join_id(worldmu, iddoormu)
    while not nuked and not levelWorld and not maxlimit and getBot():getWorld().name:lower() ~= worldmu:lower() do
        getBot():warp(worldmu:upper().."|"..iddoormu:upper())
        listenEvents(10)
        while getBotStatus() ~= "online" or getBot():getPing() == 0 do
            powershell("Reconnecting", index_world, getTextWorld())
            while getBot().google_status == 1 do
                sleep(1000)
            end
            if getBot().google_status ~= 1 then
                getBot():connect()
                sleep(10000)
            end
        end
    end

    if not nuked and not levelWorld and not maxlimit then
        return true
    else
        nuked = false
        levelWorld = false
        maxlimit = false
        return false
    end
end

function isLimitWorld(worldmu)
    while not maxlimit and getBot():getWorld().name:lower() ~= worldmu:lower() do
        getBot():warp(worldmu:upper())
        listenEvents(10)
        while getBotStatus() ~= "online" or getBot():getPing() == 0 do
            powershell("Reconnecting", index_world, getTextWorld())
            while getBot().google_status == 1 do
                sleep(1000)
            end
            if getBot().google_status ~= 1 then
                getBot():connect()
                sleep(10000)
            end
        end
    end

    if not maxlimit then
        return false
    else
        maxlimit = false
        return true
    end
end

-- MOVE WHEN IN WHITE DOOR
function checkWD(world, door)
    while getTile(getposx(), getposy()).fg == 6 do
        getBot():warp(world.."|"..door)
        sleep(delay_joinworld)
        while getBotStatus() ~= "online" or getBot():getPing() == 0 do
            while getBot().google_status == 1 do
                sleep(1000)
            end
            if getBot().google_status ~= 1 then
                getBot():connect()
                sleep(10000)
            end
        end
    end
end

function reconnect(world)
    if getBotStatus() ~= "online" or getBot():getPing() == 0 then
        powershell("Bot ".. getBot().name .." disconnected, reconnnecting... ", index_world, getTextWorld())
        while getBotStatus() ~= "online" or getBot():getPing() == 0 do
            while getBot().google_status == 1 do
                sleep(1000)
            end
            if getBot().google_status ~= 1 then
                getBot():connect()
                sleep(10000)
            end
        end
        powershell("Bot ".. getBot().name .." reconnected", index_world, getTextWorld())
        if world == world_seed then
            join_id(world_seed, id_world_seed)
            checkWD(world_seed, id_world_seed)
        else
            join(world)
        end
    end
end

function dropItem(itemID, count)
    if getBot():getInventory():findItem(itemID) >= count then
        getBot():drop(itemID, count)
        sleep(4000)
    end
end

-- AUTO TRASH
function trash(world)
    reconnect(world)
    x = getposx()
    y = getposy()
    for i, trash in ipairs(trash_list) do
        if getBot():getInventory():findItem(trash) > 190 then
            getBot():trash(trash, getBot():getInventory():findItem(trash))
            sleep(3000)
        end
    end

    if save_seed == false then
        TrashF = {2, 14, 4, 3, 15, 5, 11}
        for i, trash in ipairs(TrashF) do
            if getBot():getInventory():findItem(trash) > 190 then
                getBot():trash(trash, 50)
                sleep(3000)
            end
        end
    else
        TrashF = {2, 14, 4}
        for i, trash in ipairs(TrashF) do
            if getBot():getInventory():findItem(trash) > 190 then
                getBot():trash(trash, 50)
                sleep(3000)
            end
        end
        Isseed = false
        Listseed = {3, 15, 5, 11}
        for i, seed in ipairs(Listseed) do
            if getBot():getInventory():findItem(seed) > 150 then
                Isseed = true
            end
        end
        -- save seed
        if Isseed then
            if not join_id(world_seed, id_world_seed) then
                print("NUKED WORLD SEED")
                return
            end

            reconnect(world_seed)
            
            for i, seed in ipairs(Listseed) do
                if getBot():getInventory():findItem(seed) > 150 then
                    count_seed = getBot():getInventory():findItem(seed)
                    getBot():drop(seed, count_seed)
                    sleep(4000)
                    while count_seed == getBot():getInventory():findItem(seed) do
                        getBot():moveTo(move_direction, 0)
                        sleep(1000)
                        getBot():drop(seed, count_seed)
                        sleep(4000)
                    end
                end
            end

            -- BACK TO WORLD DF
            join(world)
            reconnect(world)
            while getposx() ~= x or getposy() ~= y do
                getBot():findPath(x, y)
                sleep(200)
            end
        end
    end
end

function checkTile(tile)
    if (tile.fg == 2 or tile.bg == 14 or tile.fg == 10 or tile.fg == 4) and tile.fg ~= 8 then
        return true
    end
    return false
end

function getTotalBot()
    temp = false
    real = {}
    for _, player in pairs(getPlayers()) do
        for _, white in pairs(whiteListGrowid) do
            if player.name:lower() == white:lower() then
                temp = true
                break
            end
        end
        if not temp then
            table.insert(real, player)
        end
        temp = false
    end
    return #real
end

function getIndexBot()
    temp = false
    real = {}
    for _, player in pairs(getPlayers()) do
        local growid = player.name
        -- if growid:find("_") then
        --     growid = growid:gsub("[%d_]", "")
        -- end
        for _, white in pairs(whiteListGrowid) do
            if growid:lower() == white:lower() then
                temp = true
                if player.isLocalPlayer then
                    table.insert(real, player)
                end
                break
            end
        end
        if not temp then
            table.insert(real, player)
        end
        temp = false
    end

    urutan = 1
    for _, player in pairs(real) do
        if player.isLocalPlayer then
            return urutan
        end
        urutan = urutan + 1
    end
    return urutan-1
end


function splitJobs(jobsList)
    local total_bot = getTotalBot()
    local botJobs = {}
    for bot = 1, total_bot do
        botJobs[bot] = {}
    end

    local currentIndex = 1
    for _, job in ipairs(jobsList) do
        local botIndex = (currentIndex - 1) % total_bot + 1
        table.insert(botJobs[botIndex], job)
        currentIndex = currentIndex + 1
    end

    return botJobs
end
list_blacklist = {6, 8, 242, 202, 204, 206, 226, 1276, 1278}
function isInArray(arraynya, itemnya)
    for _, item in pairs(arraynya) do
        if itemnya == item then
            return true
        end
    end
    return false
end

function clearSide(world)
    powershell("Clearing side", index_world, getTextWorld())
    -- KIRI
    for i = 0, 53 do
        reconnect(world)
        if (getTile(0, i).bg ~= 0 or getTile(0, i).fg ~= 0) and not isInArray(list_blacklist, getTile(0, i).fg) then
            reconnect(world)
            while (getTile(0, i).bg ~= 0 or getTile(0, i).fg ~= 0) and not isInArray(list_blacklist, getTile(0, i).fg) do
                reconnect(world)
                while getposx() ~= 0 or getposy() ~= i-1 do
                    getBot():findPath(0, i - 1)
                    sleep(delay_findpath)
                    reconnect(world)
                end
                
                getBot():hit(getposx(), getposy()+1)
                sleep(delay_punch)
                getBot():collect(2)
                sleep(delay_collect)
                trash(world)
            end
        end
    end
end

function ClearMulti(world)
    trash(world)

    powershell("Clearing all dirt", index_world, getTextWorld())
    local jobs = {}
    local temp_jobs = {}
    for i = 0, 53 do
        table.insert(jobs, i)
        table.insert(temp_jobs, i)
    end

    local list_job = splitJobs(jobs)
    local index_bot = getIndexBot()

    local h = 1
    local size_array = #list_job[index_bot]
    while h <= size_array do
        local y = list_job[index_bot][h]     
        for x = 0, 99 do
            jobs = temp_jobs
            list_job = splitJobs(jobs, world)
            index_bot = getIndexBot()
            if list_job[index_bot][h] ~= y then
                h = 1
                print(getBot().name.. " - updating jobs")
                break
            end
            if getTile(x - 1, y).fg == 0 and x - 1 >= 0 and (getTile(x, y).bg ~= 0 or getTile(x, y).fg ~= 0) and not isInArray(list_blacklist, getTile(x, y).fg) then
                getBot():findPath(x - 1, y)
                sleep(delay_findpath)
                while getTile(x, y).fg ~= 0 or getTile(x, y).bg ~= 0 do
                    getBot():hit(x, y)
                    sleep(delay_punch)
                    reconnect(world)
                    while getposx() ~= x-1 or getposy() ~= y do
                        getBot():findPath(x-1, y)
                        sleep(delay_findpath)
                        reconnect(world)
                    end
                end
                getBot():collect(2)
                sleep(delay_collect)
                trash(world)
                
            elseif (getTile(x, y).bg ~= 0 or getTile(x, y).fg ~= 0) and not isInArray(list_blacklist, getTile(x, y).fg) and getTile(x, y - 1).fg == 0 then
                getBot():findPath(x, y - 1)
                sleep(delay_findpath)
                while getTile(x, y).fg ~= 0 or getTile(x, y).bg ~= 0 do
                    getBot():hit(x, y)
                    sleep(delay_punch)
                    reconnect(world)
                    while getposx() ~= x or getposy() ~= y-1 do
                        getBot():findPath(x, y - 1)
                        sleep(delay_findpath)
                        reconnect(world)
                    end
                end
                getBot():collect(2)
                sleep(delay_collect)
                trash(world)
            end
        end
        h=h+1
        size_array = #list_job[index_bot]
    end
    print("DONE")
end

function cekList(list, operator)
    local count = create_farm
    for _, item in pairs(list) do
        if operator == "gt" then
            if getBot():getInventory():findItem(item) > count then
                return true
            end
        elseif operator == "lt" then
            if getBot():getInventory():findItem(item) < count then
                return true
            end
        end
    end
    return false
end

function randomize()
    world = ""
    if nonumber then
        for i = 1, letter, 1 do
            world = world .. string.char(math.random(97, 122))
            world = string.upper(world)
        end
    else
        for i = 1, letter, 1 do
            if (i % 2 == 0) then
                world = world .. string.char(math.random(97, 122))
                world = string.upper(world)
            else
                world = world .. string.char(math.random(48, 57))
                world = string.upper(world)
            end
        end
    end
    return world
end

function isFlat()
    for y = 0, 23 do
        for x = 0, 99 do
            if getTile(x, y).fg ~= 6 then
                if getTile(x, y).fg ~= 0 or getTile(x, y).bg ~= 0 then
                    return false
                end
            end
        end
    end
    return true
end

function isLocked()
    if getBot():getWorld():hasAccess(0, 0) ~= 0 then
        return false
    end
    return true
end

function isTimeToTake()
    local count = create_farm
    list = {wl_id, jammer_id}

    for _, item in pairs(list) do
        if getBot():getInventory():findItem(item) < count then
            return true
        end
    end
    return false
end

function takeItem()
    local count = create_farm
    list = {wl_id, jammer_id}

    while cekList(list, "lt") do
        if not join_id(world_storage, id_world_storage) then
            print("NUKED WORLD STORAGE : ".. world_storage)
            return
        end
    
        reconnect(world_storage)

        for _, item in pairs(list) do
            if getBot():getInventory():findItem(item) < count then
                while getBot():getInventory():findItem(item) < count do
                    for _, object in pairs(getObjects()) do
                        if object.id == item then
                            x = math.floor(object.x / 32)
                            y = math.floor(object.y / 32)
                            while getposx() ~= x or getposy() ~= y do
                                getBot():findPath(x,y)
                                sleep(40)
                                reconnect(world_storage)
                            end
                            sleep(delay_findpath)
                            getBot():collect(2)
                            sleep(delay_findpath)
                        end
                    end
                    reconnect(world_storage)
                    print("no " .. getInfo(item).name)
                    sleep(1000)
                end
            end
        end

        while cekList(list, "gt") do
            for _, item in pairs(list) do
                if getBot():getInventory():findItem(item) > count then
                    join_id(world_storage)
                    reconnect(world_storage)
                    getBot():drop(item, getBot():getInventory():findItem(item)-count)
                    sleep(4000)
                    while getBot():getInventory():findItem(item) > count do
                        getBot():moveTo(-1, 0)
                        sleep(delay_findpath)
                        getBot():drop(item, getBot():getInventory():findItem(item)-count)
                        sleep(4000)
                        reconnect(world_storage)
                    end
                end
            end
        end
    end
end

function dropAll()
    list = {wl_id, jammer_id}

    if not join(world_storage) then
        print("NUKED WORLD STORAGE : ".. world_storage)
        return
    end

    reconnect(world_storage)

    while cekList(list, "gt") do
        for _, item in pairs(list) do
            if getBot():getInventory():findItem(item) > 0 then
                join(world_storage)
                reconnect(world_storage)
                getBot():drop(item, getBot():getInventory():findItem(item))
                sleep(4000)
                while getBot():getInventory():findItem(item) > count do
                    getBot():moveTo(-1, 0)
                    sleep(delay_findpath)
                    getBot():drop(item, getBot():getInventory():findItem(item))
                    sleep(4000)
                    reconnect(world_storage)
                end
            end
        end
    end
end

function getIndexBots()
    local temp = 1
    for _, bot in pairs(getBots()) do
        if bot.name:lower() == getBot().name:lower() then
            return temp
        end
        temp = temp + 1
    end
    return temp
end

function main()
    if auto_find_world then
        list_world_clear = {}
        while isTimeToTake() do
            takeItem()
            sleep(500)
        end
        
        for i = 1, create_farm do
            index_world = i
            -- misal ada limit 20 world per day gmn?
            isCreated = false
            world = ""
            while not isCreated do
                world = randomize()
                print(world)
                if join(world) then
                    if isFlat() and not isLocked() then
                        table.insert(list_world_clear, world)
                        isCreated = true
                        logToTxt(world)
                        powershell("Generated ||".. world.."||", index_world, getTextWorld())
                    end
                else
                    if isLimitWorld(world) then
                        powershell("Reached max limit world try again tomorrow", index_world, getTextWorld())
                        create_farm = 0
                        dropAll()
                        getBot():disconnect()
                        return
                    end
                end
            end
            
            -- place WL and jammer only
            while getTile(getposx(), getposy()-1).fg ~= wl_id do
                getBot():place(getposx(), getposy()-1, wl_id) -- KALO PLACE -1 = ATAS, BAWAH = 1
                sleep(delay_place)
                reconnect(world)
            end
            
            while getTile(getposx()-1, getposy()-1).fg ~= jammer_id do
                getBot():place(getposx()-1, getposy()-1, jammer_id) -- KALO PLACE -1 = ATAS, BAWAH = 1
                sleep(delay_place)
                reconnect(world)
            end
            
            -- nyalain jammer
            while getTile(getposx()-1,getposy()-1):hasFlag(0x40) == false do
                getBot():hit(getposx()-1,getposy()-1)
                sleep(1000)
                reconnect(world)
            end

            reconnect(world)
            -- PUBLIC WL
            getBot():wrench(getposx(), getposy()-1)
            sleep(delay_wrench)
            getBot():sendPacket(2,"action|dialog_return\ndialog_name|lock_edit\ntilex|" .. getposx() .."|\ntiley|" .. getposy() - 1 .."|\nbuttonClicked|recalcLock\n\ncheckbox_public|1\ncheckbox_ignore|0")

            powershell("Success Lock ".. world, index_world, getTextWorld())
        end
    else
        for _, world in pairs(list_world_clear) do
            index_world = _
            if join(world) then
                sleep(getIndexBots()*5000)
                total_bot = getTotalBot()
                if total_bot <= limit_bot_per_world then
                    time =  os.time()
                    reconnect(world)
                    powershell("Start Clearing world", index_world, getTextWorld())
                    clearSide(world)
                    ClearMulti(world)
                    selesai = os.time()
                    time = selesai - time
                    -- webhook
                    list_time[_] = math.floor(time % 86400 / 3600) .. " Hours " .. math.floor(time % 86400 % 3600 / 60) .. " Minutes"
                    powershell("Done Clear World", index_world, getTextWorld())
                end 
            end
        end
    end
end

function verify(lock)
    local client = HttpClient.new()
    client:setMethod(Method.get)
    client.url = "https://zitusstore.com/verify.php?act=verify&module=zitus_store&script="..script.."&lock="..lock.."&key=kenapakamudisiniwoi"
    client.headers["User-Agent"] = "Lucifer"
    response = client:request()
    return response.body
end

function isMatch()
    local isOwner = false
    local count = 0
    if not lock_license then
        getBot():say("Wait lemme check")
        sleep(2000)
        -- check Owner script
        while isOwner == false do
            for _, player in pairs(getPlayers()) do
                if verify(player.name) == "SUCCESS" then
                    isOwner = true
                    ownerzitus = player.name
                    getBot():say("Okok i got u")
                    powershell("Owner Script is alive", index_world, getTextWorld())
                    sleep(4000)
                    break
                end
            end
            if count > 5 then
                return false
            end
            count=count+1
            sleep(1000)
        end
        return true
    else
        local username_license = getUsername()
        if verify(username_license) ~= "SUCCESS" then
            powershell("License Lucifer not match : " .. username_license, index_world, getTextWorld())
            print("License Lucifer not match : " .. username_license)
        else
            isOwner = true
        end
    end
    return isOwner
end


if isMatch() then
    main()
end

if remove_bot then
    getBot():updateBot("null", "null")
end
