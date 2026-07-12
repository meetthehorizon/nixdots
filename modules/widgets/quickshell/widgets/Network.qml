import QtQuick
import Quickshell.Networking
import components

Card {
    Chip {
        icon: {
            switch (Networking.connectivity) {
                case Networking.Full:
                    return "wifi";
                case Networking.Limited:
                    return "wifi-low";
                case Networking.Portal:
                    return "wifi-zero";
                case Networking.None:
                    return "wifi-off";
                case Networking.Unknown:
                default:
                    return "wifi-off";
            }
        }
        iconCollection: "lucide"
        text: {
            switch (Networking.connectivity) {
                case Networking.Full:
                    var ssid = "";
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
                                            ssid = net.name;
                                            break;
                                        }
                                    }
                                } else if (dev.network && dev.network.connected) {
                                    ssid = dev.network.name;
                                }
                            }
                            if (ssid !== "") break;
                        }
                    }
                    if (ssid !== "") {
                        var maxLength = 10;
                        if (ssid.length > maxLength) {
                            return ssid.substring(0, maxLength - 1) + "…";
                        }
                        return ssid;
                    }
                    return "Online";
                case Networking.Limited:
                    return "Limited";
                case Networking.Portal:
                    return "Portal";
                case Networking.None:
                    return "Offline";
                case Networking.Unknown:
                default:
                    return "Unknown";
            }
        }
    }
}
