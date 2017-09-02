#include "stdafx.h"
#include "enginecontroller.h"

EngineController::EngineController(QObject *a)
{}

EngineController::~EngineController()
{}

void EngineController::start()
{
    m_p.start("C:\\Users\\rasim\\deploy\\stockfish-8-win\\Windows\\stockfish_8_x64.exe");
}
