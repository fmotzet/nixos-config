import Quickshell
import QtQuick
import Quickshell.Hyprland

// quickshell -p path

ShellRoot {
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            // create this on every connected screen https://quickshell.org/docs/v0.3.0/types/Quickshell/Quickshell/?highlight=modeldata#reusing-a-window-on-every-screen
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: 28
            // alpha first AARRGGBB
            color: "#001e1e2e"

            Text {
                anchors.centerIn: parent
                color: "#050505"
                font.pixelSize: 14
                font.bold:true
                font.family: "JetBrainsMono Nerd Font"
                text: Qt.formatDateTime(clock.date, "dd/MM  hh:mm dddd")
                MouseArea {
                    acceptedButtons: Qt.AllButtons
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: (mouse) => {
                        if (mouse.button === Qt.RightButton) {
                            Qt.openUrlExternally("https://www.schnelle-online.info/Kalender.html")
                        }
                        else if (mouse.button === Qt.LeftButton) {
                            Qt.openUrlExternally("https://calendar.google.com/calendar/u/0/r?pli=1")
                        }
                        // open the default calendar app when clicking on the clock
                        // Qt.openUrlExternally("calendar://")
                    }
                }
            }
            Text {
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: 10
                }
                color: "#ff0000"
                font.pixelSize: 14
                font.bold:true
                font.family: "JetBrainsMono Nerd Font"
                text: Hyprland.monitorFor(modelData)?.activeWorkspace?.name ?? "[]"
            }
        }
    }
}