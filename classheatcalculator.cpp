#include "classheatcalculator.h"


#include <QDebug>

ClassHeatCalculator::ClassHeatCalculator(QObject *parent)
    : QObject{parent}
{
    // value = g/ml  (kg/dm3)
    dichteMap.insert(15, 0.999103);
    dichteMap.insert(16, 0.998946);
    dichteMap.insert(17, 0.998778);
    dichteMap.insert(18, 0.998599);
    dichteMap.insert(19, 0.998408);
    dichteMap.insert(20, 0.998207);
    dichteMap.insert(21, 0.997995);
    dichteMap.insert(22, 0.997773);
    dichteMap.insert(23, 0.997541);
    dichteMap.insert(24, 0.997299);
    dichteMap.insert(25, 0.997048);
    dichteMap.insert(26, 0.996786);
    dichteMap.insert(27, 0.996516);
    dichteMap.insert(28, 0.996236);
    dichteMap.insert(29, 0.995947);
    dichteMap.insert(30, 0.99565);
    dichteMap.insert(31, 0.99534);
    dichteMap.insert(32, 0.99503);
    dichteMap.insert(33, 0.99470);
    dichteMap.insert(34, 0.99437);
    dichteMap.insert(35, 0.99403);
    dichteMap.insert(36, 0.99369);
    dichteMap.insert(37, 0.99333);
    dichteMap.insert(38, 0.99297);
    dichteMap.insert(39, 0.99260);
    dichteMap.insert(40, 0.99222);
    dichteMap.insert(41, 0.99183);
    dichteMap.insert(42, 0.99144);
    dichteMap.insert(43, 0.99104);
    dichteMap.insert(44, 0.99063);
    dichteMap.insert(45, 0.99021);
    dichteMap.insert(46, 0.98979);
    dichteMap.insert(47, 0.98936);
    dichteMap.insert(48, 0.98893);
    dichteMap.insert(49, 0.98848);
    dichteMap.insert(50, 0.98804);
    dichteMap.insert(51, 0.98758);
    dichteMap.insert(52, 0.98712);
    dichteMap.insert(53, 0.98665);
    dichteMap.insert(54, 0.98617);
    dichteMap.insert(55, 0.98569);
    dichteMap.insert(56, 0.98521);
    dichteMap.insert(57, 0.98471);
    dichteMap.insert(58, 0.98421);
    dichteMap.insert(59, 0.98371);
    dichteMap.insert(60, 0.98320);
    dichteMap.insert(61, 0.98268);
    dichteMap.insert(62, 0.98216);
    dichteMap.insert(63, 0.98163);
    dichteMap.insert(64, 0.98109);
    dichteMap.insert(65, 0.98055);
    dichteMap.insert(66, 0.98000);
    dichteMap.insert(67, 0.97945);
    dichteMap.insert(68, 0.97890);
    dichteMap.insert(69, 0.97833);
    dichteMap.insert(70, 0.97776);
    dichteMap.insert(71, 0.97719);
    dichteMap.insert(72, 0.97661);
    dichteMap.insert(73, 0.97603);
    dichteMap.insert(74, 0.97544);
    dichteMap.insert(75, 0.97484);


    curveMap.insert(18, 25);
    curveMap.insert(0, 40);
    curveMap.insert(-20, 60);

    p1.setX(56);
    p1.setY(370);
    p2.setX(200);
    p2.setY(250);
    p3.setX(360);
    p3.setY(90);

    //linearFunction(200);

    // Settings
    vorlaufTemp = 15;
    ruecklaufTemp = 15;
    roomTemperatur = 12;
    maxVorlaufTemperatur = 55;
    setVorlaufTemperatur(vorlaufTemp);
    setRuecklaufTemperatur(ruecklaufTemp);

    createProcessMap();
    currentProcessIndex = 0;

    processTimer = new QTimer();
    processTimer->setInterval(5000);
    processTimer->stop();

    heatUpVorlaufTimer = new QTimer();
    heatUpVorlaufTimer->setInterval(1500);
    heatUpVorlaufTimer->stop();

    heatDownVorlaufTimer = new QTimer();
    heatDownVorlaufTimer->setInterval(3500);
    heatDownVorlaufTimer->stop();

    heatUpRuecklaufTimer = new QTimer();
    heatUpRuecklaufTimer->setInterval(2250);
    heatUpRuecklaufTimer->stop();

    heatDownRuecklaufTimer = new QTimer();
    heatDownRuecklaufTimer->setInterval(2250);
    heatDownRuecklaufTimer->stop();

    connect(processTimer, &QTimer::timeout, this, &ClassHeatCalculator::processTimeOut);
    connect(heatUpVorlaufTimer, &QTimer::timeout, this, &ClassHeatCalculator::heatUpVorlauf);
    connect(heatDownVorlaufTimer, &QTimer::timeout, this, &ClassHeatCalculator::heatDownVorlauf);
    connect(heatUpRuecklaufTimer, &QTimer::timeout, this, &ClassHeatCalculator::heatUpRuecklauf);
    connect(heatDownRuecklaufTimer, &QTimer::timeout, this, &ClassHeatCalculator::heatDownRuecklauf);

}

