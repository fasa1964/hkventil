import QtQuick
import QtQuick.Controls

Page {
    id: valvepage
    objectName: qsTr("Valve")
    title: qsTr("Valve")
    background: Rectangle{
        color: "#FEFCFF" // MilkWhite
    }

    Label{
        id: caption
        text: valvepage.title
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
        font.pointSize: captionsize
        font.letterSpacing: 2
        color: "#2B547E" // Blue Jay
    }

    Rectangle{
        width: caption.width
        height: 1
        color: "#2B547E" // Blue Jay
        anchors.top: caption.bottom
        anchors.left: caption.left

    }
}
