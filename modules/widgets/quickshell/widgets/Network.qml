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
