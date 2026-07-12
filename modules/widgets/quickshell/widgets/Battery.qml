import QtQuick
import Quickshell.Services.UPower
import components

Card {
    id: root

    function formatSeconds(seconds) {
        if (seconds <= 0 || seconds > 86400) return "";
        var hours = Math.floor(seconds / 3600);
        var minutes = Math.floor((seconds % 3600) / 60);
        if (hours > 0) {
            return hours + "h " + minutes + "m";
        }
        return minutes + "m";
    }

    Chip {
        icon: {
            var pct = Math.round(UPower.displayDevice.percentage);
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
        text: {
            var pct = Math.round(UPower.displayDevice.percentage);
            var state = UPower.displayDevice.state;
            var timeToEmpty = UPower.displayDevice.timeToEmpty;
            var timeToFull = UPower.displayDevice.timeToFull;

            var baseText = pct + "%";

            if (state === UPowerDeviceState.Charging && timeToFull > 0) {
                var fullTime = formatSeconds(timeToFull);
                if (fullTime !== "") {
                    return baseText + " (" + fullTime + " to full)";
                }
            } else if (state === UPowerDeviceState.Discharging && timeToEmpty > 0) {
                var emptyTime = formatSeconds(timeToEmpty);
                if (emptyTime !== "") {
                    return baseText + " (" + emptyTime + " left)";
                }
            } else if (state === UPowerDeviceState.FullyCharged) {
                return "100% (Charged)";
            }

            return baseText;
        }
    }
}
