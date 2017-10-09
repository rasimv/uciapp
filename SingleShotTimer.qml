import QtQml 2.2

Timer
{
    function singleShot(a_callable, a_arg) { m_callable = a_callable; m_arg = a_arg; start(); }
    interval: 0; repeat: false
    onTriggered: m_callable(m_arg)
    property var m_callable
    property var m_arg
}