void ClassHeatCalculator::setSystemVorlaufTemp(int value)
{
    vorlaufTemp = value;
    setWmenge( calculateWMenge() );
}

void ClassHeatCalculator::setSystemRuecklaufTemp(int value)
{
    ruecklaufTemp = value;
    setWmenge( calculateWMenge() );
}

void ClassHeatCalculator::setSystemWaermebedarf(double value)
{
    waermebedarf = value;
    setWmenge( calculateWMenge() );
    setOilConsum( calculateOilConsum() );
}

void ClassHeatCalculator::setOilWaermemenge(double value)
{
    oilWaermemenge = value;
    setOilConsum( calculateOilConsum() );
}

void ClassHeatCalculator::setGasWaermemenge(double value)
{
    gasWaermemenge = value;
    setGasConsum(  calculateGasConsum() );
}

void ClassHeatCalculator::setBetriebsStundenOil(int value)
{
    betriebsStundenOil = value;
    setOilConsum( calculateOilConsum() );
}

void ClassHeatCalculator::setBetriebsStundenGas(int value)
{
    betriebsStundenGas = value;
    setGasConsum( calculateGasConsum() );
}

void ClassHeatCalculator::startHeatProcess()
{
    if(processTimer->isActive())
        return;

    currentProcessIndex = 0;
    setCurrentHeatProcess( processMap.values().at( currentProcessIndex)  );
    if(!processTimer->isActive())
        processTimer->start();
}

void ClassHeatCalculator::stopHeatProcess()
{
    processTimer->stop();
    setCurrentHeatProcess("");
}


void ClassHeatCalculator::stopHeatUpVorlauf()
{
    if(heatUpVorlaufTimer->isActive())
        heatUpVorlaufTimer->stop();
}

void ClassHeatCalculator::stopHeatUpRuecklauf()
{
    if(heatUpRuecklaufTimer->isActive())
        heatUpRuecklaufTimer->stop();
}

void ClassHeatCalculator::stopHeatDownRuecklauf()
{
    if(heatDownRuecklaufTimer->isActive())
        heatDownRuecklaufTimer->stop();
}

void ClassHeatCalculator::startHeatUpRuecklauf()
{
    if(!heatUpRuecklaufTimer->isActive())
        heatUpRuecklaufTimer->start();
}

void ClassHeatCalculator::startHeatDownRuecklauf()
{
    if(!heatDownRuecklaufTimer->isActive())
        heatDownRuecklaufTimer->start();
}

void ClassHeatCalculator::startHeatUpVorlauf()
{
    if(!heatUpVorlaufTimer->isActive())
        heatUpVorlaufTimer->start();
}

void ClassHeatCalculator::stopHeatDownVorlauf()
{
    if(heatDownVorlaufTimer->isActive())
        heatDownVorlaufTimer->stop();
}

void ClassHeatCalculator::startHeatDownVorlauf()
{
    if(!heatDownVorlaufTimer->isActive())
        heatDownVorlaufTimer->start();
}

