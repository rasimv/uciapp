import QtQuick 2.7

QtObject
{
    property var m_this;
    property var m_engineControl;

    function start(a)
    {
        m_this = a;
        m_engineControl = Qt.createQmlObject('import com.github.rasimv.uciapp 1.0; EngineController {}', m_this);
        m_engineControl.start();
    }

	signal started();

    function turn(a)
    {}

    signal ply(int a_from, int a_to);
}
