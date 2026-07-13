import QtQuick
import components
import Quickshell.Bluetooth

Card {
    readonly property bool isEnabled: Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled
    readonly property var devicesList: Bluetooth.devices && Bluetooth.devices.values ? Bluetooth.devices.values : []
    readonly property int connectedCount: {
        var count = 0;
        for (var i = 0; i < devicesList.length; i++) {
            if (devicesList[i].connected) {
                count++;
            }
        }
        return count;
    }

    Chip {
        icon: {
            if (!isEnabled) {
                return "bluetooth-off";
            } else if (connectedCount > 0) {
                return "bluetooth-connected";
            } else {
                return "bluetooth";
            }
        }
        iconCollection: "lucide"
        variant: "primary"
        text: ""
    }
}

