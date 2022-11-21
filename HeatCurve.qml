import QtQuick
import QtQuick.Controls

Page {
    id: heatcurve
    objectName: qsTr("Curve")
    title: qsTr("Heat curve")
    background: Rectangle{

        gradient: Gradient{

            GradientStop { position: 0.0; color: "#021a06" }
            GradientStop { position: 0.55; color: "darkgreen" }
            GradientStop { position: 1.0; color:  animation ? "#021a06" : "darkgreen" }

        }
    }


//    Label{
//        id: caption
//        text: heatcurve.title
//        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.top: parent.top
//        anchors.topMargin: 10
//        font.pointSize: captionsize
//        font.letterSpacing: 2
//        color: "white" // Blue Jay
//    }

//    Rectangle{
//        id: line
//        width: caption.width
//        height: 1
//        color: "white" // Blue Jay
//        anchors.top: caption.bottom
//        anchors.left: caption.left
//    }


    property bool animation: false

    // App values
    property bool snaptogrid: false
    property bool showformula: false
    property bool showcoord: false
    property bool showhk: false

    property real graphTeilung: graph.width/10
    property real gridTransparent: 0.55


    // Settings values
    property int timerinterval: 150
    property real xposvalue: 5.78

    // Text values
    property int textsize: android ? 9 :  12
    property int pointsize: 12

    // Points values
    property int p1x: getXAchse(2)
    property int p1y: getYAchse(4)
    property int p2x: getXAchse(6)
    property int p2y: getYAchse(7)

    property int temptag: 20
    property int tempsummer: 15

    // Linear Function valuse
    property real xPos: 0
    property int b: 0
    property int m: 0

    property real xn: 0
    property real bn: 0
    property real mn: 0
    property real yn: 0
    property real angle: 0

    // Temperatur values
    function getVorlauftemperatur(yv){
        var vt = 0.0

        vt = 5 * yv + 20

        return vt
    }

    function getAussentemperatur(xv){

        var at = 0.0

        at = xv * 5 - 25

        return -at
    }

    function updateSummerTemp(){
        var tx = getAussentemperatur( getXValue(point1.x))
        summerspin.value = tx
        tempsummer = tx
    }
    //!---------------------------

    // crossrect values
    function getCrossXAchse(xn){

        var a = graph.width/10
        var xp = xn * a  - crossrect.width/2   //- pointsize/2
        return xp

    }

    function getCrossYAchse(yn){

        var a = graph.height/10
        var yp =  graph.height - yn * a  + crossrect.height/2 - a

        return yp
    }

    function getCrossYValue(ypix){

        ypix = ypix + crossrect.height/2
        var ya = graph.height / 10
        //var y0 = getYAchse(0)
        var yh = ya * 10
        var yv = (ypix - yh) / ya //+ 1

        return -yv.toFixed(1)
    }

    function getCrossXValue(xpix){

        xpix = xpix + crossrect.width/2
        var xa = graph.width / 10
        var xv = xpix / xa

        return xv.toFixed(1)
    }
    //!---------------------------

    // Umrechnung von grid zu pixel
    function getXAchse(n){

        var a = graph.width/10
        var xp = n * a - pointsize/2
        return xp
    }

    function getYAchse(n){

        var a = graph.height/10
        var yp =  graph.height - n * a
        return yp - pointsize/2
    }
    // !-----------------------------

    // Snap to nearest grid
    function snapToGridX(x){

        var aw = graph.width / 10
        var xp = (x / aw).toFixed(0) //- 1
        xp = getXAchse(xp)

        return xp;
    }

    function snapToGridY(y){

        var ah = graph.height / 10
        var y0 = getYAchse(0)
        var yp = ((y0 - y) / ah).toFixed(0)
        yp = getYAchse(yp)

        return yp;
    }
    // !------------------------------


    // Returns the y value
    function getYValue(ypix){

        ypix = ypix + 1
        var ya = graph.height / 10
        //var y0 = getYAchse(0)
        var yh = ya * 10
        var yv = (ypix - yh) / ya //+ 1

        return -yv.toFixed(1)
    }

    function getXValue(xpix){

        var xa = graph.width / 10
        var xv = xpix / xa // - 1

        return xv.toFixed(1)

    }
    // !------------------------------------

    function updateCurve(){
        canvas.clearCanvas()
        canvas.markDirty(Qt.rect(canvas.x,canvas.y,canvas.width,canvas.height))
    }

    function updateCrossPath(){
        redcanvas.clearCanvas()
        redcanvas.markDirty(Qt.rect(redcanvas.x,redcanvas.y,redcanvas.width,redcanvas.height))
    }

    // Linear function
    function getAlpha(){

        var X1 = getXValue(point1.x + pointsize/2 )
        var X2 = getXValue(point2.x + pointsize/2 )
        var Y1 = getYValue(point1.y + pointsize/2 )
        var Y2 = getYValue(point2.y + pointsize/2 )

        var aangle = Math.atan2(Y2-Y1,X2-X1) * 180 / Math.PI

        return aangle.toFixed(2)

    }

    function steigung(){

        var m = 0.0

        // steigung von p1 zu p2
        var X1 = getXValue(point1.x + 3.5)
        var X2 = getXValue(point2.x + 3.5)
        var Y1 = getYValue(point1.y + 3.5)
        var Y2 = getYValue(point2.y + 3.5)

        m = (Y2 - Y1) / (X2 - X1)

        return m.toFixed(2)

    }

    function yAchsenAbschnitt(){

        var st = steigung()
        var Y1 = getYValue(point1.y + pointsize/2)

        // f(x) = mx + b * y   x = 0
        var yx = st * getXValue(point1.x + pointsize/2) * (graph.width/10) + (point1.y + pointsize/2)
        var ya = getYValue(yx)

        // Set cross to position
        crossrect.x =  getCrossXAchse(0)
        crossrect.y =  getCrossYAchse(ya)  //getCrossYAchse(ya)

        return ya

    }

    function linearFunction(x,m,b){

        // f(x) = mx + b

        // m = steigung
        // x = x-Wert
        // b = y-Achsenabschnitt
        // f(x) = y - Wert
        //var m = steigung()
        //var x = getXValue( mpoint.x )
        //var b = yAchsenabschnitt()

        var fx = m * x + b


        return fx
    }
    // !------------------------------


    function timerTriggered(){
        xPos +=  xposvalue // 5.78;
        crossrect.x = xPos


        xn = getCrossXValue(xPos)
        mn = steigung()
        bn = yAchsenAbschnitt()

        yn = linearFunction(xn, mn, bn )

        var yPos = getCrossYAchse(yn)


//        var xTest = (-bn + yn) / mn
//        var xp = getXAchse(xTest)

        crossrect.y = yPos
        crossrect.x = xPos


        if(crossrect.x + crossrect.width/2  >= point2.x + pointsize/2){
            curvetimer.stop()
            animation = false
        }


    }


    Timer{
        id: curvetimer
        interval: timerinterval
        running: false
        repeat: true
        onTriggered: timerTriggered()
    }

    // Curve Settings
    FCurveSettings{
        id: settings
        anchors.top: graph.top
        anchors.topMargin: 40
        z:2
        visible: false

        onAcceptSetting: {

            timerinterval = settings.slidervalue
            xposvalue = settings.xposvalue
            settings.visible = false


        }
        onCancelSetting: {  settings.visible = false  }
    }

    // Upper Flow Checkbox's
    Flow{
        id: boxgrid
        width: parent.width-20
        x:10; y:10
        spacing: 10
        FGCheckBox{
            id: snapbox
            boxtext: "Snap to grid"
            onCheckBoxChanged: { controlchecked ? snaptogrid = true : snaptogrid = false  }

        }
        FGCheckBox{
            id: formulabox
            boxtext: "Show formula"
            onCheckBoxChanged: {

                controlchecked ? showformula = true : showformula = false

                if(showformula)
                    settingsimage.visible = false
                else
                    settingsimage.visible = true

            }

        }
        FGCheckBox{
            id: coordbox
            boxtext: "Show coordinate"
            onCheckBoxChanged: { controlchecked ? showcoord = true : showcoord = false   }
        }
        FGCheckBox{
            id: hkbox
            boxtext: "Show HK-Curve"
            onCheckBoxChanged: { controlchecked ? showhk = true : showhk = false   }
        }
    }

    // Start button
    FGButton{
        id: startbutton
        width: android ? 65 : 80
        buttontext:  curvetimer.running ? "Pause" : "Start"
        anchors.right: graph.right
        anchors.bottom: graph.top
        anchors.bottomMargin: 15
        onButtonPressed: {

            if(!animation){

                xPos = 0
                b = yAchsenAbschnitt()
                bn = yAchsenAbschnitt()
                m = steigung()
                animation = true
            }

            curvetimer.running ? curvetimer.stop() : curvetimer.start()


        }
    }

    // Image for curve settings
    Image {
        id: settingsimage
        width: 36
        source: "/svg/settings.svg"
        fillMode: Image.PreserveAspectFit
        anchors.bottom: graph.top
        anchors.bottomMargin: 5
        anchors.left: graph.left
        MouseArea{
            anchors.fill: parent
            onClicked: {

                settings.visible === true ? settings.visible = false : settings.visible = true  }
        }
    }

    // show's the formular f(x) = mx x b
    Row{
        id: formularow
        spacing: 20
        anchors.bottom: graph.top
        anchors.left: graph.left
        anchors.bottomMargin: 5
        visible: showformula
        Text {
            id: fxformula
            text: "f(x) = mx + b"
            font.pointSize: textsize + 3
            color: "lightgreen"
        }

        Text {
            id: fyformula;
            text: qsTr("y = ") + mn + " x " + xn + " + " + bn ;
            font.pointSize: textsize + 3;
            color: "lightgreen"
        }
    }

    // Main graph
    Rectangle{
        id: graph
        width: parent.width-60
        height: graph.width
        color: "transparent"
        border.color: "lightgreen"
        anchors.centerIn: parent


        Canvas{
            id: canvasX
            anchors.centerIn: graph
            width: graph.width
            height: graph.height
            x:0
            contextType: "2d"
            Path {
                id: gridPath
                startX: graphTeilung*1 ; startY: 0

                PathLine { x: graphTeilung*1 ; y: graph.height }
                PathLine { x: graphTeilung*1; y: 0  }
                PathLine { x: graphTeilung*2; y: 0  }
                PathLine { x: graphTeilung*2; y: graph.height  }
                PathLine { x: graphTeilung*2; y: 0  }
                PathLine { x: graphTeilung*3; y: 0  }
                PathLine { x: graphTeilung*3; y: graph.height  }
                PathLine { x: graphTeilung*3; y: 0  }
                PathLine { x: graphTeilung*4; y: 0  }
                PathLine { x: graphTeilung*4; y: graph.height  }
                PathLine { x: graphTeilung*4; y: 0  }
                PathLine { x: graphTeilung*5; y: 0  }
                PathLine { x: graphTeilung*5; y: graph.height  }
                PathLine { x: graphTeilung*5; y: 0  }
                PathLine { x: graphTeilung*6; y: 0  }
                PathLine { x: graphTeilung*6; y: graph.height  }
                PathLine { x: graphTeilung*6; y: 0  }
                PathLine { x: graphTeilung*7; y: 0  }
                PathLine { x: graphTeilung*7; y: graph.height  }
                PathLine { x: graphTeilung*7; y: 0  }
                PathLine { x: graphTeilung*8; y: 0  }
                PathLine { x: graphTeilung*8; y: graph.height  }
                PathLine { x: graphTeilung*8; y: 0  }
                PathLine { x: graphTeilung*9; y: 0  }
                PathLine { x: graphTeilung*9; y: graph.height  }

            }

            onPaint: {
                context.strokeStyle = Qt.rgba(.92, .93, .92, gridTransparent);
                context.path = gridPath;
                context.stroke();
            }
        }

        Canvas{
            id: canvasY
            anchors.centerIn: graph
            width: graph.width
            height: graph.height
            x:0
            contextType: "2d"
            Path {
                id: gridYPath
                startX: 0 ; startY: graphTeilung*1

                PathLine { x: graph.width ; y: graphTeilung*1 }
                PathLine { x: 0 ; y: graphTeilung*1 }
                PathLine { x: 0;  y: graphTeilung*2 }
                PathLine { x: graph.width;  y: graphTeilung*2 }
                PathLine { x: 0 ; y: graphTeilung*2 }
                PathLine { x: 0;  y: graphTeilung*3 }
                PathLine { x: graph.width;  y: graphTeilung*3 }
                PathLine { x: 0 ; y: graphTeilung*3 }
                PathLine { x: 0;  y: graphTeilung*4 }
                PathLine { x: graph.width;  y: graphTeilung*4 }
                PathLine { x: 0 ; y: graphTeilung*4 }
                PathLine { x: 0;  y: graphTeilung*5 }
                PathLine { x: graph.width;  y: graphTeilung*5 }
                PathLine { x: 0 ; y: graphTeilung*5 }
                PathLine { x: 0;  y: graphTeilung*6 }
                PathLine { x: graph.width;  y: graphTeilung*6 }
                PathLine { x: 0 ; y: graphTeilung*6 }
                PathLine { x: 0;  y: graphTeilung*7 }
                PathLine { x: graph.width;  y: graphTeilung*7 }
                PathLine { x: 0 ; y: graphTeilung*7 }
                PathLine { x: 0;  y: graphTeilung*8 }
                PathLine { x: graph.width;  y: graphTeilung*8 }
                PathLine { x: 0 ; y: graphTeilung*8 }
                PathLine { x: 0;  y: graphTeilung*9 }
                PathLine { x: graph.width;  y: graphTeilung*9 }
            }

            onPaint: {
                context.strokeStyle = Qt.rgba(.92, .93, .92, gridTransparent);
                context.path = gridYPath;
                context.stroke();
            }
        }

        Canvas{
            id: canvas
            anchors.centerIn: graph
            width: graph.width
            height: graph.height
            x:0
            contextType: "2d"
            Path {
                id: curvePath
                startX: point1.x + pointsize/2 ; startY: point1.y + pointsize/2

                PathLine { x: point2.x + pointsize/2 ; y: point2.y + pointsize/2 }
            }

            onPaint: {
                context.strokeStyle = Qt.rgba(.106, .92, .92, 1);
                context.path = curvePath;
                context.stroke();
            }

            function clearCanvas(){
               var ctx = canvas.getContext("2d")
               ctx.reset()
            }

        }

        Canvas{
            id: redcanvas
            anchors.centerIn: graph
            width: graph.width
            height: graph.height
            x:0
            contextType: "2d"
            Path {
                id: redPath
                startX: point1.x + pointsize/2 ; startY: point1.y + pointsize/2

                PathLine { x: crossrect.x + crossrect.width/2 ; y: crossrect.y + crossrect.height/2 }
            }

            onPaint: {
                context.strokeStyle = Qt.rgba(.255, .230, .230, 1);
                context.path = redPath;
                context.stroke();
            }

            function clearCanvas(){
                var ctx = redcanvas.getContext("2d")
                ctx.reset()
            }

        }

        Rectangle{
            id: captionrect
            width: captiony.width+15
            height: captiony.height+10
            color: "#021a06"
            border.color: "lightgreen"
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: captiony
                text: showhk ? "VT: " + getVorlauftemperatur( getCrossYValue( crossrect.y ) ) + "°C" : "Y-Value: " + getCrossYValue( crossrect.y )
                font.pointSize: textsize + 3;
                color: "lightgreen"
                anchors.centerIn: parent
            }
        }

        Text {
            id: y0
            text: showhk ? "20°C" : "0"
            font.pointSize: textsize
            color: Qt.rgba(.92, .93, .92, gridTransparent);
            x: showhk ? -25 : -15
            y: graphTeilung*10 - y0.height/2
        }
        Text {
            id: y1
            text: showhk ? "25°C" :  "1"
            font.pointSize: textsize
            color: Qt.rgba(.92, .93, .92, gridTransparent);
            x: showhk ? -25 : -15
            y: graphTeilung*9 - y1.height/2
        }
        Text {
            id: y2
            text: showhk ? "30°C" :  "2"
            font.pointSize: textsize
            color: Qt.rgba(.92, .93, .92, gridTransparent);
            x: showhk ? -25 : -15
            y: graphTeilung*8 - y2.height/2
        }
        Text {
            id: y3
            text: showhk ? "35°C" : "3"
            font.pointSize: textsize
            color: Qt.rgba(.92, .93, .92, gridTransparent);
            x:  showhk ? -25 : -15
            y: graphTeilung*7 - y3.height/2
        }
        Text {
            id: y4
            text: showhk ? "40°C" : "4"
            font.pointSize: textsize
            color: Qt.rgba(.92, .93, .92, gridTransparent);
            x: showhk ? -25 : -15
            y: graphTeilung*6 - y4.height/2
        }
        Text {
            id: y5
            text: showhk ? "45°C" : "5"
            font.pointSize: textsize
            color: Qt.rgba(.92, .93, .92, gridTransparent);
            x: showhk ? -25 : -15
            y: graphTeilung*5 - y5.height/2
        }
        Text {
            id: y6
            text: showhk ? "50°C" : "6"
            font.pointSize: textsize
            color: Qt.rgba(.92, .93, .92, gridTransparent);
            x: showhk ? -25 : -15
            y: graphTeilung*4 - y6.height/2
        }
        Text {
            id: y7
            text: showhk ? "55°C" : "7"
            font.pointSize: textsize
            color: Qt.rgba(.92, .93, .92, gridTransparent);
            x: showhk ? -25 : -15
            y: graphTeilung*3 - y7.height/2
        }
        Text {
            id: y8
            text: showhk ? "60°C" : "8"
            font.pointSize: textsize
            color: Qt.rgba(.92, .93, .92, gridTransparent);
            x: showhk ? -25 : -15
            y: graphTeilung*2 - y8.height/2
        }
        Text {
            id: y9
            text: showhk ? "65°C" : "9"
            font.pointSize: textsize
            color: Qt.rgba(.92, .93, .92, gridTransparent);
            x: showhk ? -25 : -15
            y: graphTeilung*1 - y9.height/2
        }
        Text {
            id: ytext
            text: showhk ? "VT" : "Y"
            font.pointSize: textsize+2
            color: Qt.rgba(.92, .93, .92, 1);
            x:  showhk ? -25 : -15
            y: 0 - ytext.height/2
        }


        Text {
            id: x01
            text: showhk ? "25°C" :  "0"
            font.pointSize: textsize
            color: Qt.rgba(.92, .93, .92, gridTransparent);
            x: graphTeilung*0 - x1.width/2
            y: graph.height
        }
        Text {
            id: x1
            text: showhk ? "20°C" : "1"
            font.pointSize: textsize
            color: Qt.rgba(.92, .93, .92, gridTransparent);
            x: graphTeilung*1 - x1.width/2
            y: graph.height
        }
        Text {
            id: x2
            text: showhk ? "15°C" : "2"
            font.pointSize: textsize
            color: Qt.rgba(.92, .93, .92, gridTransparent);
            x: graphTeilung*2 - x2.width/2
            y: graph.height
        }
        Text {
            id: x3
            text: showhk ? "10°C" : "3"
            font.pointSize: textsize
            color: Qt.rgba(.92, .93, .92, gridTransparent);
            x: graphTeilung*3 - x3.width/2
            y: graph.height
        }
        Text {
            id: x4
            text: showhk ? "5°C" : "4"
            font.pointSize: textsize
            color: Qt.rgba(.92, .93, .92, gridTransparent);
            x: graphTeilung*4 - x4.width/2
            y: graph.height
        }
        Text {
            id: x5
            text: showhk ? "0°C" : "5"
            font.pointSize: textsize
            color: Qt.rgba(.92, .93, .92, gridTransparent);
            x: graphTeilung*5 - x5.width/2
            y: graph.height
        }
        Text {
            id: x6
            text: showhk ? "-5°C" : "6"
            font.pointSize: textsize
            color: Qt.rgba(.92, .93, .92, gridTransparent);
            x: graphTeilung*6 - x6.width/2
            y: graph.height
        }
        Text {
            id: x7
            text: showhk ? "-10°C" : "7"
            font.pointSize: textsize
            color: Qt.rgba(.92, .93, .92, gridTransparent);
            x: graphTeilung*7 - x7.width/2
            y: graph.height
        }
        Text {
            id: x8
            text: showhk ? "-15°C" : "8"
            font.pointSize: textsize
            color: Qt.rgba(.92, .93, .92, gridTransparent);
            x: graphTeilung*8 - x8.width/2
            y: graph.height
        }
        Text {
            id: x9
            text: showhk ? "-20°C" : "9"
            font.pointSize: textsize
            color: Qt.rgba(.92, .93, .92, gridTransparent);
            x: graphTeilung*9 - x9.width/2
            y: graph.height
        }
        Text {
            id: xtext
            text: showhk ? "AT" : "X"
            font.pointSize: textsize+2
            color: Qt.rgba(.92, .93, .92, 1);
            x: graph.width-10
            y: graph.height //- xtext.height/2
        }


        // Point 1
        Rectangle{
            id: point1
            width: pointsize
            height: pointsize
            radius: pointsize/2
            color: "lightgreen"
            x: p1x
            y: p1y

            Text {
                id: c1
                text: getXValue(point1.x+pointsize/2) + "|" + getYValue(point1.y+pointsize/2)
                font.pointSize: textsize
                color: "lightgreen"
                x:-5
                y: point1.height
                visible: showcoord
            }

            MouseArea{
                anchors.fill: parent
                drag.target: point1
                drag.axis: Drag.XAndYAxis

                onReleased: {

                    p1x = point1.x
                    p1y = point1.y

                    if(snaptogrid){
                       p1x = snapToGridX(point1.x)
                       p1y = snapToGridY(point1.y)
                    }

                    mn = steigung()
                    //yn = yAchsenAbschnitt()
                    bn = yAchsenAbschnitt()

                    xn = getXValue(0)
                    angle = getAlpha()

                    updateCurve()
                    updateCrossPath()

                    // Update Summer/Winter temperature
                    updateSummerTemp()

                }
            }
        }

        // Point 2
        Rectangle{
            id: point2
            width: pointsize
            height: pointsize
            radius: pointsize/2
            color: "lightgreen"
            x: p2x
            y: p2y

            Text {
                id: c2
                text: getXValue(point2.x+pointsize/2) + "|" + getYValue(point2.y+pointsize/2)
                font.pointSize: textsize
                color: "lightgreen"
                x:-5
                y: point1.height
                visible: showcoord
            }

            MouseArea{
                anchors.fill: parent
                drag.target: point2
                drag.axis: Drag.XAndYAxis

                onReleased: {

                    p2x = point2.x
                    p2y = point2.y

                    if(snaptogrid){
                       p2x = snapToGridX(point2.x)
                       p2y = snapToGridY(point2.y)
                    }


                    mn = steigung()
                    bn = yAchsenAbschnitt()
                    xn = getXValue(0)
                    angle = getAlpha()


                    updateCurve()
                    updateCrossPath()

                }
            }
        }


        // Cross
        Rectangle{
            id: crossrect
            width: graph.width/10
            height: crossrect.width
            color: "transparent"
            border.color: animation ? "transparent" : "lightgreen"

            x: getCrossXAchse(0) // + pointsize/2 //+ crossrect.width/2
            y: getCrossYAchse(6) //- pointsize/2 //+ crossrect.height/2


            Rectangle{
                id: linevertical
                width: 1
                height: parent.height/2
                anchors.centerIn: parent
                color: "transparent"
                border.color: "lightgreen"
            }

            Rectangle{
                id: linehorizontal
                width: parent.height/2
                height: 1
                anchors.centerIn: parent
                color: "transparent"
                border.color: "lightgreen"
            }

            MouseArea{
                anchors.fill: parent
                drag.target: crossrect
                drag.axis: Drag.XAndYAxis

            }
        }


        onWidthChanged: {

            if(snaptogrid){
               p1x = snapToGridX(point1.x)
               p1y = snapToGridY(point1.y)
               p2x = snapToGridX(point2.x)
               p2y = snapToGridY(point2.y)
            }

        }
    }

    Flow{
        id: bottomflow
        width: parent.width-40
        anchors.top: graph.bottom
        anchors.left: graph.left
        anchors.topMargin: 25
        spacing: 20
        Grid{
            columns: 4
            spacing: 8
            Text { text: qsTr("Alpha:"); font.pointSize: textsize; color: "#021a06" }
            Text { text: angle + "°"; font.pointSize: textsize; color: "lightgreen" }

            Text { text: showhk ? "AT:" : "X:"; font.pointSize: textsize; color: animation ? "lightgray" : "#021a06" }
            Text { text: showhk ? getAussentemperatur( getCrossXValue(crossrect.x)) + "°C"  :  getCrossXValue(crossrect.x); font.pointSize: textsize; color: "lightgreen" }

            Text { text: qsTr("Steigung:"); font.pointSize: textsize; color: "#021a06" }
            Text { text: steigung() + " [m]"; font.pointSize: textsize; color: "lightgreen" }

            Text { text: showhk ? "VT:" : "Y:"; font.pointSize: textsize; color: animation ? "lightgray" : "#021a06"  }
            Text { text: showhk ? getVorlauftemperatur( getCrossYValue(crossrect.y)) + "°C" : getCrossYValue(crossrect.y) ; font.pointSize: textsize; color: "lightgreen" }
        }
        Grid{
            rows:2
            columns: 2
            spacing: 8
            visible: showhk
             Text { text: "Tagtemperatur:"; font.pointSize: textsize; color: animation ? "lightgray" : "#021a06"  }
             FGSpinBox{
                 id: tagspin;
                 onTempChanged: {

                     if(value < temptag){
                         point1.y = point1.y + (graph.height/10) / 2
                         point2.y = point2.y + (graph.height/10) / 2
                         temptag = value
                         mn = steigung()
                         bn = yAchsenAbschnitt()
                         xn = getXValue(0)
                         angle = getAlpha()
                         updateCurve()
                         updateCrossPath()
                     }

                     if(value > temptag){
                         point1.y = point1.y - (graph.height/10) / 2
                         point2.y = point2.y - (graph.height/10) / 2
                         temptag = value
                         mn = steigung()
                         bn = yAchsenAbschnitt()
                         xn = getXValue(0)
                         angle = getAlpha()
                         updateCurve()
                         updateCrossPath()
                     }

                 }
             }
             Text { text: "Sommer/Winter:"; font.pointSize: textsize; color: animation ? "lightgray" : "#021a06"  }

             FGSpinBox{
                 id: summerspin;
                 onTempChanged: {

                     if(value < tempsummer){
                        point1.x = point1.x + (graph.width/10) /5
                        tempsummer = value
                     }

                     if(value > tempsummer){
                         point1.x = point1.x - (graph.width/10) /5
                         tempsummer = value
                     }


                     mn = steigung()
                     bn = yAchsenAbschnitt()
                     xn = getXValue(0)
                     angle = getAlpha()

                     updateCurve()
                     updateCrossPath()
                     updateSummerTemp()

                 }
             }
        }
    }
}
