import QtQuick

Rectangle {
    id: button
    width: 140
    height: 75

    border.color: "gray"
    border.width: down ? 2 : 1
    gradient: Gradient{
        GradientStop{ position: 0.0; color: down ? "gray" : "lightgray"}
        GradientStop{ position: down ? 0.7 : 0.5; color: "lightgray"}
        GradientStop{ position: 1.0; color: "white"}
    }

    signal buttonClicked()

    property string buttontext: "This is my text"
    property string textcolor: "black"
    property int textsize: 12
    property bool down: false


    Text {
        id: btext
        text: buttontext
        anchors.centerIn: parent
        font.pointSize: textsize
        font.letterSpacing: 1
        color: down ? "green" : textcolor

    }


    MouseArea{
        anchors.fill: parent
        onPressed: {  down = true  }
        onReleased: { down = false; buttonClicked()  }
    }

}
