import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import "chessutil.js" as ChessUtil

ApplicationWindow
{
    function func1()
    {
        var q = ["P", "R", "N", "B", "Q", "K",
                 "p", "r", "n", "b", "q", "k"]
        for (var i = 0; i < q.length; i++) id_board.set(i % 8, Math.floor(i / 8), q[i])
    }

    function func2()
    {
        var l_pos = ["rnbqkbnr",
                     "pppppppp",
                     "00000000", "00000000", "00000000", "00000000",
                     "PPPPPPPP",
                     "RNBQKBNR"]
        id_board.setFromArray(l_pos)
    }

    Logic
    {
        id: id_logic
    }

    visible: true
    width: 1000
    height: 800
    title: qsTr("Uciapp")

    RowLayout
    {
        anchors.fill: parent

        ColumnLayout
        {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Board
            {
                id: id_board

                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            RowLayout
            {
                Layout.fillWidth: true
                height: 50

                Rectangle
                {
                    Layout.fillWidth: true
                    height: 10
                    color: "red"
                }

                Rectangle
                {
                    width: 60
                    height: 40
                    border.width: 1

                    TextInput
                    {
                        width: 50
                        height: 30
                        anchors.centerIn: parent
                    }
                }

                Rectangle
                {
                    width: 60
                    height: 40
                    border.width: 1

                    TextInput
                    {
                        width: 50
                        height: 30
                        anchors.centerIn: parent
                    }
                }

                Button
                {
                    text: "move"

                    onClicked:
                    {
                        func2()
                    }
                }

                Button
                {
                    text: "start"

                    onClicked:
                    {
                        var q = new ChessUtil.Position()
                        q.fromFen("r1bqkb1r/1pp1ppp1/p1n2n1p/3pP3/8/2N2N2/PPPP1PPP/R1BQKBR1 w Qkq d6 0 6")
                        console.log("\r\n" + q.asText("\r\n"))
                        console.log("\r\n" + q.fen())
                        console.log("\r\n=====================")
						var u = new ChessUtil.Layout()
						u.clear()
						var z = new ChessUtil.Coords(5, 4)
						u.fromFen("8/2p2P2/5p2/8/p4R1p/8/3P4/8 w - - 0 1")
						var v = u.pawnOrPieceScope(z)
						console.log("$$$" + v.length + "$$$")
						u.clear()
						for (var i = 0; i < v.length; i++)
						{
							console.log("v[i].c=" + v[i].c + ";" + "v[i].r=" + v[i].r)
							u.setItem(v[i], "B")
						}
						console.log("\r\n" + u.asText("\r\n"))
                    }
                }
            }
        }

        SidePanel
        {
            width: 200
            Layout.fillHeight: true
        }
    }
}
