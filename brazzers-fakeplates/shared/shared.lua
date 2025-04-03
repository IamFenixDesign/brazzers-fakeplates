Config = Config or {}

Config.Core = 'qb-core'
Config.Target = 'ox_target' -- o 'qb-target'
Config.Keys = 'qb-vehiclekeys' -- sistema de llaves
Config.FakePlateItem = 'fakeplate' -- nombre del ítem para instalar la placa falsa

Config.ProgressBar = {
    Install = {
        name = "attaching_plate",
        label = "Instalando Placa Falsa",
        duration = 5000,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            flags = 16,
        }
    },
    Remove = {
        name = "removing_plate",
        label = "Quitando Placa",
        duration = 4000,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            flags = 16,
        }
    }
}


Config.Notifications = {
    Install = {
        title = "Placa Falsa",
        description = "Has instalado una placa falsa.",
        type = "success"
    },
    Remove = {
        title = "Placa Eliminada",
        description = "Has quitado la placa falsa.",
        type = "inform"
    },
    NoItem = {
        title = "Sin Placa",
        description = "No tienes una placa falsa en tu inventario.",
        type = "error"
    },
    AlreadyFake = {
        title = "Instalación fallida",
        description = "Este vehículo ya tiene una placa falsa instalada.",
        type = "error"
    }
}


Config.TargetOptions = {
    Install = {
        label = "Instalar Placa Falsa",
        icon = "fas fa-tools"
    },
    Remove = {
       label = "Quitar Placa",
        icon = "fas fa-closed-captioning"
    }
}
