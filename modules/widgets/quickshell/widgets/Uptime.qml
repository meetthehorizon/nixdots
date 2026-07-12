import QtQuick
import components
import services

Card {
    Chip {
        icon: "timer"
        iconCollection: "lucide"
        text: UptimeService.uptimeText
    }
}
