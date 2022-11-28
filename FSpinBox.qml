import QtQuick
import QtQuick.Controls

Rectangle {
    id: control

    implicitWidth: value  > 999 ? 140 : 120 && floatvalue  > 99.9 ? 140 : 120
    implicitHeight: 28

    color: "transparent"
    border.color: "green"


    property int fontsize: control.height-12
    property int value: 55
    property double floatvalue: 0.0

    property string downcolor: "#008080" // Teal
    property bool downleft: false
    property bool downright: false
    property bool realvalue: false
    property int digits: 1
    property string handlecolor: "lightgreen"

    signal valueChaned(double val)


    function getValue(){

        var val =  0 //realvalue ? control.floatvalue ? control.value

        if(realvalue)
            val = control.floatvalue.toFixed(2)
        else
            val = control.value

        return val

    }

    Timer{
        id:timer
        interval: 10000
        running: false
        repeat: true
        onTriggered: endOfEditing()

    }

    function endOfEditing(){   timer.running = false; input.editingFinished()  }

    TextInput{
        id: input
        visible: false
        cursorVisible: true
        width: parent.width
        height: parent.height
        text:  getValue()
        //font: control.font
        font.pointSize: control.fontsize
        font.bold: true
        color:  "blue" // "#21be2b"
        selectionColor: "#21be2b"
        selectedTextColor: "#ffffff"
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        inputMethodHints: Qt.ImhDigitsOnly
        onEditingFinished: {

            if(realvalue)
                control.floatvalue = input.displayText;
            else
                control.value = input.displayText;

            input.visible = false
            valuetext.visible = true

            valueChaned( realvalue ? control.floatvalue : control.value)

            cursorVisible = false
        }
    }

    // Left handle
    Rectangle{
        id: lefthandle
        width: parent.width/3-5
        height: parent.height
        border.color: "green"
        color: handlecolor

        opacity: 1

        Rectangle{
            height: 2
            width: parent.width/2
            anchors.centerIn: parent
            color: downleft ? downcolor : "white"

        }

        MouseArea{
            anchors.fill: parent
            onPressed: { downleft = true; input.editingFinished() }
            onReleased: {
                downleft = false

                if(realvalue){
                    if(digits === 1)
                        floatvalue = floatvalue - 0.1
                    if(digits === 2)
                        floatvalue = floatvalue - 0.01

                }else
                    value = value - 1


                valueChaned( realvalue ? control.floatvalue : control.value)

            }
        }
    }

    Text{
        id: valuetext
        visible: true
        text: realvalue ? floatvalue.toFixed(digits) : value
        anchors.centerIn: parent
        font.pointSize: fontsize
        color: "#31906E"

        MouseArea{
            anchors.fill: parent
            onClicked: {
                input.visible = true
                valuetext.visible = false
                timer.start()
            }
        }
    }

    // Right handle
    Rectangle{
        id: righthandle
        width: parent.width/3-5
        height: parent.height
        border.color: "green"
        color: handlecolor
        opacity: 1
        anchors.right: parent.right

        Rectangle{
            height: 2
            width: parent.width/2
            anchors.centerIn: parent
            color:  downright ? downcolor : "white"

        }
        Rectangle{
            height: parent.width/2
            width: 2
            anchors.centerIn: parent
            color: downright ? downcolor : "white"
        }

        MouseArea{
            anchors.fill: parent
            //propagateComposedEvents: true
            //pressAndHoldInterval: 500
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onPressed: { downright = true; input.editingFinished() }
            onReleased: {
                downright = false

                if(realvalue){
                    if(digits === 1)
                        floatvalue = floatvalue + 0.1
                    if(digits === 2)
                        floatvalue = floatvalue + 0.01

                }else
                    value = value + 1


                valueChaned( realvalue ? control.floatvalue.toFixed(digits) : control.value)
            }
        }
    }


}
