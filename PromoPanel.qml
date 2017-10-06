import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import "board.js" as BoardJS

Item
{
    property var flip: false
    property var pawn: "P"

    property var m_pieces: "QNRBBRNQbrnqqnrb"

    signal pieceSelected(string a);

    Rectangle
    {
        anchors.fill: parent
        color: "purple"
    }

    ColumnLayout
    {
        id: id_layout
        anchors.fill: parent
        spacing: 0

        Repeater
        {
            id: id_repeater
            model: m_pieces.length

            Image
            {
                Layout.fillWidth: true
                Layout.fillHeight: true

                sourceSize.width: 256
                sourceSize.height: 256

                visible: index < 4
                source: BoardJS.imageFilepath(m_pieces[index])

                property var magicIndex: index
            }
        }
    }

    onFlipChanged:
    {
        console.log("onFlipChanged: " + flip);
        if (id_repeater.count < m_pieces.length) return;
        for (var i = 0; i < 4; i++)
        {
            var l_ofs = pawn == "P" ? 0 : 8;
            id_repeater.itemAt(l_ofs + i).visible = !flip;
            id_repeater.itemAt(4 + l_ofs + i).visible = flip;
        }
    }

    onPawnChanged:
    {
        console.log("onPawnChanged");
        for (var i = 0; i < 4; i++)
        {
            var l_ofs = flip ? 4 : 0;
            id_repeater.itemAt(l_ofs + i).visible = pawn == "P";
            id_repeater.itemAt(8 + l_ofs + i).visible = pawn != "P";
        }
    }

    MouseArea
    {
        anchors.fill: parent

        onClicked:
        {
            console.log("Promo clicked");
            var l_clicked = id_layout.childAt(mouse.x, mouse.y);
            var l_selected = l_clicked == null ? "" : m_pieces[l_clicked.magicIndex];
            pieceSelected(l_selected);
        }
    }
}
