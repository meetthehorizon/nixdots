import QtQuick
import Quickshell.Services.UPower
import components

Card {
    hoverable: true

    readonly property var profileIcons: {
        var map = {};
        map[PowerProfile.Performance] = "zap";
        map[PowerProfile.Balanced] = "gauge";
        map[PowerProfile.PowerSaver] = "leaf";
        return map;
    }

    onClicked: {
        if (PowerProfiles.profile === PowerProfile.PowerSaver) {
            PowerProfiles.profile = PowerProfile.Balanced;
        } else if (PowerProfiles.profile === PowerProfile.Balanced) {
            if (PowerProfiles.hasPerformanceProfile) {
                PowerProfiles.profile = PowerProfile.Performance;
            } else {
                PowerProfiles.profile = PowerProfile.PowerSaver;
            }
        } else if (PowerProfiles.profile === PowerProfile.Performance) {
            PowerProfiles.profile = PowerProfile.PowerSaver;
        }
    }

    Chip {
        icon: profileIcons[PowerProfiles.profile] || "gauge"
        iconCollection: "lucide"
        text: ""
        variant: "primary"
    }
}
