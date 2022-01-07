# qb-gruppesechs
 This is an edited version of *qb-garbagejob*
 
 Pretty straight forward. Player gets truck from targeting ped. Drive to bank and use the target to get the bag. Then uses the target to put the bag inside the truck.
 
 If you have any questions, reach out to me on my discord

 https://discord.gg/S9tRGm8NSD
 
 Credits to 

 Kakarot#2550 | https://github.com/GhzGarage

 Mackaelroni#9537 | https://github.com/MahmoodHensem

 Berkiebb | https://github.com/BerkieBb/
 
 Jay ;)#6969 | https://github.com/jay-fivem

 This is my first, edited, release with QBCore. I hope you guys enjoy!
 
# Dependecies
 qb-target | https://github.com/BerkieBb/qb-target
 
 qb-radialmenu | https://github.com/qbcore-framework/qb-radialmenu
 
 lj-fuel | https://github.com/loljoshie/lj-fuel
 
# Installation

Put this snippet inside Config.JobInteractions in qb-radialmenu/config.lua

        ["gruppesechs"] = {
            {
                id = 'returnTruck',
                title = 'Return Truck',
                icon = 'torii-gate',
                type = 'client',
                event = 'gruppesechs:returnTruck',
                shouldClose = true
            },
        }
Put this snippet inside Config.Peds in qb-target/config.lua

        ["GruppeSechsPed"] = {
            model = 's_m_m_armoured_02', 
            coords = vector4(-4.04, -659.41, 33.48, 186.04),
            minusOne = true, 
            freeze = true, 
            invincible = true, 
            blockevents = true,
            target = { 
            options = {
            {
                type = "client",
                event = "gruppesechs:getTruck",
                icon = "fas fa-sign-in-alt",
                label = "Get Gruppe Sechs Truck",
	            job = "gruppesechs",
            },
            {
                type = "server",
                event = "gruppesechs:server:PayShift",
                icon = "fas fa-sign-in-alt",
                label = "Collect Pay Check",
	            job = "gruppesechs",					
            },
        },
        distance = 1.5,
    },

 Put this in shared.lua in qb-core/shared.lua
 
	['gruppesechs'] = {
        label = 'Gruppe 6',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = {
                name = 'Collector',
                payment = 50
            },
        },
    },        


# License

    QBCore Framework
    Copyright (C) 2021 Joshua Eger

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>
