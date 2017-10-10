import QtQml 2.2

Timer
{
    function singleShot(a_callable, a_arg1, a_arg2)
    {
        m_callable = a_callable;
        m_arg1 = a_arg1;
        m_arg2 = a_arg2;
        start();
    }
    interval: 0; repeat: false
    onTriggered: m_callable(m_arg1, m_arg2)
    property var m_callable
    property var m_arg1
    property var m_arg2
}
