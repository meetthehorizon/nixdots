import QtQuick
import Quickshell.Networking
import components

Card {
    id: root

    readonly property var activeInfo: {
        var info = { ssid: "", type: "" };
        var devList = Networking.devices.values;
        if (devList) {
            for (var i = 0; i < devList.length; i++) {
                var dev = devList[i];
                if (dev && dev.connected) {
                    if (dev.networks && dev.networks.values) {
                        var nets = dev.networks.values;
                        for (var j = 0; j < nets.length; j++) {
                            var net = nets[j];
                            if (net && net.connected) {
                                info.ssid = net.name;
                                info.type = "wifi";
                                break;
                            }
                        }
                    } else if (dev.network && dev.network.connected) {
                        info.ssid = dev.network.name;
                        info.type = "wired";
                    }
                }
                if (info.ssid !== "") break;
            }
        }
        return info;
    }

    Chip {
        icon: {
            switch (Networking.connectivity) {
                case Networking.Full:
                    if (activeInfo.type === "wired")
                        return "network";
                    return "wifi";
                case Networking.Limited:
                    if (activeInfo.type === "wired")
                        return "network";
                    return "wifi-low";
                case Networking.Portal:
                    return "wifi-zero";
                case Networking.None:
                case Networking.Unknown:
                default:
                    return "wifi-off";
            }
        }
        iconCollection: "lucide"
        text: ""
    }
}
