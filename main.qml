import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import "chessutil.js" as ChessUtil

ApplicationWindow
{
    Logic
    {
        id: id_logic
        onGameOver:
        {
            console.log(a_line1 + (a_line2 == "" ? "" : " - " + a_line2));
            id_sidePanel.setStartStop(false);
            id_sidePanel.setResult(a_line1, a_line2);
        }
    }

    visible: true
    width: 1000
    height: 800
    title: qsTr("Uciapp")

    RowLayout
    {
        anchors.fill: parent
		spacing: 0

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
                    text: "first"

                    onClicked:
                    {
                        //id_board.qqq0();
                        id_logic.setBoard(id_board);
                        id_logic.startNewGame(id_board, true);
                    }
                }

                Button
                {
                    text: "update"

                    onClicked:
                    {
                        //id_board.qqq1();
                        id_sidePanel.flip = !id_sidePanel.flip;
                    }
                }

                Button
                {
                    text: "move"

                    onClicked:
                    {
                        id_board.qqq2();
                    }
                }

                Button
                {
                    text: "start"

                    onClicked:
                    {
                        //var l_fen = "r1bqkb1r/ppppn1pp/8/1B2ppP1/1n2P3/5N2/PPPP1P1P/RNBQK2R w KQkq f6 0 6";
                        var l_fen = "4k3/1b3n2/8/8/8/8/8/4K3 w - - 0 1";
                        var w = new ChessUtil.Position();
                        w.m_layout.clear();
                        w.fromFen(l_fen);
                        console.log("========================\r\n" + w.asText("\r\n"));

                        var l_start = new Date().getTime();
                        var q = w.legalPlies();

                        var l_finish = new Date().getTime();

                        console.log("time: " + (l_finish - l_start));
                        console.log("#" + q.length + "#");
                        for (var i = 0; i < q.length; i++)
                        {
                            var s1 = q[i].notation();
                            var l_info = w.decodePly(s1);
                            var s2 = l_info.notation();
                            console.log(q[i].asText() + " | " + s1 + " | " + s2 + " | " + (s1 == s2));
                        }

                        //w.makePly(q[31]);
                        id_board.setLegalPlies(q);
                        console.log("========================\r\n" + w.asText("\r\n"));
                        console.log(w.fen());

                        id_board.fromLayout(w.layout());

                        //var l_ply = w.decodePly("f6e4");
                        //id_board.makePly(l_ply);
                        console.log("isInsufMat: " + w.layout().isInsufMat("K"));
                    }
                }
            }
        }

        SidePanel
        {
            id: id_sidePanel
            width: 300
            Layout.fillHeight: true

            onFlipped: id_board.flip = a
            onMagicStart: { id_logic.startNewGame(a_compUser1, a_compUser2); setResult("", ""); }
            onMagicStop: id_logic.stop()
        }
    }

    Component.onCompleted: { id_logic.setBoard(id_board); }
}
