pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property string time: Qt.formatDateTime(clock.date, "hh:mm AP")
    readonly property string dateText: Qt.formatDateTime(clock.date, "ddd, MMM d")
    readonly property var currentDate: clock.date

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
