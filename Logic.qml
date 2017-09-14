import QtQuick 2.7

QtObject
{
    property var m_this
    property var m_player1
    property var m_player2

    property var m_pos: ["rnbqkbnr",
                         "pppppppp",
                         "00000000", "00000000", "00000000", "00000000",
                         "PPPPPPPP",
                         "RNBQKBNR"]
    property var m_castling: "KQkq"

    function start(a_this)
    {
        m_this = a_this
        m_player1 = Qt.createQmlObject("Human {}", m_this)
        m_player2 = Qt.createQmlObject("Comp {}", m_this)
        m_player1.start(m_player1, m_this)
        m_player2.start(m_player2, m_this)
        m_player2.started.connect(onStarted)
        m_player2.newGameStarted.connect(onNewGameStarted)
    }

    function onStarted(a)
    {
        m_player2.startNewGame()
    }

    function onNewGameStarted(a)
    {
        console.log("onNewGameStarted")
        m_player2.turn()
    }

    function fen()
    {
        return "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    }
}
