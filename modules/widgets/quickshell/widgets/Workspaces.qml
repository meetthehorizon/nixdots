import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import components
import globals

RowLayout {
    id: root
    spacing: Theme.spacing.s1

    function getWindowIcon(wClass, wTitle) {
        wClass = wClass || "";
        wTitle = wTitle || "";
        
        var cls = wClass.toLowerCase();
        var title = wTitle.toLowerCase();
        
        // org.wezfurlong.wezterm rules
        if (cls === "org.wezfurlong.wezterm" || cls === "wezterm") {
            if (title.indexOf("nvim") !== -1) return { icon: "neovim", collection: "simpleicons" };
            if (title.indexOf("yazi") !== -1) return { icon: "folder", collection: "lucide" };
            if (title.indexOf("gdu") !== -1) return { icon: "hard-drive", collection: "lucide" };
            if (title.indexOf("wifitui") !== -1) return { icon: "wifi", collection: "lucide" };
            return { icon: "terminal", collection: "lucide" };
        }
        
        // kitty terminal rules
        if (cls.indexOf("kitty") !== -1) {
            if (title.indexOf("nvim") !== -1) return { icon: "neovim", collection: "simpleicons" };
            return { icon: "kitty.png", collection: "custom" };
        }
        
        // Firefox / Zen
        if (cls.indexOf("firefox") !== -1) return { icon: "firefox", collection: "simpleicons" };
        if (cls.indexOf("zen") !== -1) return { icon: "globe", collection: "lucide" };
        
        // Thunderbird / Mail
        if (cls.indexOf("thunderbird") !== -1) return { icon: "thunderbird", collection: "simpleicons" };
        
        // TablePlus
        if (cls.indexOf("tableplus") !== -1) return { icon: "tableplus", collection: "simpleicons" };
        
        // Bitwarden
        if (title.indexOf("bitwarden") !== -1) return { icon: "bitwarden", collection: "simpleicons" };
        
        // Zathura
        if (cls === "zathura") return { icon: "file-text", collection: "lucide" };
        
        // Discord
        if (cls.indexOf("discord") !== -1) return { icon: "discord", collection: "simpleicons" };
        
        // Bluetuith
        if (title.indexOf("bluetuith") !== -1) return { icon: "bluetooth", collection: "lucide" };
        
        // Cryptomator
        if (cls.indexOf("cryptomator") !== -1) return { icon: "cryptomator", collection: "simpleicons" };
        
        // Seahorse (Gnome Passwords)
        if (cls.indexOf("seahorse") !== -1) return { icon: "key", collection: "lucide" };
        
        // Godot
        if (cls.indexOf("godot") !== -1) return { icon: "godotengine", collection: "simpleicons" };
        
        // Anki
        if (cls.indexOf("anki") !== -1) return { icon: "anki", collection: "simpleicons" };
        
        // OBS Studio
        if (cls === "com.obsproject.studio") return { icon: "obsstudio", collection: "simpleicons" };
        
        // Polkit Agent
        if (cls.indexOf("hyprpolkitagent") !== -1) return { icon: "shield-alert", collection: "lucide" };
        
        // Timeshift
        if (cls.indexOf("timeshift") !== -1) return { icon: "history", collection: "lucide" };
        
        // Antigravity
        if (cls.indexOf("antigravity") !== -1) return { icon: "cpu", collection: "lucide" };
        
        // Hyprland
        if (cls.indexOf("hyprland") !== -1) return { icon: "layout", collection: "lucide" };
        
        // Scrcpy
        if (cls.indexOf("scrcpy") !== -1) return { icon: "smartphone", collection: "lucide" };
        
        // Variety
        if (cls.indexOf("variety") !== -1) return { icon: "image", collection: "lucide" };
        
        // Super Productivity
        if (cls.indexOf("superproductivity") !== -1) return { icon: "check-square", collection: "lucide" };
        
        // LibreOffice
        if (cls.indexOf("libreoffice") !== -1) return { icon: "libreoffice", collection: "simpleicons" };
        
        // KDE
        if (cls.indexOf("kde") !== -1) return { icon: "kde", collection: "simpleicons" };
        
        // Postman
        if (cls.indexOf("postman") !== -1) return { icon: "postman", collection: "simpleicons" };
        
        // ProtonVPN
        if (cls.indexOf("proton") !== -1 || cls.indexOf("vpn") !== -1) return { icon: "protonvpn", collection: "simpleicons" };
        
        // Obsidian
        if (cls === "obsidian") return { icon: "obsidian", collection: "simpleicons" };
        
        // Rofi
        if (cls === "rofi") return { icon: "search", collection: "lucide" };
        
        // Spotify
        if (cls === "spotify") return { icon: "spotify", collection: "simpleicons" };
        
        // Steam
        if (cls === "steam") return { icon: "steam", collection: "simpleicons" };
        
        // Generic Fallback
        return { icon: "app-window", collection: "lucide" };
    }

    readonly property var sortedWorkspaces: {
        if (!Hyprland.workspaces || !Hyprland.workspaces.values) return [];
        var arr = Hyprland.workspaces.values;
        return arr.slice().sort(function(a, b) { return a.id - b.id; });
    }

    Repeater {
        model: root.sortedWorkspaces
        delegate: Card {
            id: workspaceCard
            variant: modelData.focused ? "accent" : "primary"
            hoverable: true
            onClicked: modelData.activate()

            RowLayout {
                spacing: Theme.spacing.s1

                Label {
                    text: modelData.name
                    variant: modelData.focused ? "accent" : "muted"
                    font.bold: modelData.focused
                }

                // Small separator between name and icons if there are icons
                Rectangle {
                    visible: modelData.toplevels && modelData.toplevels.values && modelData.toplevels.values.length > 0
                    width: 1
                    height: Theme.spacing.s4
                    color: Theme.color.border
                    opacity: 0.5
                }

                Repeater {
                    model: modelData.toplevels ? modelData.toplevels.values : []
                    delegate: Icon {
                        property var iconInfo: root.getWindowIcon(
                            modelData.lastIpcObject ? modelData.lastIpcObject["class"] : "",
                            modelData.title
                        )
                        icon: iconInfo.icon
                        collection: iconInfo.collection
                        size: Theme.spacing.s4
                        variant: modelData.focused ? "accent" : "primary"
                    }
                }
            }
        }
    }
}

