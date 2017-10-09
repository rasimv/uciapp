#include "stdafx.h"
#include "enginecontroller.h"

EngineController::EngineController(QObject *a)
    :QObject(a)
{
    connect(&m_p, SIGNAL(started()), SLOT(onStarted()));
    connect(&m_p, SIGNAL(errorOccurred(QProcess::ProcessError)), SLOT(onError(QProcess::ProcessError)));
    connect(&m_p, SIGNAL(readyReadStandardOutput()), SLOT(onReadyRead()));
}

EngineController::~EngineController()
{
    disconnect(&m_p, SIGNAL(started()), this, SLOT(onStarted()));
    disconnect(&m_p, SIGNAL(errorOccurred(QProcess::ProcessError)), this, SLOT(onError(QProcess::ProcessError)));
    disconnect(&m_p, SIGNAL(readyReadStandardOutput()), this, SLOT(onReadyRead()));
}

void EngineController::start(QVariant a_object)
{
    m_object = a_object;
    m_p.start("C:\\Users\\rasim\\deploy\\stockfish-8-win\\Windows\\stockfish_8_x64.exe");
}

QString EngineController::read()
{
    return QString::fromLatin1(m_p.readAll());
}

void EngineController::write(QString a)
{
    m_p.write(a.toLatin1());
}

void EngineController::onStarted() { emit started(m_object); }
void EngineController::onError(QProcess::ProcessError a) { emit error(m_object); }
void EngineController::onReadyRead() { emit readyRead(m_object); }