void ClassHeatCalculator::setHeatVorlaufTemperatur(int value)
{
    setVorlaufTemperatur(value);
}

void ClassHeatCalculator::setHeatRuecklaufTemperatur(int value)
{
    setRuecklaufTemperatur(value);
}

void ClassHeatCalculator::setRoomTemperatur(int value)
{
    roomTemperatur = value;
    if(roomTemperatur > 17){
        if(!heatUpRuecklaufTimer->isActive())
            heatUpRuecklaufTimer->start();
    }

    if(m_ruecklaufTemperatur >= m_vorlaufTemperatur){
        if(heatUpRuecklaufTimer->isActive())
            heatUpRuecklaufTimer->stop();
    }

}

void ClassHeatCalculator::setOilWirkungsgrad(double value)
{
    oilWirkungsgrad = value;
    setOilConsum( calculateOilConsum() );
}

void ClassHeatCalculator::setGasWirkungsgrad(double value)
{
    gasWirkungsgrad = value;
    setGasConsum( calculateGasConsum() );
}

double ClassHeatCalculator::wmenge() const
{
    return m_wmenge;
}

void ClassHeatCalculator::setWmenge(double newWmenge)
{
    if(m_wmenge != newWmenge){
        m_wmenge = newWmenge;
        emit wmengeChanged();
    }
}

int ClassHeatCalculator::deltaTeta() const
{
    return m_deltaTeta;
}

void ClassHeatCalculator::setDeltaTeta(int newDeltaTeta)
{
    if(m_deltaTeta != newDeltaTeta){
        m_deltaTeta = newDeltaTeta;
        emit deltaTetaChanged();
    }
}

double ClassHeatCalculator::wmengeliter() const
{
    return m_wmengeliter;
}

void ClassHeatCalculator::setWmengeliter(double newWmengeliter)
{
    if(m_wmengeliter != newWmengeliter){
        m_wmengeliter = newWmengeliter;
        emit wmengeliterChanged();
    }
}

double ClassHeatCalculator::oilConsum() const
{
    return m_oilConsum;
}

void ClassHeatCalculator::setOilConsum(double newOilConsum)
{
    if(m_oilConsum != newOilConsum){
        m_oilConsum = newOilConsum;
        emit oilConsumChanged();
    }
}

double ClassHeatCalculator::gasConsum() const
{
    return m_gasConsum;
}

void ClassHeatCalculator::setGasConsum(double newGasConsum)
{
    if(m_gasConsum != newGasConsum){
        m_gasConsum = newGasConsum;
        emit gasConsumChanged();
    }
}

QString ClassHeatCalculator::currentHeatProcess() const
{
    return m_currentHeatProcess;
}

void ClassHeatCalculator::setCurrentHeatProcess(const QString &newCurrentHeatProcess)
{
    if(m_currentHeatProcess != newCurrentHeatProcess){
        m_currentHeatProcess = newCurrentHeatProcess;
        emit currentHeatProcessChanged();
        if(m_currentHeatProcess == "Spülen"){
            emit startSpuelen();
        }
        if(m_currentHeatProcess == "Flammenbildung"){
            emit startFlameSystem();
            //heatUpVorlaufTimer->start();
        }
        if(m_currentHeatProcess == "Umwälzpumpe an"){
            emit startPump();

        }
    }
}

void ClassHeatCalculator::processTimeOut()
{
    currentProcessIndex++;
    if(currentProcessIndex <= processMap.size()-1){
        setCurrentHeatProcess( processMap.values().at(currentProcessIndex)  );
    }else{
        processTimer->stop();
        emit startParticleSystem();
    }
}

void ClassHeatCalculator::heatUpVorlauf()
{
    int temp = m_vorlaufTemperatur + 1;
    setVorlaufTemperatur(temp);
}

void ClassHeatCalculator::heatDownVorlauf()
{
    int temp = m_vorlaufTemperatur - 1;
    setVorlaufTemperatur(temp);
}

