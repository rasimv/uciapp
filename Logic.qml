import QtQml 2.2
import "chessutil.js" as ChessUtil

QtObject
{
    function startNewGame(a_board)
    {
        m_position = new ChessUtil.Position();
        m_player1 = Qt.createQmlObject("Comp {}", this, "Logic.qml");
        m_player2 = Qt.createQmlObject("Comp {}", this, "Logic.qml");
        m_board = a_board;
        m_player1.started.connect(onStarted);
        m_player1.compPly.connect(onCompPly);
        m_player1.userPly.connect(onUserPly);
        m_player2.started.connect(onStarted);
        m_player2.compPly.connect(onCompPly);
        m_player2.userPly.connect(onUserPly);
        m_board.compPlyMade.connect(onPlyMade);
        m_board.userPlyMade.connect(onPlyMade);
        m_board.fromLayout(m_position.layout());
        m_player1.start();
        m_player2.start();
    }

    property var m_position
    property var m_player1: null
    property var m_player2: null
	property var m_board: null
	property var m_startedPlayers

    function onStarted(a_player)
    {
        m_startedPlayers++;
        if (m_startedPlayers >= 2)
            m_player1.turn();
    }

    function onCompPly(a_player, a_notation)
    {
        var l_info = m_position.decodePly(a_notation);
        m_board.compPly(l_info);
    }

    function onUserPly(a_player)
    {
        var l_legal = m_position.legalPlies();
        m_board.userPly(l_legal);
    }

    function onPlyMade(a_info)
    {
        console.log("onPlyMade");
        m_position.makePly(a_info);



        var l_fen = m_position.fen();
        m_player1.position(l_fen);
        m_player2.position(l_fen);
        var t = m_position.turnCount();
        t % 2 == 0 ? m_player1.turn() : m_player2.turn();
    }
}
