import QtQuick
import QtQuick.Controls

Page {
    id: resultpage
    objectName: qsTr("Result")
    title: qsTr("Result")
    background: Rectangle{
        color: "#FDEEF4" // Pearl
    }

    Label{
        id: caption
        text: resultpage.title
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
