#ifndef __ENGINECONTROLLER_H
#define __ENGINECONTROLLER_H

#include <QObject>
#include <QProcess>

class EngineController : public QObject
{
    Q_OBJECT

public:
    EngineController(QObject *a = nullptr);
    virtual ~EngineController();

    Q_INVOKABLE void start();

private:
    QProcess m_p;
};

#endif //__ENGINECONTROLLER_H
