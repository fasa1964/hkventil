import QtQuick
import QtQuick.Controls
import QtQuick.Particles

Page {
    id: heatpage
    objectName: qsTr("Heat")
    title: qsTr("Heat")
    background: Rectangle{
        color: "#FFF5EE" // SeaShell
    }

    property bool heatprocess: false
    property real heatpower: kw.floatvalue

    property bool heatlights: false
    property bool pumplights: false

    function showAnim(){
        heatlight.visible = true
        house.visible = true
        sollText.visible = true
        soll.visible = true
        brenner.visible = true
        pump.visible = true
        pipe.visible = true
        motor.visible = true
        heattempv.visible = true
        heattempb.visible = true
        pumplight.visible = true
        heatpower.visible = true

    }

    function hideAnim(){
        heatlight.visible = false
        house.visible = false
        sollText.visible = false
        soll.visible = false
        brenner.visible = false
        pump.visible = false
        pipe.visible = false
        motor.visible = false

        heattempv.visible = false
        heattempb.visible = false
        pumplight.visible = false
        heatpower.visible = false

        tempInner = 12;
        soll.value = 4
        stopHeat()
        stopFlame()
        stopPump()
        calculator.setHeatVorlaufTemperatur(15)
        calculator.setHeatRuecklaufTemperatur(15)
        calculator.stopHeatUpVorlauf()
        calculator.stopHeatUpRuecklauf()

    }

    function oilCosts(){

        var val = calculator.oilConsum * oileuro.floatvalue;

        return val.toFixed(2)
    }

    function gasCosts(){

        var val = calculator.gasConsum * gaseuro.floatvalue;

        return val.toFixed(2)
    }

    function startHeat(){

        heatlights = true
        //light.color = "red"
        heatTimer.start();
        //particleAge.lifeLeft = 1000
        startHouseParticle()
        particleSystem.start()

        //motorTimer.start()

    }

    function stopHeat(){

        heatlights = false
        //light.color = "gray"
        heatTimer.stop();

        //particleAge.lifeLeft = 0
        stopHouseParticle()
        motorTimer.stop()
        calculator.stopHeatProcess()

        calculator.stopHeatUpVorlauf()
        calculator.stopHeatDownVorlauf()

        calculator.stopHeatUpRuecklauf()
        calculator.stopHeatDownRuecklauf()
        //calculator.stopHeatUpRuecklauf()
        //stopPump()
        //particleSystem.stop()
    }

    function startHouseParticle(){
        particleAge.lifeLeft = 1000
    }

    function stopHouseParticle(){
        particleAge.lifeLeft = 0
    }

    function startFlame(){
        flameAge.lifeLeft = 1000
    }

    function stopFlame(){
        flameAge.lifeLeft = 0
        calculator.stopHeatProcess()
        stopMotor()
    }

    function startMotor(){  motorTimer.start()  }

    function stopMotor(){  motorTimer.stop()  }

    function startPump() {  pumplights = true  }

    function stopPump() {  pumplights = false;  }

    function heatPower(){
        var kw = 0.0

        var c = 1.163                   // c = 1.163 Wh/(kgxK) Benötigte Energie um 1 kg Wasser um 1°C zu erwärmen
        var density = calculator.dichte // in g/ml oder kg/l

        var dt = calculator.vorlaufTemperatur - calculator.ruecklaufTemperatur  // dt in Kelvin
        var m =  pumppage.flowRate() * 1000 * density                           // von m3/h in kg/h


        // Q = m[kg/h]  x c[ Wh/kgxK ] x dt[K]   // Q in Watt
        kw = m * c * dt / 1000 // in kW


        return kw.toFixed(3)
    }

    function oilConsum(){

        var liter = 0.0


        var kwh = oilquantity.floatvalue                    // kWh/l
        var c = 1.163                                       // Wh/(kgxK)
        var flowrate = pumppage.flowRate() * 1000 / 60      // m3/h
        var power = heatPower()
        var dt = calculator.vorlaufTemperatur - calculator.ruecklaufTemperatur  // dt in Kelvin

        // K x  Wh/(kgxK) x l/min
        var t = dt * c * flowrate / (kwh * 1000)

        return t.toFixed(2);

    }

    Timer{
        id: heatTimer
        repeat: true
        interval: 5000
        running: false
        onTriggered: test()
    }

    Timer{
        id: motorTimer
        repeat: true
        interval: 500
        running: false
        onTriggered: rotate()
    }

    function test(){

        if(tempInner < 22)
            tempInner += 1
        else
            tempInner += 0.5

        calculator.setRoomTemperatur(tempInner)

        if( calculator.vorlaufTemperatur >=  maxVorlaufTemperatur  ){
            //stopHeat()
            // start to downgrade the vorlaufTemperatur
            calculator.stopHeatProcess()
            calculator.startHeatDownVorlauf()
            calculator.stopHeatUpVorlauf()
            stopFlame()
        }

        if(calculator.ruecklaufTemperatur >= calculator.vorlaufTemperatur-5 ){

            calculator.startHeatProcess()
            //calculator.startHeatUpVorlauf()
            calculator.startHeatDownRuecklauf()

        }

        if(calculator.ruecklaufTemperatur <= innerTemo){
            calculator.stopHeatDownRuecklauf()
            calculator.stopHeatDownVorlauf()
        }


        if(tempInner >= tempSoll){
            stopHeat()
            stopFlame()
            stopPump()
            calculator.stopHeatUpRuecklauf()
            calculator.stopHeatDownRuecklauf()
        }

        maxVorlaufTemperatur =  heatcurve.getMaxVorlauftemperatur(tempOuter)

    }

    function rotate(){  motorangle += 25   }


    // Settings value for temperature
    property int tempOuter: 1
    property real tempInner: 12
    property int tempSoll: soll.value
    property int tempSummer: heatcurve.tempsummer
    property int maxVorlaufTemperatur: 55

    // Anim
    property int motorangle: 0


    Label{
        id: caption
        text: heatpage.title
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: android ? 5 : 10
        font.pointSize: captionsize
        font.letterSpacing: 2
        color: "#2B547E" // Blue Jay
    }

    // Caption line
    Rectangle{
        id: line
        width: caption.width
        height: 1
        color: "#2B547E" // Blue Jay
        anchors.top: caption.bottom
        anchors.left: caption.left
    }


    // First section
    Grid{
        id: valuegrid
        columns: 3
        rows: 6
        columnSpacing: 10
        rowSpacing: 5
        width: parent.width

        anchors.top: line.bottom
        anchors.left: parent.left
        anchors.margins: 20

        Text { text: qsTr("System forward:"); height: 24  ; color: "gray"; font.pointSize: root.textsize }
        FSpinBox { id: vtemp; height: 24; value: 55; onValueChaned: {  calculator.setSystemVorlaufTemp( vtemp.value )  }  }
        Text { text: qsTr("°C"); color: "gray"; font.pointSize: root.textsize }
        Text { text: qsTr("System return:"); color: "gray"; font.pointSize: root.textsize }
        FSpinBox { id: rtemp; height: 24; value: 35  ; onValueChaned: {  calculator.setSystemRuecklaufTemp( rtemp.value)  }  }
        Text { text: qsTr("°C"); color: "gray"; font.pointSize: root.textsize }
        // Wärmebedarf
        Text { text: qsTr("Required heat DIN EN 12831:"); color: "gray"; font.pointSize: root.textsize }
        FSpinBox { id: kw;  height: 24; floatvalue: 15.0; realvalue: true; onValueChaned: {  calculator.setSystemWaermebedarf ( kw.floatvalue.toFixed(2))  }  }
        Text { text: qsTr("kW"); color: "gray"; font.pointSize: root.textsize }
        Text { text: qsTr("Temp. difference:"); color: "gray"; font.pointSize: root.textsize }
        Text { text: calculator.deltaTeta; color: "#2B547E"; font.pointSize: root.textsize+2 }
        Text { text: qsTr("K"); color: "gray"; font.pointSize: root.textsize }
        Text { text: qsTr("Heat quantity:"); color: "gray"; font.pointSize: root.textsize }
        Text { text: calculator.wmenge.toFixed(2); color: "#2B547E"; font.pointSize: root.textsize+2 }
        Text { text: qsTr("kg/h"); color: "gray"; font.pointSize: root.textsize }

        // Wärmemenge
        Text { text: qsTr("Heat quantity:"); color: "gray"; font.pointSize: root.textsize }
        Text { text: calculator.wmengeliter.toFixed(3); color: "#2B547E"; font.pointSize: root.textsize+2 }
        Text { text: qsTr("l/min"); color: "gray"; font.pointSize: root.textsize }
    }

    // Linie
    Rectangle{id: line2; color: "gray"; width: parent.width-20; x:10; height: 2; anchors.top: valuegrid.bottom; anchors.topMargin: 10 }

    // Button on/off for second section
    FButton{
        id: button
        buttontext: "Off"
        width: 35
        height: 24
        anchors.right: parent.right
        anchors.rightMargin: android ? 10 : 20
        anchors.top:  line2.bottom
        anchors.topMargin: 5
        onButtonClicked:  {

            if(button.buttontext === "On"){
                heatview.visible = true
                button.buttontext = "Off"
            }else{

                if(button.buttontext === "Off"){
                    heatview.visible = false
                    button.buttontext = "On"
                }
            }
        }
    }


    // theoretischer Ölverbrauch
    Label{
        id: oelcaption
        text: heatview.currentIndex === 0 ? qsTr("Theoretical oil consumption") : qsTr("Theoretical gas consumption")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: line2.top
        anchors.topMargin: 10
        font.pointSize: captionsize
        font.letterSpacing: 2
        color: "#2B547E" // Blue Jay
    }

    // Second section
    SwipeView {
        id: heatview
        objectName: "heatview"
        width: parent.width
        interactive: true
        orientation: Qt.Horizontal
        anchors.top: oelcaption.bottom
        anchors.topMargin: 10
        x:15

        // Oil heat
        Grid{
            id: oilgrid
            columns: 3
            rows: 6
            columnSpacing: 10
            rowSpacing: 5

            visible: true


            Text { text: qsTr("Hours operator:"); color: "gray"; font.pointSize: root.textsize }
            FSpinBox { id: hoursoperator; height: 24; handlecolor: "#EE9A4D" ;value: 1800; onValueChaned: { calculator.setBetriebsStundenOil( hoursoperator.value )   }  }
            Text { text: qsTr("h/a"); color: "gray"; font.pointSize: root.textsize }
            Text { text: qsTr("Oil heat quantity:"); color: "gray"; font.pointSize: root.textsize }
            FSpinBox { id: oilquantity ; height: 24 ; handlecolor: "#EE9A4D" ;floatvalue: 10.0; realvalue: true; onValueChaned: { calculator.setOilWaermemenge( oilquantity.floatvalue )   }  }
            Text { text: qsTr("kWh/l"); color: "gray"; font.pointSize: root.textsize }

            // Wirkungsgrad
            Text { text: qsTr("Efficiency:"); color: "gray"; font.pointSize: root.textsize }
            FSpinBox { id: oilefficiency ; height: 24 ; handlecolor: "#EE9A4D" ;floatvalue: 97.0; realvalue: true; onValueChaned: { calculator.setOilWirkungsgrad( oilefficiency.floatvalue )   }  }
            Text { text: qsTr("%"); color: "gray"; font.pointSize: root.textsize }

            // Ölverbrauch
            Text { text: qsTr("Oil :"); color: "gray"; font.pointSize: root.textsize }
            Text { text: calculator.oilConsum.toFixed(3); color: "#2B547E"; font.pointSize: root.textsize+2 }
            Text { text: qsTr("l/a"); color: "gray"; font.pointSize: root.textsize }

            // Ölkosten
            Text { text: qsTr("Costs :"); color: "gray"; font.pointSize: root.textsize }
            FSpinBox { id: oileuro ; height: 24 ; handlecolor: "#EE9A4D" ;digits:2 ; floatvalue: 1.60; realvalue: true; onValueChaned: { /*calculator.setWirkungsgrad( efficiency.floatvalue)*/ } }
            Text { text: oilCosts() +  "€"; color: "red"; font.pointSize: root.textsize+2 }

        }

        Grid{
            id: gasgrid
            columns: 3
            rows: 6
            columnSpacing: 10
            rowSpacing: 5

            visible: true

            Text { text: qsTr("Hours operator:"); color: "gray"; font.pointSize: root.textsize }
            FSpinBox { id: gasoperator ; height: 24 ;  handlecolor: "#FFDF00" ;value: 1800; onValueChaned: { calculator.setBetriebsStundenGas( gasoperator.value )   }  }
            Text { text: qsTr("h/a"); color: "gray"; font.pointSize: root.textsize }
            Text { text: qsTr("Gas heat quantity:"); color: "gray"; font.pointSize: root.textsize }
            FSpinBox { id: gasquantity ; height: 24 ; handlecolor: "#FFDF00" ;floatvalue: 9.8; realvalue: true; onValueChaned: { calculator.setGasWaermemenge( gasquantity.floatvalue )   }  }
            Text { text: qsTr("kWh/m3"); color: "gray"; font.pointSize: root.textsize }

            // Wirkungsgrad
            Text { text: qsTr("Efficiency:"); color: "gray"; font.pointSize: root.textsize }
            FSpinBox { id: gasefficiency ; height: 24 ; handlecolor: "#FFDF00" ;floatvalue: 97.0; realvalue: true; onValueChaned: { calculator.setGasWirkungsgrad( gasefficiency.floatvalue )   }  }
            Text { text: qsTr("%"); color: "gray"; font.pointSize: root.textsize }

            // Gasverbrauch
            Text { text: qsTr("Gas :"); color: "gray"; font.pointSize: root.textsize }
            Text { text: calculator.gasConsum.toFixed(3); color: "#2B547E"; font.pointSize: root.textsize+2 }
            Text { text: qsTr("m3/a"); color: "gray"; font.pointSize: root.textsize }

            // Gaskosten
            Text { text: qsTr("Costs :"); color: "gray"; font.pointSize: root.textsize }
            FSpinBox { id: gaseuro ; height: 24 ; digits:2 ; handlecolor: "#FFDF00" ;floatvalue: 1.60; realvalue: true; onValueChaned: { /*calculator.setWirkungsgrad( efficiency.floatvalue) */} }
            Text { text: gasCosts() +  "€"; color: "red"; font.pointSize: root.textsize+2 }

        }
    }


    // Linie
    Rectangle{id: line3; color: "gray"; width: parent.width-20; x:10; height: 2; anchors.top: heatview.bottom; anchors.topMargin: 10 }

    // Animbutton
    FButton{
        id: animButton
        buttontext: "Off"
        width: 38
        height: 24
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: line3.bottom
        anchors.topMargin: 5
        onButtonClicked:  {

            if(animButton.buttontext === "On"){
                showAnim()
                animButton.buttontext = "Off"
            }else{

                if(animButton.buttontext === "Off"){
                    hideAnim()
                    animButton.buttontext = "On"
                }
            }

        }
    }


    // Third section
    Slider{
        id: soll
        height: 24
        width: parent.width / 3 - 20// 120
        anchors.top: line3.bottom
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 10
        from: 4
        to: 32
        stepSize: 1
        onValueChanged: {

            if(tempOuter < tempSummer){

                if(tempSoll > tempInner){
                    //startHeat();
                    //motorTimer.start()
                    heatlights = true

                    maxVorlaufTemperatur =  heatcurve.getMaxVorlauftemperatur(tempOuter)

//                    console.log("AT:" + tempOuter)
//                    console.log("MAX:" + maxVorlaufTemperatur)

                    if(!heatprocess){
                        calculator.startHeatProcess()
                        heatprocess = true
                    }
                }

                if(tempSoll < tempInner){
                    stopHeat();
                    stopFlame();
                    calculator.stopHeatUpVorlauf()
                    heatprocess = false
                    //calculator.stopHeatProcess()
                }

            }

        }
    }

    Text {
        id: sollText
        text: "Soll: " + tempSoll + " °C"
        anchors.horizontalCenter: soll.horizontalCenter
        anchors.top: soll.bottom
        font.pointSize: textsize
        color: "blue"
    }

    // Image house
    Image {
        id: house
        width: parent.width/2 //140
        height: house.width
        source: "/svg/house.svg"
        fillMode: Image.PreserveAspectFit
        anchors.left: parent.left
        anchors.leftMargin: 60
        anchors.top: line3.bottom
        anchors.topMargin: parent.width/25
        //anchors.horizontalCenter: parent.horizontalCenter
        //x: soll.x + soll.width - 50
        Text {
            id: outTemo
            text: tempOuter + "°C"
            //font.bold: true
            font.pointSize: textsize +3
            color: "blue"
            anchors.right: house.right
            anchors.rightMargin: 40
            MouseArea{
                anchors.fill: parent
                onDoubleClicked: {   outsiiderect.visible = true   }
            }
        }
        Text {
            id: innerTemo
            text: tempInner + "°C"
            //font.bold: true
            font.pointSize: textsize + 3
            color: "blue"
            anchors.horizontalCenter: house.horizontalCenter
            anchors.bottom: house.bottom
            anchors.bottomMargin: 30
            //anchors.centerIn: parent

        }
    }


    // Image heat and pump
    Image {
        id: brenner
        source: "/svg/brenner.svg"
        width: parent.width/5 // 70
        fillMode: Image.PreserveAspectFit
        anchors.left: house.right
        anchors.leftMargin: 0
        anchors.bottom: house.bottom

        Image {
            id: motor
            source: "/svg/motor.svg"
            width: brenner.height/2 - 8 // 70
            fillMode: Image.PreserveAspectFit
            x:8
//            anchors.left: brenner.left
            anchors.bottom: brenner.bottom
//            anchors.leftMargin: 0
            anchors.bottomMargin: 5
            rotation: motorangle

        }
    }

    Text {
        id: heatpower
        text: heatPower() + " kW"
        anchors.top: house.top
        anchors.topMargin: -5
        anchors.left: heattempb.left
        font.pointSize: textsize + 1
        color: "red"
    }

    Text {
        id: oilconsum
        text: oilConsum() + " l/min"
        anchors.bottom: house.bottom
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 10
        font.pointSize: textsize
        color: "red"
    }

    Text {
        id: processtext
        text: calculator.currentHeatProcess
        anchors.bottom: brenner.top
        anchors.bottomMargin: -25
        anchors.left: brenner.left
        anchors.leftMargin: 15
        color: "steelblue"
        font.pointSize: android ? textsize+1 : textsize
    }

//    Image {
//        id: motor
//        source: "/svg/motor.svg"
//        width: brenner.height // 70
//        fillMode: Image.PreserveAspectFit
//        anchors.left: brenner.left
//        anchors.bottom: brenner.bottom
//        anchors.leftMargin: 0
//        anchors.bottomMargin: 0
//        rotation: motorangle
//    }

    // Heat-Temperature forwards
    Text {
        id: heattempv
        text: calculator.vorlaufTemperatur + " °C"
        anchors.bottom: pump.top
        anchors.horizontalCenter: pump.horizontalCenter
        color: "red"
        font.pointSize: textsize + 3
    }

    Image {
        id: pump
        source: "/svg/pumpe.svg"
        height: pipe.height // parent.width/5 - 10 // 60
        fillMode: Image.PreserveAspectFit
        anchors.left: pipe.right
        anchors.leftMargin: -10
        anchors.top: pipe.top

    }

    // Heat-Temperature backwards
    Text {
        id: heattempb
        text: calculator.ruecklaufTemperatur + " °C"
        anchors.bottom: pipe.top
        anchors.horizontalCenter: pipe.horizontalCenter
        color: "blue"
        font.pointSize: textsize + 3

    }

    Image {
        id: pipe
        source: "/svg/pipe.svg"
        height:  parent.height/9 // 60
        fillMode: Image.PreserveAspectFit
        anchors.left: house.right
        anchors.leftMargin: -20
        anchors.bottom: brenner.top

    }

    // Heatlight
    Rectangle{
        id: heatlight
        width: 10
        height: 10
        radius: 5
        color: "transparent"
        border.color: "#CECECE"
        border.width: 1
        anchors.centerIn: house


        Rectangle{
            id: hlight
            width: 8
            height: 8
            radius: 4
            color: heatlights ? "#F70D1A" : "#6F4E37"
            anchors.centerIn: parent
        }
    }

    // Pumplight
    Rectangle{
        id: pumplight
        width: 10
        height: 10
        radius: 5
        border.color: "#CECECE"
        color: "transparent"
        border.width: 1
        anchors.centerIn: pump
        Rectangle{
            id: plight
            width: 8
            height: 8
            radius: 4
            color: pumplights ? "#66FF00" : "#6F4E37"
            anchors.centerIn: parent
        }
    }

    // Value for outside temperatur
    Rectangle{
        id: outsiiderect
        width: parent.width-50
        height: 50
        anchors.centerIn: parent
        border.color: "gray"
        visible: false
        Row{
            width: parent.width-40
            x:20
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10
            Slider{
                id: out
                width: parent.width - okbtn.width - otex.width - 15
                from: -20
                to: 22
                stepSize: 1
            }

            Text {
                id: otex
                text: out.value
                font.pointSize: textsize + 4
                color: "blue"
            }

            FButton{
                id: okbtn
                buttontext: "ok"
                height: 30
                width: 35
                onButtonClicked: {
                    tempOuter = out.value;
                    outsiiderect.visible = false

                    maxVorlaufTemperatur =  heatcurve.getMaxVorlauftemperatur(tempOuter)

                }
            }
        }
    }

    ParticleSystem {
        id: particleSystem
        running: true
    }

    property real mX: 0
    property real mY: 0
    property real colorvar: 0.5
    property int liveseconds: 4800
    property int trailspan: 500
    property int esize: 34
    property int erate: 5
    property int vangle: 180
    property int tangle: 270
    property int vmagnet: 10
    property int tmagnet: 100
    property int vvariation: 1

    property bool followmouse: false

    property int  intervalcounter: 0
    property int  maxcounter: 12

    // Heating particle
    Emitter {
          id: emitter
          //anchors.centerIn: house
          anchors.bottom: house.bottom
          x: house.width/2
          width: house.width/2; height: house.height/2
          system: particleSystem
          emitRate: 25
          lifeSpan: 1000
          lifeSpanVariation: 10
          size: 16
          endSize: 32
          velocity: AngleDirection { angle: tangle; magnitude: vmagnet; magnitudeVariation: vvariation }
          //Tracer { color: 'green' }
    }

    Age{
        id: particleAge
        system: particleSystem
        //groups: ['star']
        once: true
        lifeLeft: 1000
        advancePosition: false
    }

    ImageParticle {
        id: smokePainter
        system: particleSystem
        groups: ['star']
        source: "qrc:///particleresources/star.png"
        color: "red"
        //colorVariation: 1.0
        rotation: 90
    }

    TrailEmitter {
        id: smokeEmitter
        system: particleSystem
        emitHeight: 1
        emitWidth: 4
        group: 'smoke'
        follow: 'star'
        emitRatePerParticle: 96
        velocity: AngleDirection { angle: tangle; magnitude: tmagnet; angleVariation: 5 }
        lifeSpan: 500 + trailspan
        size: 16
        sizeVariation: 4
        endSize: 1
    }
    // ! Heating particle

    // Flame particle
    ParticleSystem {
        id: flameSystem
        running: true
    }

    Emitter {
          id: flame
          //anchors.centerIn: house
          anchors.left: brenner.right
          y: brenner.y + brenner.height/3
          x: brenner.x + brenner.width
          width: brenner.width/2;
          height: 30 // brenner.height/2
          system: flameSystem
          emitRate: 25
          lifeSpan: 1000
          lifeSpanVariation: 10
          size: 8
          endSize: 32
          velocity: AngleDirection { angle: 360; magnitude: 30; magnitudeVariation: 5 }
          //Tracer { color: 'green' }
    }

    ImageParticle {
        id: flamePainter
        system: flameSystem
        groups: ['star']
        source: "qrc:///particleresources/glowdot.png"
        color: "#FFFF33"
        entryEffect: ImageParticle.Scale
        colorVariation: 0.2
        rotation: 180
    }

    TrailEmitter {
        id: flameEmitter
        system: flameSystem
        emitHeight: 1
        emitWidth: 4
        group: 'smoke'
        follow: 'star'
        emitRatePerParticle: 96
        velocity: AngleDirection { angle: tangle; magnitude: tmagnet; angleVariation: 5 }
        lifeSpan: 500 + trailspan
        size: 16
        sizeVariation: 4
        endSize: 1
    }

    Age{
        id: flameAge
        system: flameSystem
        //groups: ['star']
        once: true
        lifeLeft: 1000
        advancePosition: false
    }

}
