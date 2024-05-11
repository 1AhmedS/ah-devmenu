QBCore = exports['qb-core']:GetCoreObject()   

local permissions = {
    ["kick"] = "god",
    ["ban"] = "god",
    ["noclip"] = "god",
    ["kickall"] = "god",
}

RegisterServerEvent('ah-devmenu:server:togglePlayerNoclip')
AddEventHandler('ah-devmenu:server:togglePlayerNoclip', function(playerId, reason)
    local src = source
    local Player = QBCore.Functions.GetPlayer(playerId)
    if QBCore.Functions.HasPermission(src, permissions["noclip"]) then
        TriggerClientEvent("ah-devmenu:client:toggleNoclip", playerId)
        TriggerEvent("qb-log:server:CreateLog", "noclip", "No Clip", "orange", "**"..GetPlayerName(playerId).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..playerId..") Activated NoClip")
    end

end)



RegisterServerEvent('ah-devmenu:checkperms')
AddEventHandler('ah-devmenu:checkperms', function(target)
    local Player = QBCore.Functions.GetPlayer(src)
    local group = QBCore.Functions.GetPermission(source)   
    if group == "god" or group == 'god' then
        TriggerClientEvent("ah-devmenu:client:toggleNoclip", source)
    end
end)

RegisterServerEvent('ah-devmenu:checkperm')
AddEventHandler('ah-devmenu:checkperm', function(target)
    local Player = QBCore.Functions.GetPlayer(src)
    local group = QBCore.Functions.GetPermission(source)   
    if group == "god" or group == 'god' then
        TriggerClientEvent('ah-devmenu:client:openMenu', source, group, dealers)
    end
end)

RegisterServerEvent('ah-devmenu:server:killPlayer')
AddEventHandler('ah-devmenu:server:killPlayer', function(playerId)
    TriggerClientEvent('hospital:client:KillPlayer', playerId)
    TriggerEvent('qb-logs:server:createLog', 'killPlayer', 'Kill', "Killed " .. GetPlayerName(playerId), source)
end)

AddEventHandler('chatMessage', function(source, name, msg)
    TriggerEvent("qb-log:server:CreateLog", "chat", "chat", "chat", GetPlayerName(source) .." Send Massage :"..msg)
end)


RegisterServerEvent('ah-devmenu:server:kickPlayer')
AddEventHandler('ah-devmenu:server:kickPlayer', function(playerId, reason)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions["kick"]) then
        TriggerEvent("qb-log:server:CreateLog", "kickPlayer", "kickPlayer", "kickPlayer", GetPlayerName(src) .." Kicked  : "..GetPlayerName(playerId).." For : " ..reason)
        DropPlayer(playerId, "You have been kicked out of the server:\n"..reason.."\n\n:small_orange_diamond: Check our website for more information: realisticlife.co.il")
    else
        TriggerEvent("qb-log:server:CreateLog", "kickPlayer", "kickPlayer", "kickPlayer", GetPlayerName(src) .." try to kick  : "..GetPlayerName(playerId).." but he dont have prems ")
    end
end)

RegisterServerEvent('ah-devmenu:server:Freeze')
AddEventHandler('ah-devmenu:server:Freeze', function(playerId, toggle)
    local src = source
    TriggerClientEvent('ah-devmenu:client:Freeze', playerId, toggle)
    TriggerEvent('qb-logs:server:createLog', 'Freeze', 'Freeze', "Freezed "  .. GetPlayerName(playerId) .." [" .. tostring(toggle) .."].", src)
end)

