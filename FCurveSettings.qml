import QtQuick
import QtQuick.Controls

Rectangle {
    id: settingsrect
    width: parent.width-80
    height: 150
    x:40

    anchors.top: graph.top
    anchors.topMargin: 40
    z:2

    border.color: "lightgreen"
    gradient: Gradient{

        GradientStop { position: 0.0; color: "#021a06" }
        GradientStop { position: 1.0; color: "darkgreen" }

    }


    property int slidervalue: 150
    property real xposvalue: 5.0

    signal acceptSetting()
    signal cancelSetting()

    Grid{
        id: settingsgrid
        columns: 3
        rows: 2
        spacing: android ? 15 : 20
        width: parent.width-40

        x: 20
        y: 20
        Text {
            id: ttext
            text: qsTr("Timerinterval")
            font.pointSize: android ? 10 : textsize
            color: "lightgreen"
        }

        FGSlider{
            id: timerslider
            value: settingsrect.slidervalue
            width:  settingsrect.width - vtext.width - ttext.width - 80
            height: ttext.height
            onValueChanged: {  slidervalue = timerslider.value  }
        }

        Text {
            id: vtext
            text: timerslider.value
            font.pointSize: android ? 10 : textsize
            color: "lightgreen"
        }

        Text {
            text: qsTr("Increase XPos")
            font.pointSize: android ? 10 : textsize
            color: "lightgreen"
        }

        FGSlider{
            id: xposslider
            width: timerslider.width
            height: timerslider.height
            value: settingsrect.xposvalue
            from: 1
            to: 10
            stepSize: 0.5
            onValueChanged: {  xposvalue = xposslider.value  }


        }
        Text {
            text: xposslider.value
            font.pointSize: android ? 10 : textsize
            color: "lightgreen"
        }
    }




    FGButton{
        id: okbutton
        width: 60
        height: 24
        buttontext: "OK"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        anchors.rightMargin: 5
        onButtonPressed: {  acceptSetting() }
    }

    FGButton{
        id: cancelbutton
        width: 60
        height: 24
        buttontext: "Cancel"
        anchors.right: okbutton.left
        anchors.rightMargin: 10
        anchors.top: okbutton.top
        onButtonPressed: {  cancelSetting() }

    }

}

