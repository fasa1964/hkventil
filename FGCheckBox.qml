import QtQuick
import QtQuick.Controls

Rectangle{
    id: controlrect

    implicitWidth: outrect.width + 2 + controltext.width + 5    // 100
    implicitHeight: 24

    signal checkBoxChanged()

    property string boxtext: qsTr("CheckBox")
    property bool controldown: false
    property bool controlchecked: false
    property real spacing: 1.5
    //property int textsize: 11

    color: "transparent"
    //border.color: "lightgreen"

    Rectangle {
        id: outrect
        implicitWidth: 20
        implicitHeight: 20
        x: 0 //controlrect.leftPadding
        y: parent.height / 2 - height / 2
        radius: 3
        border.color: controldown ? "#17a81a" : "#21be2b"
        color: "transparent"


        // Innerrect
        Rectangle {
            id: innerrect
            width: 10
            height: 10
            x: 5
            y: 5
            radius: 1
            color: controldown ? "#17a81a" : "#21be2b"
            visible: controlchecked
        }
    }

    Text{
        id: controltext
        text: boxtext
        color: "lightgreen"
        font.letterSpacing: spacing
        font.pointSize: textsize
        x: outrect.width + 4
        y: controlrect.height / 2 - (controltext.height / 2) - 1

    }


    MouseArea{
        anchors.fill: parent
        onPressed: {   controldown = true  }
        onReleased: {

            if(!controlchecked)
                controlchecked = true
            else
                controlchecked = false

            checkBoxChanged()

        }
    }

}





