import QtQml 2.8
import "chessutil.js" as ChessUtil

QtObject
{
    function setBoard(a)
    {
        if (m_board != null)
        {
            m_board.compPlyMade.disconnect(onPlyMade);
            m_board.userPlyMade.disconnect(onPlyMade);
        }
        m_board = a;
        if (m_board != null)
        {
            m_board.compPlyMade.connect(onPlyMade);
            m_board.userPlyMade.connect(onPlyMade);
        }
    }

    function startNewGame(a_compUser1, a_compUser2)
    {
        m_position = new ChessUtil.Position();
        if (m_player1 != null) m_player1.destroy();
        if (m_player2 != null) m_player2.destroy();
        m_player1 = Qt.createQmlObject(a_compUser1 ? "Comp {}" : "User {}", this, "Logic.qml");
        m_player2 = Qt.createQmlObject(a_compUser2 ? "Comp {}" : "User {}", this, "Logic.qml");

        m_player1.started.connect(onStarted);
        m_player1.compPly.connect(onCompPly);
        m_player1.userPly.connect(onUserPly);
        m_player2.started.connect(onStarted);
        m_player2.compPly.connect(onCompPly);
        m_player2.userPly.connect(onUserPly);

        m_board.fromLayout(m_position.layout());

        m_startedPlayers = 0;
        m_legalPlies = m_position.legalPlies();
        m_history = [newHistoryRecord()];
        m_player1.start();
        m_player2.start();
    }

    function stop()
    {
        m_player1.stop();
        m_player2.stop();
        m_board.stop();
        m_timer.singleShot(gameOver, "Stopped", "");
    }

    signal gameOver(string a_line1, string a_line2);

    property var m_position
    property var m_player1: null
    property var m_player2: null
    property var m_board: null
    property var m_startedPlayers
    property var m_legalPlies
    property var m_timer: Qt.createQmlObject("SingleShotTimer {}", this, "Logic.qml")
    property var m_history: []

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
        m_board.userPly(m_legalPlies);
    }

    function onPlyMade(a_info)
    {
        m_position.makePly(a_info);

        m_legalPlies = m_position.legalPlies();
        if (checkGameState()) return;

        var l_fen = m_position.fen();
        m_player1.position(l_fen);
        m_player2.position(l_fen);
        var t = m_position.turnCount();
        t % 2 == 0 ? m_player1.turn() : m_player2.turn();
    }

    function newHistoryRecord()
    {
        return { layout: m_position.layout().clone(), turn: m_position.turnCount() };
    }

    function countInHistory(a_record)
    {
        var l_count = 0;
        for (var i = 0; i < m_history.length; i++)
        {
            var l_record = m_history[i];
            if (a_record.layout.isEqual(l_record.layout) && a_record.turn % 2 == l_record.turn % 2)
                l_count++;
        }
        return l_count;
    }

    function checkGameState()
    {
        if (m_legalPlies.length <= 0)
        {
            if (m_position.isCheck())
                m_timer.singleShot(gameOver, m_position.turnCount() % 2 ? "White won" : "Black won", "Checkmate");
            else
                m_timer.singleShot(gameOver, "Draw", "Stalemate");
            return true;
        }
        if (m_position.isInsufMat())
        {
            m_timer.singleShot(gameOver, "Draw", "Insufficient material");
            return true;
        }
        if (m_position.pawnCaptCount() > 100)
        {
            m_timer.singleShot(gameOver, "Draw", "50-move rule");
            return true;
        }
        var w = newHistoryRecord();
        if (countInHistory(w) >= 2)
        {
            m_timer.singleShot(gameOver, "Draw", "3rd repetition");
            return true;
        }
        m_history.push(w);
        return false;
    }
}
