#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QLocale>
#include <QTranslator>
#include <QIcon>

#include <classheatcalculator.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setApplicationName("HK-Ventil");
    app.setApplicationVersion("2.0");
    app.setOrganizationName("hkventil@example-qt.fasa");
    app.setOrganizationDomain("hkventil@example-qt.com");
    app.setWindowIcon(QIcon(":/icons/hkIcon.ico"));

    qmlRegisterType<ClassHeatCalculator>("ClassHeatCalculator", 1,0, "Calculator");

    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages) {
        const QString baseName = "HKVentil_" + QLocale(locale).name();
        if (translator.load(":/i18n/" + baseName)) {
            app.installTranslator(&translator);
            break;
        }
    }

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/HKVentil/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
