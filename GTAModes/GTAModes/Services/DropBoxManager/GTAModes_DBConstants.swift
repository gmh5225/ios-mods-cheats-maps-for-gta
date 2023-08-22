import Foundation

struct GTA_DBKeys {
    
    static let RefreshTokenSaveVar = "refresh_token"
    
    static let appkey = "y8y8p6rle3019pa"
    static let appSecret = "gxqc3i47om2c28c"
    static let token = "czHFetFkAxAAAAAAAAADk1hBEe_vAvO-zr53c8G0bYA"
    static let refresh_token = "75fM007QbHcAAAAAAAAAAePqm-_8A19EfyZFd6StuVItH_FDp4TTmU3URvAgOMBp"
    
    static let apiLink = "https://api.dropboxapi.com/oauth2/token"

    enum gta_Path: String {
        case gtasa_modes = "/Cheats/GTA-SA/cheats_GTA-SA.json"
        case gtavc_modes = "/Cheats/GTA-VC/cheats_GTA-VC.json"
        case gta5_modes = "/Cheats/GTA5/cheats_GTA5.json"
        case gta6_modes = "/Cheats/GTA6/cheats_GTA6.json"
        case main = "/main/main.json"
        case gameList = "/gameList/gameList.json"
        case checkList = "/cheklist/checklist.json"
        case modsGTA5List = "/mods/mods_GTA5.json"
        
    }
}
