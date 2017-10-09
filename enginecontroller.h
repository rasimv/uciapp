#ifndef __ENGINECONTROLLER_H
#define __ENGINECONTROLLER_H

#include <QObject>
#include <QProcess>
#include <QVariant>

class EngineController : public QObject
{
    Q_OBJECT

public:
    EngineController(QObject *a = nullptr);
    virtual ~EngineController();

    Q_INVOKABLE void start(QVariant a_object);
    Q_INVOKABLE QString read();
    Q_INVOKABLE void write(QString a);

signals:
    void started(QVariant a_object);
    void error(QVariant a_object);
    void readyRead(QVariant a_object);

private slots:
    void onStarted();
    void onError(QProcess::ProcessError a);
    void onReadyRead();

private:
    QProcess m_p;
    QVariant m_object;
};

#endif //__ENGINECONTROLLER_H
