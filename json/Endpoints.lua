
dofile(CommonConfDir.."/Utils.lua")

local ip = "127.0.0.1"
local stationId = "DevelStation"
local machineId = stationId


Endpoints = {
    --CreateEndpoint(id, name, type, ip, mgmtPort, isMaster, machineId, stationId, processId, windows)

    -- Hosts
    CreateEndpoint(102, "SimHost-1", "Master", ip, 9000, true, machineId, stationId, "SimHost"),
      CreateEndpoint(103, "SimHost-2", "Host", ip, 9001, true, machineId, stationId, "SimHost"),
  
    -- Image Generators
    --CreateEndpoint(100, "IgWithSound", "IG", ip, 9100, false, machineId, stationId, "SimIG-SND",
    CreateEndpoint(101, "IgNoSound", "IG", ip, 9101, false, machineId, stationId, "SimIG",
        -- windows (used by IG endpoints only); if empty, defaults from IGSettings.lua will be used
        {
        --{ Name="0"   , Display=1, Position={   0,   0}, Size={500,  600}, Borderless=false, Title="Window 0"},
        --{ Name="1"   , Display=2, Position={ 600 ,  0}, Size={500,  800}, Borderless=false, Title="Window 1"},
        }
    ),

    -- Sound Generators
    --CreateEndpoint(200, "SND", "Sound", ip, 9200, false, machineId, stationId, "SimSound")
}

-- The following processes are NOT managed by IgManager, the system does not wait for them.
-- They need to be registered here so they can share the same configuration mechanism as the managed nodes above.
-- (That mechanism is based on the StationName variable matching the Name field of the Endpoint record.
--  If the name is not found among Endpoint records, we try OtherStation records)
OtherStations =
{
  CreateEndpoint(999, "IgManager", "Other", ip, 10000, true, machineId, stationId, "IgManager" ), -- DON'T DELETE THIS ONE!
  CreateEndpoint(300, "ScriptApp", "Other", ip, 10001, false, machineId, stationId, "ScriptApp" )
}

-- system manager application computer
SysMgrIP = ip


