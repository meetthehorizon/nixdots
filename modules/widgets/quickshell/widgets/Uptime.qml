import QtQuick
import components
import services

Card {
    Chip {
        icon: "nixos"
        iconCollection: "simpleicons"
        text: UptimeService.uptimeText
    }
}
