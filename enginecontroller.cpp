#include "stdafx.h"
#include "enginecontroller.h"

EngineController::EngineController(QObject *a)
{}

EngineController::~EngineController()
{}

void EngineController::start()
{
    connect(&m_p, SIGNAL(started()), SLOT(onStarted()));
    connect(&m_p, SIGNAL(errorOccurred(QProcess::ProcessError)), SLOT(onError(QProcess::ProcessError)));
    connect(&m_p, SIGNAL(readyReadStandardOutput()), SLOT(onReadyRead()));
    m_p.start("C:\\Users\\rasim\\deploy\\stockfish-8-win\\Windows\\stockfish_8_x64.exe");
}

void EngineController::onStarted()
{
    int k = 0;
}

void EngineController::onError(QProcess::ProcessError a)
{
    int k = 0;
}

void EngineController::onReadyRead()
{
    int k = 0;
}
