#ifndef CLASSHEATCALCULATOR_H
#define CLASSHEATCALCULATOR_H

#include <QObject>
#include <QQmlProperties>
#include <QTimer>
#include <QPoint>

class ClassHeatCalculator : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(double wmenge READ wmenge WRITE setWmenge NOTIFY wmengeChanged)
    Q_PROPERTY(int deltaTeta READ deltaTeta WRITE setDeltaTeta NOTIFY deltaTetaChanged)
    Q_PROPERTY(double wmengeliter READ wmengeliter WRITE setWmengeliter NOTIFY wmengeliterChanged)

    Q_PROPERTY(double oilConsum READ oilConsum WRITE setOilConsum NOTIFY oilConsumChanged)
    Q_PROPERTY(double gasConsum READ gasConsum WRITE setGasConsum NOTIFY gasConsumChanged)

    // Heat properties
    Q_PROPERTY(int vorlaufTemperatur READ vorlaufTemperatur WRITE setVorlaufTemperatur NOTIFY vorlaufTemperaturChanged)
    Q_PROPERTY(int ruecklaufTemperatur READ ruecklaufTemperatur WRITE setRuecklaufTemperatur NOTIFY ruecklaufTemperaturChanged)
    Q_PROPERTY(double dichte READ dichte WRITE setDichte NOTIFY dichteChanged )

    Q_PROPERTY(QString currentHeatProcess READ currentHeatProcess WRITE setCurrentHeatProcess NOTIFY currentHeatProcessChanged)

public:
    explicit ClassHeatCalculator(QObject *parent = nullptr);

    // Heat System
    Q_INVOKABLE void setSystemVorlaufTemp(int value);
    Q_INVOKABLE void setSystemRuecklaufTemp(int value);
    Q_INVOKABLE void setSystemWaermebedarf(int value);
    //Q_INVOKABLE double getSystemWaermebedarf();


    // Heat Gas / Oil
    Q_INVOKABLE void setOilWaermemenge(double value);
    Q_INVOKABLE void setGasWaermemenge(double value);

    Q_INVOKABLE void setOilWirkungsgrad(double value);
    Q_INVOKABLE void setGasWirkungsgrad(double value);

    Q_INVOKABLE void setBetriebsStundenOil(int value);
    Q_INVOKABLE void setBetriebsStundenGas(int value);

    Q_INVOKABLE void startHeatProcess();
    Q_INVOKABLE void stopHeatProcess();


    Q_INVOKABLE void stopHeatUpVorlauf();
    Q_INVOKABLE void startHeatUpVorlauf();

    Q_INVOKABLE void stopHeatDownVorlauf();
    Q_INVOKABLE void startHeatDownVorlauf();

    Q_INVOKABLE void stopHeatUpRuecklauf();
    Q_INVOKABLE void stopHeatDownRuecklauf();
    Q_INVOKABLE void startHeatUpRuecklauf();
    Q_INVOKABLE void startHeatDownRuecklauf();

    Q_INVOKABLE void setHeatVorlaufTemperatur(int value);
    Q_INVOKABLE void setHeatRuecklaufTemperatur(int value);
    Q_INVOKABLE void setRoomTemperatur(int value);



    double wmenge() const;
    void setWmenge(double newWmenge);

    int deltaTeta() const;
    void setDeltaTeta(int newDeltaTeta);

    double wmengeliter() const;
    void setWmengeliter(double newWmengeliter);

    double oilConsum() const;
    void setOilConsum(double newOilConsum);

    double gasConsum() const;
    void setGasConsum(double newGasConsum);

    QString currentHeatProcess() const;
    void setCurrentHeatProcess(const QString &newCurrentHeatProcess);

    int vorlaufTemperatur() const;
    void setVorlaufTemperatur(int newVorlaufTemperatur);

    int ruecklaufTemperatur() const;
    void setRuecklaufTemperatur(int newRuecklaufTemperatur);

    int getRoomTemperatur();

    double dichte() const;
    void setDichte(double newDichte);

signals:

    void wmengeChanged();
    void deltaTetaChanged();
    void wmengeliterChanged();

    void oilConsumChanged();
    void gasConsumChanged();

    void vorlaufTemperaturChanged();
    void ruecklaufTemperaturChanged();
    void currentHeatProcessChanged();
    void dichteChanged();

    // Signals to qml
    void startParticleSystem();
    void startFlameSystem();
    void startSpuelen();
    void startPump();

private slots:

    void processTimeOut();
    void heatUpVorlauf();
    void heatDownVorlauf();
    void heatUpRuecklauf();
    void heatDownRuecklauf();

private:

    // System values
    int m_deltaTeta;        // Temperaturdifferenz in Kelvin
    double m_wmenge;        // Wärmemenge in kg/h
    double m_wmengeliter;   // Wärmemenge in l/min

    int vorlaufTemp;        // Vorlauftemperatur in °C
    int ruecklaufTemp;      // Rücklauftemperatur in °C
    int waermebedarf;    // Wärmebedarf in kW des Gebäudes

    // Oil heat
    double m_oilConsum;     // Ölverbrauch Liter/Jahr
    double oilWaermemenge;  // Oil Wärmemenge pro Liter (10 kWh)
    double oilWirkungsgrad; // Wirkungsgrad des Öl-Brenners
    int betriebsStundenOil; // Betriebsstunden des Brenners pro Jahr

    // Gas heat
    double m_gasConsum;     // Gasverbrauch m3/Jahr
    double gasWaermemenge;  // Gas Wärmemenge pro m3 (10 kWh)
    double gasWirkungsgrad; // Wirkungsgrad des Gas-Brenners
    int betriebsStundenGas; // Betriebsstunden des Brenners pro Jahr


    // Heat values
    int m_vorlaufTemperatur;
    int maxVorlaufTemperatur;
    int m_ruecklaufTemperatur;
    double m_dichte;
    QString m_currentHeatProcess;
    int roomTemperatur;



    double calculateWMenge();       // Berechnet die Wärmemenge in kg/h

    double calculateOilConsum();    // Berechnet den Ölverbrauch in l/a
    double calculateGasConsum();    // Berechnet den Gasverbrauch in m3/a

    // key = °C, double = kg/dm3 (g/ml)
    QMap<int, double> dichteMap;




    // 3 Points
    QMap<int, int> curveMap;        // heat curve map
    QPoint p1;
    QPoint p2;
    QPoint p3;


    //int linearFunction(int x);

    QMap<int, QString> processMap;

    int currentProcessIndex;
    void createProcessMap();
    QTimer *processTimer;
    QTimer *heatUpVorlaufTimer;            // Erwärmt die Vorlauftemperatur
    QTimer *heatDownVorlaufTimer;          // Kühlt die Vorlauftemperatur
    QTimer *heatUpRuecklaufTimer;          // Erwärmt die Rücklauftemperatur
    QTimer *heatDownRuecklaufTimer;        // Kühlt die Rücklauftemperatur


};

#endif // CLASSHEATCALCULATOR_H
