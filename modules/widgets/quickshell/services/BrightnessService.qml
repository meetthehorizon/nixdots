pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string brightnessText: "100%"

    Timer {
        id: pollTimer
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            if (!brightnessProcess.running) {
                brightnessProcess.running = true;
            }
        }
    }

    Process {
        id: brightnessProcess
        command: ["brightnessctl", "-m"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                var textVal = this.text.trim();
                var parts = textVal.split(",");
                if (parts.length >= 4) {
                    root.brightnessText = parts[3].trim();
                }
            }
        }
    }
}
