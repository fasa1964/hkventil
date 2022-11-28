import QtQuick
import QtQuick.Controls
import Qt.labs.settings


import ClassHeatCalculator 1.0

Window {
    id: root
    width: 420
    height: 700
    visible: true
    title: qsTr("HK-Ventil")


    property bool android: false
    property int captionsize: android ? 10 : 13
    property int textsize: android ? 9 : 11


    Calculator{
        id: calculator
        objectName: "Calculator"
        onStartParticleSystem: { heatpage.startHeat()  }
        onStartFlameSystem: {   heatpage.startFlame()  }
        onStartSpuelen: {   heatpage.startMotor()   }
        onStartPump: {   heatpage.startPump(); calculator.startHeatUpVorlauf() }
    }

    SwipeView {
        id: view
        objectName: "view"
        //currentIndex: pageIndicator.currentIndex
        anchors.fill: parent

        HeatPage { id: heatpage  }
//        ValvePage { id: valvepage  }
//        ResultPage { id: resultpage }
        PumpPage { id: pumppage }
        HeatCurve{ id: heatcurve }
    }

    PageIndicator {
        id: pageIndicator
        interactive: true
        count: view.count
        currentIndex: view.currentIndex

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        delegate: Rectangle{
                id: outerrect
                implicitHeight: 12
                implicitWidth: 12
                color: "transparent"
                border.color: "#21be2b"
                radius: width/2

                required property int index

                Rectangle {
                     id: innserrect
                     implicitWidth: 8
                     implicitHeight: 8
                     anchors.centerIn: parent

                     radius: width / 2
                     color: "#21be2b" // green

                     opacity: index === pageIndicator.currentIndex ? 0.95 : pressed ? 0.5 : 0.10

                     //required property int index

                     Behavior on opacity {
                         OpacityAnimator {
                             duration: 100
                         }
                     }
             }

             MouseArea{
                 anchors.fill: parent
                 onClicked: {       view.currentIndex = index    }
             }
        }
    }

    Settings{

        property alias snapgrid: heatcurve.snaptogrid
        property alias coord: heatcurve.showcoord
        property alias formula: heatcurve.showformula
        property alias hkcurve: heatcurve.showhk
        property alias po1x: heatcurve.p1x
        property alias po2x: heatcurve.p2x
        property alias po1y: heatcurve.p1y
        property alias po2y: heatcurve.p2y
        property alias ttemp: heatcurve.temptag
        property alias stemp: heatcurve.tempsummer

        property alias heatkw: heatpage.heatpower

    }


   Component.onCompleted: {


       Qt.platform.os === "android" ? android = true : android = false


       calculator.setSystemVorlaufTemp(55);
       calculator.setSystemRuecklaufTemp(35)
       calculator.setSystemWaermebedarf(heatpage.heatpower)

       calculator.setOilWaermemenge(10.0)
       calculator.setGasWaermemenge(9.8)

       calculator.setBetriebsStundenOil(1800)
       calculator.setBetriebsStundenGas(1800)

       calculator.setOilWirkungsgrad(97.0);
       calculator.setGasWirkungsgrad(98.0);

       heatcurve.setupProperties()


       //console.log(heatcurve.tempsummer)

   }

}
