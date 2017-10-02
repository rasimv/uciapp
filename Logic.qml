import QtQuick 2.7
import "chessutil.js" as ChessUtil

QtObject
{
    property var m_position: new ChessUtil.Position()

    function value(a_coords)
    {
        var l_coords = new ChessUtil.Coords(a_coords.x, a_coords.y);
        return m_position.square(l_coords);
    }

    function isItAllowed(a_from, a_to)
    {
        return true;
    }

    function fromFen(s)
    {
        m_position.fromFen(s);
        console.log(m_position.asText("\r\n"));
    }

    property var m_this
    property var m_player1
    property var m_player2
    property var m_board

    property var m_pos: ["rnbqkbnr",
                         "pppppppp",
                         "00000000", "00000000", "00000000", "00000000",
                         "PPPPPPPP",
                         "RNBQKBNR"]
    property var m_castling: "KQkq"
    property var m_enPassant: ""
    property var m_pawnCaptCount: 0
    property var m_turnCount: 0

    function fen()
    {
        //"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
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
        return l_fen
    }

    function horizontal(a)
    {
        if (a == "a") return 0
        if (a == "b") return 1
        if (a == "c") return 2
        if (a == "d") return 3
        if (a == "e") return 4
        if (a == "f") return 5
        if (a == "g") return 6
        if (a == "h") return 7
        return -1
    }

    function vertical(a)
    {
        if (a == "1") return 7
        if (a == "2") return 6
        if (a == "3") return 5
        if (a == "4") return 4
        if (a == "5") return 3
        if (a == "6") return 2
        if (a == "7") return 1
        if (a == "8") return 0
        return -1
    }

    function decodeTurn(a_notation, a_king)
    {
        if (a_notation == "0-0")
        {
            var r = (a_king == "e1" ? 7 : 0)
            return [4, r, 6, r, 7, r, 5, r]
        }
        if (a_notation == "0-0-0")
        {
            var r = (a_king == "e1" ? 7 : 0)
            return [4, r, 2, r, 0, r, 3, r]
        }
        if (a_notation.length < 4) return []
        var q = [horizontal(a_notation[0]), vertical(a_notation[1]), horizontal(a_notation[2]), vertical(a_notation[3])]
        for (var i = 0; i < q.length; i++)
            if (q[i] < 0) return []
        return q
    }

    function start(a_this, a_board)
    {
        m_this = a_this
        m_board = a_board
        m_player1 = Qt.createQmlObject("Human {}", m_this)
        m_player2 = Qt.createQmlObject("Comp {}", m_this)
        m_player1.start(m_player1, m_this)
        m_player2.start(m_player2, m_this)
        m_player2.started.connect(onStarted)
        m_player2.newGameStarted.connect(onNewGameStarted)
        m_player2.ply.connect(onPly)
    }

    function onStarted(a)
    {
        m_player2.startNewGame()
    }

    function onNewGameStarted(a)
    {
        console.log("onNewGameStarted")
        console.log(fen())
        m_player2.turn()
    }

    function onPly(a)
    {
        console.log("onPly")
        console.log(a.last())
        var q = decodeTurn(a.last(), "e1")
        m_board.move(q)
    }
}