void ClassHeatCalculator::heatUpRuecklauf()
{
    int temp = m_ruecklaufTemperatur + 1;
    setRuecklaufTemperatur(temp);
}

void ClassHeatCalculator::heatDownRuecklauf()
{
    int temp = m_ruecklaufTemperatur - 1;
    setRuecklaufTemperatur(temp);
}

double ClassHeatCalculator::dichte() const
{
    return m_dichte;
}

void ClassHeatCalculator::setDichte(double newDichte)
{
    if( m_dichte != newDichte){
        m_dichte = newDichte;
        emit dichteChanged();
    }
}

int ClassHeatCalculator::ruecklaufTemperatur() const
{
    return m_ruecklaufTemperatur;
}

void ClassHeatCalculator::setRuecklaufTemperatur(int newRuecklaufTemperatur)
{
    if(m_ruecklaufTemperatur != newRuecklaufTemperatur){
        m_ruecklaufTemperatur = newRuecklaufTemperatur;
        emit ruecklaufTemperaturChanged();
    }
}

int ClassHeatCalculator::getRoomTemperatur()
{
    return roomTemperatur;
}

int ClassHeatCalculator::vorlaufTemperatur() const
{
    return m_vorlaufTemperatur;
}

void ClassHeatCalculator::setVorlaufTemperatur(int newVorlaufTemperatur)
{
    if(m_vorlaufTemperatur != newVorlaufTemperatur){
        m_vorlaufTemperatur = newVorlaufTemperatur;
        emit vorlaufTemperaturChanged();

        // Get current density of water
        double density = dichteMap.value(m_vorlaufTemperatur);
        setDichte(density);

        if(m_vorlaufTemperatur >= maxVorlaufTemperatur){
            //heatUpVorlaufTimer->stop();
            m_vorlaufTemperatur = maxVorlaufTemperatur;
        }
    }
}

// Kalkuliert die Wärmemenge
double ClassHeatCalculator::calculateWMenge()
{
    double waerme = 0.0;
    setDeltaTeta( vorlaufTemp - ruecklaufTemp  );

    // Formel Q = m x c x dt

    // m =  Q / (c x dt)

    // Q in Watt
    // dt in Kelvin
    // c = 1.163 Wh/(kgxK) // Benötigte Energie um 1 kg Wasser um 1°C zu erwärmen
    // m in

    waerme = (waermebedarf * 1000) / (1.163 * m_deltaTeta); // in kg/h

    // Umrechnung in liter/min
    double dichte = dichteMap.value(vorlaufTemp); // in g/ml oder kg/l
    double waermeliter = waerme * dichte / 60;
    setWmengeliter(waermeliter);


    return waerme;
}

double ClassHeatCalculator::calculateOilConsum()
{
    double litre = 0.0;

    // Formel für Ölverbrauch
    //
    litre = waermebedarf / oilWaermemenge * betriebsStundenOil;

    litre =  litre + (litre / 100)  *  (100.00 - oilWirkungsgrad) ;

    return litre;
}

double ClassHeatCalculator::calculateGasConsum()
{
    double qm = 0.0;

    qm = waermebedarf / gasWaermemenge * betriebsStundenGas;
    qm =  qm + (qm / 100)  *  (100.00 - gasWirkungsgrad) ;

    return qm;
}

//int ClassHeatCalculator::linearFunction(int x)
//{
//    // m = Steigung; n = y (Abschnit) start
//    // f(x) = m * x + n
//    int vt = 0;

//    int n = 0; //p1.x();
//    int m = p3.y()/p3.x();


//    vt = m * x + n;

//    return vt;
//}

void ClassHeatCalculator::createProcessMap()
{
    processMap.insert(0, "Vorglühen");
    processMap.insert(1, "Spülen");
    processMap.insert(2, "Zündung");
    processMap.insert(3, "Magnetventil auf");
    processMap.insert(4, "Flammenbildung");
    processMap.insert(5, "Flammenüberprüfung");
    processMap.insert(6, "Kesselwasser aufheizen");
    processMap.insert(7, "Umwälzpumpe an");
    processMap.insert(8, "Brenner läuft");

}



