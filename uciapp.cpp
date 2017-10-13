// uciapp.cpp : Defines the entry point for the application.
//

#include "stdafx.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "enginecontroller.h"

int main(int a_argc, char *a_argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication l_app(a_argc, a_argv);

    qmlRegisterType<EngineController>("com.github.rasimv.uciapp", 1, 0, "EngineController");

    QQmlApplicationEngine l_engine;
    l_engine.load(QUrl(QLatin1String("qrc:/uciapp.qml")));
    if (l_engine.rootObjects().isEmpty())
        return -1;

    return l_app.exec();
}
