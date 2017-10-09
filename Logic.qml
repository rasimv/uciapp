import QtQml 2.2
import "chessutil.js" as ChessUtil

QtObject
{
    property var m_position
    property var m_player1: null
    property var m_player2: null

    function startNewGame()
    {
        m_position = new ChessUtil.Position();
        m_player1 = Qt.createQmlObject("User {}", this, "Logic.qml");
        m_player2 = Qt.createQmlObject("Comp {}", this, "Logic.qml");
        m_player1.start();
        m_player2.start();
    }
}