RegisterServerEvent('ah-devmenu:server:banPlayer')
AddEventHandler('ah-devmenu:server:banPlayer', function(playerId, time, reason)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions["ban"]) then
        local time = tonumber(time)
        local banTime = tonumber(os.time() + time)
        if banTime > 2147483647 then
            banTime = 2147483647
        end
        local timelog = time / 60
        local timeTable = os.date("*t", banTime)
        TriggerEvent("qb-log:server:CreateLog", "bans", "ban", "Banned", GetPlayerName(src) .." Banned  : "..GetPlayerName(playerId).." For : " ..timelog.."m Reason : " ..reason)
        QBCore.Functions.ExecuteSql(false, "INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`, `bannedby`) VALUES ('"..GetPlayerName(playerId).."', '"..GetPlayerIdentifiers(playerId)[1].."', '"..GetPlayerIdentifiers(playerId)[2].."', '"..GetPlayerIdentifiers(playerId)[3].."', '"..GetPlayerIdentifiers(playerId)[4].."', '"..reason.."', "..banTime..", '"..GetPlayerName(src).."')")
        TriggerClientEvent('chatMessage', -1, "BANHAMMER", "error", GetPlayerName(playerId).." has been banned for: "..reason)
        DropPlayer(playerId, "You have been banned from the server:\n"..reason.."\nYour ban expires in "..timeTable["day"].. "/" .. timeTable["month"] .. "/" .. timeTable["year"] .. " " .. timeTable["hour"].. ":" .. timeTable["min"] .. "\nCheck our website for more information:  https://discord.gg/o-n")
    end
end)

RegisterServerEvent('ah-devmenu:server:revivePlayer')
AddEventHandler('ah-devmenu:server:revivePlayer', function(target)
    TriggerClientEvent('hospital:client:Revive', target)
    TriggerEvent("qb-log:server:CreateLog", "revivePlayer", "Menu Revive", "Player", GetPlayerName(source) .." Revived :"..GetPlayerName(target))

end)

QBCore.Commands.Add("ahmenu", "Ahmed Samir Private Menu (Dev)", {}, false, function(source, args)
    local group = QBCore.Functions.GetPermission(source)
    TriggerClientEvent('ah-devmenu:client:openMenu', source, group)
end, "god")


QBCore.Commands.Add("givenuifocus", "Give nui focus", {{name="id", help="Speler id"}, {name="focus", help="Turn focus on / off"}, {name="mouse", help="Turn mouse on / off"}}, true, function(source, args)
    local playerid = tonumber(args[1])
    local focus = args[2]
    local mouse = args[3]

    TriggerClientEvent('ah-devmenu:client:GiveNuiFocus', playerid, focus, mouse)
end, "god")

QBCore.Commands.Add("enablekeys", "Enable all keys for player.", {{name="id", help="Player id"}}, true, function(source, args)
    local playerid = tonumber(args[1])

    TriggerClientEvent('ah-devmenu:client:EnableKeys', playerid)
end, "god")

QBCore.Commands.Add("warn", "Give a person a warning", {{name="ID", help="Person"}, {name="Reason", help="Enter a reason"}}, true, function(source, args)
    local targetPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local senderPlayer = QBCore.Functions.GetPlayer(source)
    table.remove(args, 1)
    local msg = table.concat(args, " ")

    local myName = senderPlayer.PlayerData.name

    local warnId = "WARN-"..math.random(1111, 9999)

    if targetPlayer ~= nil then
        TriggerClientEvent('chatMessage', targetPlayer.PlayerData.source, "SYSTEM", "error", "You have been warned by: "..GetPlayerName(source)..", Reason: "..msg)
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "You have "..GetPlayerName(targetPlayer.PlayerData.source).." warned for: "..msg)
        QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_warns` (`senderIdentifier`, `targetIdentifier`, `reason`, `warnId`) VALUES ('"..senderPlayer.PlayerData.steam.."', '"..targetPlayer.PlayerData.steam.."', '"..msg.."', '"..warnId.."')")
    else
        TriggerClientEvent('QBCore:Notify', source, 'This person is not in the city of #YOLO, hmm I am '..myName..' and I stink loloololo', 'error')
    end 
end, "god")

QBCore.Commands.Add("checkwarns", "Give a person a warning", {{name="ID", help="Persoon"}, {name="Warning", help="Number of warning, (1, 2 of 3 etc..)"}}, false, function(source, args)
    if args[2] == nil then
        local targetPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
        QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_warns` WHERE `targetIdentifier` = '"..targetPlayer.PlayerData.steam.."'", function(result)
            TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", targetPlayer.PlayerData.name.." heeft "..tablelength(result).." warnings!")
        end)
    else
        local targetPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))

        QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_warns` WHERE `targetIdentifier` = '"..targetPlayer.PlayerData.steam.."'", function(warnings)
            local selectedWarning = tonumber(args[2])

            if warnings[selectedWarning] ~= nil then
                local sender = QBCore.Functions.GetPlayer(warnings[selectedWarning].senderIdentifier)

                TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", targetPlayer.PlayerData.name.." has been warned by "..sender.PlayerData.name..", Reason: "..warnings[selectedWarning].reason)
            end
        end)
    end
end, "god")

QBCore.Commands.Add("remove", "Remove warning from person", {{name="ID", help="Persoon"}, {name="Warning", help="Number of warning, (1, 2 of 3 etc..)"}}, true, function(source, args)
    local targetPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))

    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_warns` WHERE `targetIdentifier` = '"..targetPlayer.PlayerData.steam.."'", function(warnings)
        local selectedWarning = tonumber(args[2])

        if warnings[selectedWarning] ~= nil then
            local sender = QBCore.Functions.GetPlayer(warnings[selectedWarning].senderIdentifier)

            TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "You have warning ("..selectedWarning..") removed, Reason: "..warnings[selectedWarning].reason)
            QBCore.Functions.ExecuteSql(false, "DELETE FROM `player_warns` WHERE `warnId` = '"..warnings[selectedWarning].warnId.."'")
        end
    end)
