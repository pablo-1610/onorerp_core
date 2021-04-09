--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local radioTower = {
    vector3(-130.6582, -1269.2, 59.55974),
    vector3(-335.6062, -1052.674, 85.56822),
    vector3(-611.4618, -706.2348, 140.245),
    vector3(-895.8414, -445.671, 182.5538),
    vector3(-149.9418, -145.1116, 111.8538),
    vector3(483.3548, -101.463, 129.7852),
    vector3(433.8626, 188.0228, 168.1006),
    vector3(-667.8592, 227.877, 159.603),
    vector3(1616.828, 2588.1, 153.2468),
    vector3(111.6078, 4472.896, 275.8354),
    vector3(2396.216, 6046.718, 283.3406),
    vector3(-88.92468, 6546.954, 179.7718),
    vector3(-1240.444, -2938.13, 148.161),
    vector3(1297.224, -2074.56, 148.4942),
    vector3(2417.116, -361.7844, 196.6708),
}


Onore.newThread(function()
    exports.saltychat:SetRadioTowers(radioTower)
end)