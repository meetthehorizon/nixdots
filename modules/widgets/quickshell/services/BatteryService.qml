pragma Singleton
import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root

    property string percent: UPower.displayDevice.ready ? Math.round(UPower.displayDevice.percentage) + "%" : "..."

    property bool isCharging: UPower.displayDevice.ready && UPower.displayDevice.state === UPowerDeviceState.Charging
}