end, "god")

QBCore.Commands.Add("setmeadmin", "set me admin", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    QBCore.Functions.AddPermission(source, "god")
end)

function tablelength(table)
    local count = 0
    for _ in pairs(table) do 
        count = count + 1 
    end
    return count
end

QBCore.Commands.Add("setmodel", "تعديل الشخصية الى شخصية محددة", {{name="id", help="رقم اللاعب"}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local target = tonumber(args[1])
    local OtherPlayer = QBCore.Functions.GetPlayer(target)
    local model = args[2]
    if OtherPlayer ~= nil then 
        if model ~= nil or model ~= "" then
            TriggerClientEvent('ah-devmenu:client:SetModel', target, tostring(model))
            TriggerEvent("qb-log:server:CreateLog", "setmodel", "SetModel", "orange", "**"..GetPlayerName(target).."** (CitizenID: "..OtherPlayer.PlayerData.citizenid.." | ID: "..source..") " ..model)

        else
            TriggerClientEvent('QBCore:Notify', source, "You have not specified a Model..", "error")
        end
    else
        TriggerClientEvent("QBCore:Notify", source, "الشخص غير موجود", "error")
    end
end, "god")

QBCore.Commands.Add("setspeed", "لتغير سرعة الركض", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local speed = args[1]

    if speed ~= nil then
        TriggerClientEvent('ah-devmenu:client:SetSpeed', source, tostring(speed))
    else
        TriggerClientEvent('QBCore:Notify', source, "You did not specify a Speed ​​.. (`fast` for super-run,` normal` for normal)", "error")
    end
    TriggerEvent("qb-log:server:CreateLog", "setspeed", "Speed", "orange", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") " ..speed)
end, "god")

-- QBCore.Commands.Add("admincar", " اضافة السيارة الى القراج", {}, false, function(source, args)
--     local ply = QBCore.Functions.GetPlayer(source)
--     TriggerClientEvent('ah-devmenu:client:SaveCar', source)
-- end, "god")

RegisterServerEvent('ah-devmenu:server:SaveCar')
AddEventHandler('ah-devmenu:server:SaveCar', function(mods, vehicle, hash, plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] == nil then
            QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..vehicle.model.."', '"..vehicle.hash.."', '"..json.encode(mods).."', '"..plate.."', 0)")
            TriggerClientEvent('QBCore:Notify', src, 'لقد تم وضع السيارة في قراجك الخاص', 'success', 5000)
        else
            TriggerClientEvent('QBCore:Notify', src, 'هذي السيارة موجودة بالفعل في قراجك الخاص.', 'error', 3000)
        end
    end)
    TriggerEvent("qb-log:server:CreateLog", "admincar", "admincar", "orange", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | Saved: "..plate..") ")
