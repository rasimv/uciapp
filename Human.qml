import QtQuick 2.7

QtObject
{
    property var m_this
    property var m_engineControl

    function start(a)
    {
        m_this = a
    }

    signal started()

    function turn(a)
    {}

    signal ply(int a_from, int a_to)
}
