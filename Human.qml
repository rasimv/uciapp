import QtQuick 2.7

QtObject
{
    property var m_this
    property var m_logic
    property var m_engineControl

    function start(a_this, a_logic)
    {
        m_this = a_this; m_logic = a_logic
    }

    signal started()

    function turn(a)
    {}

    signal ply(int a_from, int a_to)
}
