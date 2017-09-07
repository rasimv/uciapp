import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

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
                        id_logic.start(id_logic)
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
