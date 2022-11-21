import QtQuick
import QtQuick.Controls


Rectangle{
    id: controlrect

    width: 80
    height: 24
//    implicitWidth: 80
//    implicitHeight: 24
    color: "transparent"

    property string buttontext: qsTr("Button")


    signal buttonPressed()

    Button {
        id: control
        text: buttontext
    //    anchors.right: graph.right
    //    anchors.bottom: graph.top
    //    anchors.bottomMargin: 5

        font.letterSpacing: 2
        font.pointSize: textsize

        contentItem: Text {
            text: control.text
            font: control.font
            opacity: enabled ? 1.0 : 0.3
            color: control.down ? "white" : "lightgreen"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight


        }

        background: Rectangle {
            implicitWidth: controlrect.width
            implicitHeight:controlrect.height
            color: "transparent"
            opacity: enabled ? 1 : 0.3
            border.color: control.down ?  "white" : "lightgreen" // "#17a81a" : "#21be2b"
            border.width: 1
            radius: 2


        }

        MouseArea{
            anchors.fill: parent
            onPressed: {  control.down = true          }
            onReleased: { control.down = false ;  buttonPressed()  }
        }
    }
}
