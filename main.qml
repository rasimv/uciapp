import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import "chessutil.js" as ChessUtil

ApplicationWindow
{
    function func2()
    {
        id_board.qqq()
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

                Component.onCompleted:
                {
                    id_board.setLogic(id_logic);
                }
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
                    text: "update"

                    onClicked:
                    {
                        id_logic.fromFen("r1bqkb1r/ppppn1pp/8/1B2ppP1/1n2P3/5N2/PPPP1P1P/RNBQK2R w KQkq f6 0 6");
                        id_board.update();
                    }
                }

                Button
                {
                    text: "move"

                    onClicked:
                    {
                        func2();
                    }
                }

                Button
                {
                    text: "start"

                    onClicked:
                    {
                        //var l_fen = "r1bqkb1r/ppppn1pp/8/1B2ppP1/1n2P3/5N2/PPPP1P1P/RNBQK2R w KQkq f6 0 6";
                        var l_fen = "rnbqkbnr/1pppp1pp/8/4PpP1/p7/8/PPPP1P1P/RNBQKBNR w KQkq f6 0 5";
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
                            console.log(q[i].asText());

                        w.makePly(q[31]);
                        console.log("========================\r\n" + w.asText("\r\n"));
                        console.log(w.fen());
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
