import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import "chessutil.js" as ChessUtil

ApplicationWindow
{
    function func1()
    {
        var q = [1, 2, 3, 4, 5, 6,
                 11, 12, 13, 14, 15, 16]
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
						var l_fen = "r1bqkb1r/ppppn1pp/8/1B2ppP1/1n2P3/5N2/PPPP1P1P/RNBQK2R w KQkq f6 0 6"
						var w = new ChessUtil.Position()
						w.m_layout.clear()
						w.fromFen(l_fen)
						console.log("\r\n========================\r\n" + w.asText("\r\n"))

						var l_start = new Date().getTime()
						var q = w.m_layout.legalTurns("K", w.m_enPassant, w.m_castling)

						var l_finish = new Date().getTime()

						console.log("time: " + (l_finish - l_start))
						console.log("#" + q.length + "#")
						for (var i = 0; i < q.length; i++)
							console.log(q[i])
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
