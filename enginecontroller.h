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

private slots:
    void onStarted();
    void onError(QProcess::ProcessError a);
    void onReadyRead();

private:
    QProcess m_p;
    QByteArray m_buf;
};

#endif //__ENGINECONTROLLER_H
