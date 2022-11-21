import QtQuick
import QtQuick.Controls

Page {
    id: pumppage
    objectName: qsTr("Pump")
    title: qsTr("Pump calculator")
    background: Rectangle{
        color: "#F8B88B" // Pearl
    }

    Label{
        id: caption
        text: pumppage.title
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
        font.pointSize: captionsize
        font.letterSpacing: 2
        color: "white" // Blue Jay
    }

    Rectangle{
        id: line
        width: caption.width
        height: 1
        color: "white" // Blue Jay
        anchors.top: caption.bottom
        anchors.left: caption.left
    }

    function resultConveyorHeight(){
        var h = 0.0

        // H = R x L x ZF / 10.000
        h = (r.value * l.value * zf.floatvalue) / 10000

        return h.toFixed(4)
    }

    function toHektoPascal(){

        // 1 mWS = 98.0665 kPa/mbar

        var hPa =  resultConveyorHeight() * 98.0665


        return hPa.toFixed(3)
    }

    function flowRate(){

        var flow = 0.0      // in m3/h

        // Qpu = Q / c * dt
        flow = hp.floatvalue / ( 1.16 * calculator.deltaTeta )

        return flow.toFixed(3)
    }


    // First section
    Grid{
        id: deliverygrid
        columns: 3
        rows: 8
        columnSpacing: 10
        rowSpacing: 5
        width: parent.width

        anchors.top: line.bottom
        anchors.left: parent.left
        anchors.margins: 20

        Text { text: qsTr("R:"); color: "white"; font.pointSize: root.textsize }
        FSpinBox { id: r; value: 120; onValueChaned: { resultConveyorHeight() } }
        Text { text: qsTr("Pa/m"); color: "white"; font.pointSize: root.textsize }

        Text { text: qsTr("L:"); color: "white"; font.pointSize: root.textsize }
        FSpinBox { id: l; value: 75  ; onValueChaned: { resultConveyorHeight()  } }
        Text { text: qsTr("m"); color: "white"; font.pointSize: root.textsize }



        // Berechnete Förderhöhe
        Text { text: qsTr("ZF:"); color: "white"; font.pointSize: root.textsize }
        FSpinBox { id: zf; floatvalue: 2.3; realvalue: true; onValueChaned: {  resultConveyorHeight()  }  }
        Text { text: qsTr("--"); color: "white"; font.pointSize: root.textsize }


        Text { text: qsTr("Conveyor height:"); color: "white"; font.pointSize: root.textsize }
        Text { text: resultConveyorHeight(); color: "#DC143C"; font.pointSize: root.textsize+2 }
        Text { text: qsTr("mWS"); color: "white"; font.pointSize: root.textsize }

        Text { text: qsTr("Conveyor height:"); color: "white"; font.pointSize: root.textsize }
        Text { text: toHektoPascal(); color: "#DC143C"; font.pointSize: root.textsize+2 }
        Text { text: qsTr("hPa"); color: "white"; font.pointSize: root.textsize }


        Text { text: qsTr("Heat power:"); color: "white"; font.pointSize: root.textsize }
        FSpinBox { id: hp; floatvalue: heatpage.heatpower; realvalue: true; onValueChaned: {   }  }
        Text { text: qsTr("kW"); color: "white"; font.pointSize: root.textsize }

        Text { text: qsTr("Temp. difference:"); color: "white"; font.pointSize: root.textsize }
        Text { text: calculator.deltaTeta; color: "#2B547E"; font.pointSize: root.textsize+2 }
        Text { text: qsTr("K"); color: "white"; font.pointSize: root.textsize }

        Text { text: qsTr("Flow rate:"); color: "white"; font.pointSize: root.textsize }
        Text { text: flowRate(); color: "#DC143C"; font.pointSize: root.textsize+2 }
        Text { text: qsTr("m3/h"); color: "white"; font.pointSize: root.textsize }
    }


    Rectangle{
        id: line2
        width: parent.width-20
        height: 1
        color: "white" // Blue Jay
        anchors.top: deliverygrid.bottom
        x:10
    }

    Grid{
        id: linkgrid
        columns: 2
        rows: 2
        rowSpacing: 10
        columnSpacing: 10
        anchors.top: line2.bottom
        anchors.topMargin: 10
        x: 20
        Text {
            text: qsTr("Grundfos:")
            color: "white"
            font.pointSize: root.textsize
        }
        Label {
            id: link1

            text: "https://product-selection.grundfos.com/de/"
            color: "#2B547E"

            font.pointSize: root.textsize
                MouseArea{
                    anchors.fill: parent
                    onClicked: {  Qt.openUrlExternally("https://product-selection.grundfos.com/de")    }
                }
        }
        Text {
            text: qsTr("Wilo:")
            color: "white"
            font.pointSize: root.textsize
        }

        Label {
            id: link2

            text: "https://wilo.com/de/"
            color: "#2B547E"

            font.pointSize: root.textsize
            MouseArea{
                anchors.fill: parent
                onClicked: {  Qt.openUrlExternally("https://wilo.com/de")    }
            }
        }
    }


    Image {
        id: kennlinie
        source: "/png/Kennlinie.png"
        width: parent.width
        anchors.top: linkgrid.bottom
        anchors.topMargin: 10
        fillMode: Image.PreserveAspectFit
    }

}
