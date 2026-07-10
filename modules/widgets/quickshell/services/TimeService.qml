pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: timeService

    property string currentTime: "00:00:00 AM"
    property string currentDate: "YYYY-MM-DD"

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            var now = new Date();

            timeService.currentTime = Qt.formatTime(now, "hh:mm:ss AP");
            timeService.currentDate = Qt.formatDate(now, "yyyy-MM-dd");
        }
    }

    Component.onCompleted: {
        var now = new Date();

        currentTime = Qt.formatTime(now, "hh:mm:ss AP");
        currentDate = Qt.formatDate(now, "yyyy-MM-dd");
    }
}
