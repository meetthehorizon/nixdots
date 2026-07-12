import QtQuick
import components
import services

Card {
    Chip {
        icon: "calendar"
        iconCollection: "lucide"
        text: TimeService.dateText
    }
}
