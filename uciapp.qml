import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4 as Controls14
import QtQuick.Controls 2.2
import "chessutil.js" as ChessUtil

ApplicationWindow
{
    Logic
    {
        id: id_logic
        onGameOver:
        {
            id_sidePanel.setStartStop(false);
            id_sidePanel.setResult(a_line1, a_line2);
        }
    }

    visible: true
    width: 1150
    height: 900
    title: "Uciapp"

    Controls14.SplitView
    {
        anchors.fill: parent
        orientation: Qt.Horizontal

        Board
        {
            id: id_board

            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        SidePanel
        {
            id: id_sidePanel
            width: 250
            Layout.fillHeight: true

            onFlipped: id_board.flip = a
            onMagicStart: { id_logic.startNewGame(a_compUser1, a_compUser2); setResult("", ""); }
            onMagicStop: id_logic.stop()
        }
    }

    Component.onCompleted: { id_logic.setBoard(id_board); }
}
