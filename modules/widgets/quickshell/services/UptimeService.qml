pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string uptimeText: "up 0m"

    Timer {
        id: pollTimer
        interval: 30000 // Poll every 30 seconds
        repeat: true
        running: true
        onTriggered: {
            if (!uptimeProcess.running) {
                uptimeProcess.running = true;
            }
        }
    }

    Process {
        id: uptimeProcess
        command: ["cat", "/proc/uptime"]
        running: true // Run once on startup

        stdout: StdioCollector {
            onStreamFinished: {
                var textVal = this.text.trim();
                var parts = textVal.split(" ");
                if (parts.length > 0) {
                    var uptimeSeconds = parseFloat(parts[0]);
                    if (!isNaN(uptimeSeconds)) {
                        var days = Math.floor(uptimeSeconds / 86400);
                        var hours = Math.floor((uptimeSeconds % 86400) / 3600);
                        var minutes = Math.floor((uptimeSeconds % 3600) / 60);

                        var displayParts = [];
                        if (days > 0) displayParts.push(days + "d");
                        if (hours > 0) displayParts.push(hours + "h");
                        if (minutes > 0 || (days === 0 && hours === 0)) displayParts.push(minutes + "m");

                        root.uptimeText = "up " + displayParts.join(" ");
                    }
                }
            }
        }
    }
}
