import QtQuick

Rectangle{
    id: control
    width: 75
    height: 24
    //implicitWidth: 75
    //implicitHeight: 24
    border.color: "lightgreen"
    color: "transparent"

    property int max: 30
    property int min: 6

    property int value: 20

    signal tempChanged()

    Rectangle{
        id: lefthandle
        width: parent.width/3
        height: parent.height
        border.color: "lightgreen"
        color: "transparent"
        Text { text: "-"; color: "lightgreen"; font.pointSize: textsize+6; anchors.centerIn: parent }
        MouseArea{
            anchors.fill: parent
            onClicked: {

                if(control.value >= control.min+1){
                    control.value--
                    tempChanged()
                }
            }

        }
    }

    Text {
        id: display
        text: control.value
        color: "lightgreen";
        font.pointSize: textsize
        anchors.centerIn: parent
    }


    Rectangle{
        id: righthandle
        width: parent.width/3
        height: parent.height
        anchors.right: parent.right
        border.color: "lightgreen"
        color: "transparent"
        Text { text: "+"; color: "lightgreen"; font.pointSize: textsize+8; anchors.centerIn: parent }

        MouseArea{
            anchors.fill: parent
            onClicked: {

                if(control.value <= control.max-1){
                    control.value++
                    tempChanged()
                }
            }
        }

    }
}

