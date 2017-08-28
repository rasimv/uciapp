#ifndef __ENGINECONTROLLER_H
#define __ENGINECONTROLLER_H

#include <QObject>

class EngineController : public QObject
{
    Q_OBJECT

public:
    EngineController(QObject *a = nullptr);
    virtual ~EngineController();
};

#endif //__ENGINECONTROLLER_H
