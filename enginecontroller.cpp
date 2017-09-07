#include "stdafx.h"
#include "enginecontroller.h"

EngineController::EngineController(QObject *a)
{
    connect(&m_p, SIGNAL(started()), SLOT(onStarted()));
    connect(&m_p, SIGNAL(errorOccurred(QProcess::ProcessError)), SLOT(onError(QProcess::ProcessError)));
    connect(&m_p, SIGNAL(readyReadStandardOutput()), SLOT(onReadyRead()));
}

EngineController::~EngineController()
{}

void EngineController::start()
{
    m_p.start("C:\\Users\\rasim\\deploy\\stockfish-8-win\\Windows\\stockfish_8_x64.exe");
}

QString EngineController::read()
{
    return QString();
}

void EngineController::onStarted() { emit started(); }
void EngineController::onError(QProcess::ProcessError a) { emit error(); }
void EngineController::onReadyRead() { emit readyRead(); }