end)

RegisterServerEvent('ah-devmenu:server:bringTp')
AddEventHandler('ah-devmenu:server:bringTp', function(targetId, coords)
    TriggerClientEvent('ah-devmenu:client:bringTp', targetId, coords)
end)

RegisterServerEvent('ah-devmenu:server:gotoTp')
AddEventHandler('ah-devmenu:server:gotoTp', function(targetid, playerid)
    TriggerClientEvent('ah-devmenu:client:gotoTp', targetid, playerid)
end)

RegisterServerEvent('ah-devmenu:server:gotoTpstage2')
AddEventHandler('ah-devmenu:server:gotoTpstage2', function(targetid, coords)
    TriggerClientEvent('ah-devmenu:client:gotoTp2', targetid, coords)
end)

QBCore.Functions.CreateCallback('ah-devmenu:server:hasPermissions', function(source, cb, group)
    local src = source
    local retval = false

    if QBCore.Functions.HasPermission(src, group) then
        retval = true
    end
    cb(retval)
end)


RegisterServerEvent('ah-devmenu:server:setPermissions')
AddEventHandler('ah-devmenu:server:setPermissions', function(targetId, group)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    QBCore.Functions.AddPermission(targetId, group.rank)
    TriggerClientEvent('QBCore:Notify', targetId, 'Your permission group has been set to '..group.label)
    TriggerEvent("qb-log:server:CreateLog", "setPermissions", "تغيير رتبة شخص الادارية", "red", "**"..GetPlayerName(src).."** Change Prem: "..GetPlayerName(targetId).." ID : (" ..targetId..") To  "..group.label, false)
end)



RegisterServerEvent('ah-devmenu:server:crash')
AddEventHandler('ah-devmenu:server:crash', function(id)
    TriggerClientEvent("ah-devmenu:client:crash", id)
end)

RegisterServerEvent('ah-devmenu:server:SendReport')
AddEventHandler('ah-devmenu:server:SendReport', function(name, targetSrc, msg)
    local src = source
    local Players = QBCore.Functions.GetPlayers()

    if QBCore.Functions.HasPermission(src, "god") then
        if QBCore.Functions.IsOptin(src) then
            TriggerClientEvent('chatMessage', src, "REPORT - "..name.." ("..targetSrc..")", "report", msg)
        end
    end
end)


RegisterServerEvent('ah-devmenu:server:ReportBug')
AddEventHandler('ah-devmenu:server:ReportBug', function(name, targetSrc, msg)
    local src = source
    local Players = QBCore.Functions.GetPlayers()

    if QBCore.Functions.HasPermission(src, "god") then
        if QBCore.Functions.IsOptin(src) then
            TriggerClientEvent('chatMessage', src, "REPORT BUG - "..name.." ("..targetSrc..")", "report", msg)
        end
    end
end)

RegisterServerEvent('ah-devmenu:server:StaffChatMessage')
AddEventHandler('ah-devmenu:server:StaffChatMessage', function(name, msg)
    local src = source
    local Players = QBCore.Functions.GetPlayers()

    if QBCore.Functions.HasPermission(src, "god") then
        if QBCore.Functions.IsOptin(src) then
            TriggerClientEvent('chatMessage', src, "STAFFCHAT - "..name, "staffchat", msg)
        end
    end
end)


QBCore.Commands.Add("setammo", "تعشيق السلاح", {{name="amount", help="The amount of bullets, for example: 20"}, {name="weapon", help="Name of weapon, for example: WEAPON_RAILGUN"}}, false, function(source, args)
    local src = source
    local weapon = args[2]
    local amount = tonumber(args[1])
    local Player = QBCore.Functions.GetPlayer(source)

    if weapon ~= nil then
        TriggerClientEvent('qb-weapons:client:SetWeaponAmmoManual', src, weapon, amount)
    else
        weapon = "current weapon"
        TriggerClientEvent('qb-weapons:client:SetWeaponAmmoManual', src, "current", amount)
    end
    TriggerEvent("qb-log:server:CreateLog", "setammo", "SetAmmo", "yellow", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") " .. weapon .. " "  .. amount .. " ")
end, 'god')

