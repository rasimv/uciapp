import QtQuick 2.7

QtObject
{
    property var m_this;
    property var m_player1;
    property var m_player2;

    property var m_pos;
    property var m_count;

    function start(a_this)
    {
        m_this = a_this;
        m_player1 = Qt.createQmlObject("Human {}", m_this);
        m_player2 = Qt.createQmlObject("Comp {}", m_this);
        m_player1.start(m_player1);
        m_player2.start(m_player2);
    }
}
