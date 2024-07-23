local inputFirmwarePath = arg[1]
local customFsPath = arg[2]
local outputFirmwarePath = arg[3]
local fsOffset = 1114112

local firmware = io.open(inputFirmwarePath, "rb")
assert(firmware, "Failed to open firmware file")
local firmware_data = firmware:read("*a")
firmware:close()

local customFs = io.open(customFsPath, "rb")
assert(customFs, "Failed to open customfs file")
local customFsData = customFs:read("*a")
customFs:close()

local customFirmware = io.open(outputFirmwarePath, "wb")
assert(customFirmware, "Failed to open custom firmware file")
customFirmware:write(firmware_data)
customFirmware:seek("set", fsOffset)
customFirmware:write(customFsData)
while customFirmware:seek() % 4096 ~= 0 do
    customFirmware:write("\0")
end
customFirmware:close()
