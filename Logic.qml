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
    property var m_enPassant: ""
    property var m_pawnCaptCount: 0
    property var m_turnCount: 2

    function pawnPiece(a)
    {
        var l_all = "rnbqkpPRNBQK"
        for (var i = 0; i < l_all.length; i++)
            if (a == l_all[i]) return true
        return false
    }

    function fen()
    {
        var l_fen = ""
        for (var i = 0; i < 8; i++)
        {
            if (i > 0) l_fen += "/"
            var l_empyCount = 0
            for (var j = 0; j < 8; j++)
            {
                if (!pawnPiece(m_pos[i][j]))
                {
                    l_empyCount++
                    continue
                }
                if (l_empyCount > 0) l_fen += l_empyCount
                l_fen += m_pos[i][j]
                l_empyCount = 0
            }
            if (l_empyCount > 0) l_fen += l_empyCount
        }

        l_fen += " " + (m_turnCount % 2 ? "b" : "w")
        l_fen += " " + m_castling
        l_fen += " " + (m_enPassant.length ? m_enPassant : "-")
        l_fen += " " + m_pawnCaptCount + " " + (Math.floor(m_turnCount / 2) + 1)
        return l_fen; //"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    }

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
        console.log(fen())
        //m_player2.turn()
    }
}
