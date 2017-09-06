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

        m_pos = ["rnbqkbnr",
                 "pppppppp",
                 "00000000", "00000000", "00000000", "00000000",
                 "PPPPPPPP",
                 "RNBQKBNR"];

        m_player1 = Qt.createQmlObject("Human {}", m_this);
        m_player2 = Qt.createQmlObject("Comp {}", m_this);
    }
}
