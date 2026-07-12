pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string brightnessText: "100%"

    // 10-second fallback timer just to be absolutely sure
    Timer {
        id: fallbackTimer
        interval: 10000
        repeat: true
        running: true
        onTriggered: {
            if (!brightnessProcess.running) {
                brightnessProcess.running = true;
            }
        }
    }

    // Query current brightness
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

    // Monitor backlight change events in real time
    Process {
        id: udevMonitor
        command: ["udevadm", "monitor", "--subsystem=backlight"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                if (!brightnessProcess.running) {
                    brightnessProcess.running = true;
                }
            }
        }
    }
}
