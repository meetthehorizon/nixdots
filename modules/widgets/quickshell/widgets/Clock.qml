import QtQuick
import components
import services

Card {
    Chip {
        icon: {
            if (!TimeService.currentDate)
                return "clock-12";
            var h = TimeService.currentDate.getHours() % 12;
            var hour = h === 0 ? 12 : h;
            return "clock-" + hour;
        }
        iconCollection: "lucide"
        text: TimeService.time
    }
}
