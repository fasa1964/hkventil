import QtQuick
import QtQuick.Controls

Rectangle {
    id: formrect
    width: parent.width-60
    height: 220
    color: "beige"
    border.color: "magenta"


    property url image: ""
    property string caption: "Caption"


    Text {
        id: cname
        text: caption
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 15
        color: "steelblue"


        MouseArea{
            anchors.fill: parent
            //drag.active: true
            drag.target: formrect
            drag.axis: Drag.XandYAxis

        }

    }


    Image {
        id: form
        source: image
        width: parent.width
        fillMode: Image.PreserveAspectFit
        //height: parent.height-80
        anchors.centerIn: parent
    }


    Button{
        id: closebutton
        text: "X"
        width: 50
        height: 24
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
        onClicked: {  formrect.visible = false }
    }


}
