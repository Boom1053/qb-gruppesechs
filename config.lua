Config = {}

-- Price taken and given back when delivered a truck
Config.TruckPrice = 250

-- Want to give out a security card per stop?
Config.GiveSecurityCardChance = true

-- Has to roll this number or higher to receive a security card
Config.SecurityCardChance = 75

-- How many stops minimum should the job roll?
Config.MinStops = 1

-- Upper worth per bag
Config.BagUpperWorth = 100

-- Lower worth per bag
Config.BagLowerWorth = 50

-- Minimum bags per stop
Config.MinBagsPerStop = 2

-- Maximum bags per stop
Config.MaxBagsPerStop = 5

-- WIP: Do not use
-- If you want to use custom routes instead of random amount of stops stops set to true
Config.UsePreconfiguredRoutes = false

Config.Locations = {
    ["main"] = {
        label = "Gruppe Sechs",
        coords = vector3(-4.08, -659.24, 33.48),
    },
    ["vehicle"] = {
        label = "Gruppe Sechs Truck Storage",
        coords = vector4(-4.78, -670.9, 31.94, 188.79),
    },
    ["paycheck"] = {
        label = "Payslip Collection",
        coords = vector3(-7.23, -653.93, 33.45),
    },
    ["banks"] ={
        [1] = {
            name = "Paleto Bank",
            coords = vector4(-107.51, 6469.16, 31.63, 52.68),    
            pz = vector3(-108.04, 6469.66, 31.63),
            length = 1.4,
            width = 1,
            heading=315,
            minZ=30.63,
            maxZ=33.03,
            debugPz = false        
        },
         [2] = {
             name = "Sandy Bank",
             coords = vector4(1179.16, 2708.96, 38.09, 100.68),
             pz = vector3(1178.72, 2708.84, 38.09),
             length = 1,
             width = 1,
             heading=0,
             minZ=37.09,
             maxZ=39.29,
             debugPz = false    
         },
         [3] = {
            name = "Great Ocean Bank",
            coords = vector4(-2960.86, 478.65, 15.7, 14.72),
             pz = vector3(-2960.69, 479.11, 15.7),
             length = 1,
             width = 1,
             heading=355,
             minZ=14.7,
             maxZ=16.9,
            debugPz = false  
         },
         [4] = {
             name = "Pacific Bank",
             coords = vector4(256.7, 220.11, 106.29, 346.34),
             pz = vector3(256.9, 220.36, 106.29),
             length = 1.2,
             width = 1,
             heading=250,
             minZ=105.29,
             maxZ=107.89,
             debugPz = false   
         },
         [5] = {
             name = "Harwick St Bank",
             coords = vector4(309.55, -279.62, 54.16, 259.4),
             pz = vector3(309.92, -279.67, 54.16),
             length = 1,
             width = 1,
             heading=340,
             minZ=53.56,
             maxZ=55.56,
             debugPz = false 
         },   
         [6] = {
             name = "Harwick 2 Bank",
             coords = vector4(-355.53, -50.3, 49.04, 261.52),
             pz = vector3(-355.58, -50.47, 49.04),
             length = 1,
             width = 1,
             heading=340,
             minZ=48.04,
             maxZ=50.24,
             debugPz = false       
         },
         [7] = {
             name = "Del Perro Bank",
             coords = vector4(-1215.54, -334.33, 37.78, 337.61),
             pz = vector3(-1215.26, -334.28, 37.78),
             length = 1,
             width = 1,
             heading=25,
             minZ=36.83,
             maxZ=39.23,
             debugPz = false          
         },
         [8] = {
             name = "Legion Sq Bank",
             coords = vector4(145.28, -1041.08, 29.37, 252.66),
             pz = vector3(145.76, -1041.39, 29.37),
             length = 1,
             width = 1,
             heading=340,
             minZ=28.37,
             maxZ=30.57,
             debugPz = false  
         },
    },
    ["routes"] = { -- Custom routes (WIP Do not use)
        [1] = {4, 6, 5, 3, 1},
        [2] = {1, 4, 3, 6, 8},
        [3] = {1, 7, 8, 3, 6},
        [4] = {2, 4, 6, 8, 3},
        [5] = {7, 8, 1, 2, 3},
        [6] = {2, 1, 3, 4, 8},
        [7] = {8, 1, 7, 2, 6},
        [8] = {1, 8, 2, 7, 6},
        [9] = {7, 6, 5, 8, 3},
        [10] = {1, 3, 2, 5, 4}
    }
}

Config.Vehicles = {
    ["stockade"] = "Gruppe Sechs",
}
