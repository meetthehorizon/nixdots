pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property string time: Qt.formatDateTime(clock.date, "hh:mm AP")
    readonly property string dateText: Qt.formatDateTime(clock.date, "ddd, MMM d")

    readonly property string clockIcon: {
        var h = clock.date.getHours() % 12;
        var hour = h === 0 ? 12 : h;
        return "clock-" + hour;
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