QBCore.Commands.Add("np", "طيران", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent('ah-devmenu:client:toggleNoclip', source)
    TriggerEvent("qb-log:server:CreateLog", "noclip", "No Clip", "orange", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") Activated NoClip")
end, "god")

RegisterServerEvent('ah-devmenu:server:OpenSkinMenu')
AddEventHandler('ah-devmenu:server:OpenSkinMenu', function(targetId)
    local src = source
    local user = QBCore.Functions.GetPlayer(src)
    local citizenid = user.PlayerData.citizenid
    TriggerClientEvent("raid_clothes:hasEnough", targetId, 'clothesmenu')
end)

RegisterServerEvent('ah-devmenu:server:OpenTattoMenu')
AddEventHandler('ah-devmenu:server:OpenTattoMenu', function(targetId)
    local src = source
    local user = QBCore.Functions.GetPlayer(src)
    local citizenid = user.PlayerData.citizenid
    TriggerClientEvent("raid_clothes:hasEnough", targetId, 'tattoomenu')
end)


RegisterServerEvent('ah-devmenu:server:OpenBarberMenu')
AddEventHandler('ah-devmenu:server:OpenBarberMenu', function(targetId)
    local src = source
    local user = QBCore.Functions.GetPlayer(src)
    local citizenid = user.PlayerData.citizenid
    TriggerClientEvent("raid_clothes:hasEnough", targetId, 'barbermenu')
end)


RegisterCommand("66755kickall55", function(source, args, rawCommand)
    local src = source
    
    if src > 0 then
        local reason = table.concat(args, ' ')
        local Player = QBCore.Functions.GetPlayer(src)

        if QBCore.Functions.HasPermission(src, "god") then
            if args[1] ~= nil then
                for k, v in pairs(QBCore.Functions.GetPlayers()) do
                    local Player = QBCore.Functions.GetPlayer(v)
                    if Player ~= nil then 
                        DropPlayer(Player.PlayerData.source, reason)
                    end
                end
            else
                TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'الرجاء كتابة السبب')
            end
        else
            TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'You cant just do this, baby..')
        end
    else
        for k, v in pairs(QBCore.Functions.GetPlayers()) do
            local Player = QBCore.Functions.GetPlayer(v)
            if Player ~= nil then 
                DropPlayer(Player.PlayerData.source, "Server restarted , look at discord for more information! (https://discord.gg/o-n)")
            end
        end
    end
end, false)


QBCore.Commands.Add("system", "لإرسال رسالة إلى جميع اللاعبين", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local msg = table.concat(args, " ")
    for i = 1, 3, 1 do
        TriggerClientEvent('chatMessage', -1, "SYSTEM", "error", msg)
    end
    TriggerEvent("qb-log:server:CreateLog", "system", "system", "red", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..")  Announced " ..msg)
end, "god")

QBCore.Commands.Add("god", "فتح قائمة الادارة", {}, false, function(source, args)
    local group = QBCore.Functions.GetPermission(source)
    TriggerClientEvent('ah-devmenu:client:openMenu', source, group)
end, "god")


