import QtQuick
import Quickshell.Services.UPower
import components

Card {
    id: root

    Chip {
        icon: {
            var pct = Math.round(UPower.displayDevice.percentage * 100);
            var state = UPower.displayDevice.state;

            if (state === UPowerDeviceState.Charging || state === UPowerDeviceState.PendingCharge) {
                return "battery-charging";
            }

            if (pct >= 85) {
                return "battery-full";
            } else if (pct >= 40) {
                return "battery-medium";
            } else if (pct >= 15) {
                return "battery-low";
            } else {
                return "battery-warning";
            }
        }
        iconCollection: "lucide"
        text: ""
    }
}