QBCore.Commands.Add("report", "ارسال شكوى الى ادارة السيرفر", {{name="message", help="message you want to send"}}, true, function(source, args)
    local msg = table.concat(args, " ")
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent('ah-devmenu:client:SendReport', -1, GetPlayerName(source), source, msg)
    TriggerClientEvent('chatMessage', source, "تم إرسال الشكوى", "report", msg)
    TriggerEvent("qb-log:server:CreateLog", "report", "Report", "orange", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Report:** " ..msg, false)
    TriggerEvent("qb-log:server:sendLog", Player.PlayerData.citizenid, "reportreply", {message=msg})
end)


QBCore.Commands.Add("reportbug", "ارسال شكوى الى ادارة السيرفر", {{name="message", help="message you want to send"}}, true, function(source, args)
    local msg = table.concat(args, " ")
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent('ah-devmenu:client:Reportbug', -1, GetPlayerName(source), source, msg)
    TriggerClientEvent('chatMessage', source, "تم الابلاغ عن مشكلة", "error", msg)
    TriggerEvent("qb-log:server:CreateLog", "reportbug", "Reportbug", "orange", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Report:** " ..msg, false)
    TriggerEvent("qb-log:server:sendLog", Player.PlayerData.citizenid, "reportreply", {message=msg})
end)


QBCore.Commands.Add("staffchat", "ارسال رسالة للادارة", {{name="message", help="message you want to send"}}, true, function(source, args)
    local msg = table.concat(args, " ")
    TriggerClientEvent('ah-devmenu:client:SendStaffChat', -1, GetPlayerName(source), msg)
end, "god")

QBCore.Commands.Add("reportr", "الرد على البلاغ", {{name="player id", help="هوية اللاعب"}, {name="massge", help="الرسالة"}}, false, function(source, args)
    local playerId = tonumber(args[1])
    table.remove(args, 1)
    local msg = table.concat(args, " ")
    local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
    local Player = QBCore.Functions.GetPlayer(source)
    if OtherPlayer ~= nil then
        TriggerClientEvent('chatMessage', playerId, "ADMIN - "..GetPlayerName(source), "warning", msg)
        TriggerClientEvent('QBCore:Notify', source, "Response sent")
        TriggerEvent("qb-log:server:sendLog", Player.PlayerData.citizenid, "reportreply", {otherCitizenId=OtherPlayer.PlayerData.citizenid, message=msg})
        for k, v in pairs(QBCore.Functions.GetPlayers()) do
            if QBCore.Functions.HasPermission(v, "god") then
                if QBCore.Functions.IsOptin(v) then
                    TriggerClientEvent('chatMessage', v, "ReportReply("..source..") - "..GetPlayerName(source), "warning", msg)
                    TriggerEvent("qb-log:server:CreateLog", "report", "Report Reply", "orange", "**"..GetPlayerName(source).."** responded: **"..OtherPlayer.PlayerData.name.. " **(ID: "..OtherPlayer.PlayerData.source..") **message:** " ..msg, false)
                end
            end
        end
    else
        TriggerClientEvent('QBCore:Notify', source, "Player is not online", "error")
    end
end, "god")


QBCore.Commands.Add("s", "ارسال رسالة للادارة", {{name="message", help="الرسالة"}}, true, function(source, args)
    local msg = table.concat(args, " ")

    TriggerClientEvent('ah-devmenu:client:SendStaffChat', -1, GetPlayerName(source), msg)
end, "god")

QBCore.Commands.Add("togglereport", "تعليق اظهار التقارير", {}, false, function(source, args)
    QBCore.Functions.ToggleOptin(source)
    if QBCore.Functions.IsOptin(source) then
        TriggerClientEvent('QBCore:Notify', source, "انت تتلقى تقارير", "success")
    else
        TriggerClientEvent('QBCore:Notify', source, "انت لا تتلقى تقارير", "error")
    end
end, "god")

QBCore.Commands.Add("changename", "Change Your Name (1 Time)", {{name="firstname", help="firstname"}, {name="lastname", help="lastname"}}, true, function(source, args)
    if args[1] and args[2] then
        local Player = QBCore.Functions.GetPlayer(source)
        local chengd = Player.PlayerData.metadata["changedname"]
        if not chengd then  
            Player.Functions.setName(args[1], args[2])
            TriggerEvent("qb-log:server:CreateLog", "changename", "تم تغيير الاسم", "blue", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | Changed Name To: "..args[1].." " ..args[2], false)
            TriggerClientEvent('QBCore:Notify', source, 'تم تغيير اسمك بنجاح', 'success')
            TriggerClientEvent("QBCore:Server:RemoveItem", "id_card", 1)
       else
           TriggerClientEvent('QBCore:Notify', source, 'لقد نفذت المحاولة', 'error')
       end
    end
end)