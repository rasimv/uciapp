import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import "board.js" as BoardJS

Item
{
    property var flip: false
    property var pawn: "P"
    property var fieldHeight: 100
    width: 100

    function magicActivate(a_field)
    {
        m_field = a_field;
        pawn = m_field.magicValue();
        x = Qt.binding(function() { return m_field.x; });
        visible = true;
    }

    signal pieceSelected(string a);

//------------------------------------------------------------------------------
    ColumnLayout
    {
        id: id_columnLayout

        width: parent.width
        height: 4 * fieldHeight
        spacing: 0

        Repeater
        {
            id: id_repeater
            model: m_pieces.length

            Rectangle
            {
                property var magicIndex: index

                Layout.fillWidth: true
                Layout.fillHeight: true
                visible: index < 4
                color: "yellow"

                Image
                {
                    anchors.fill: parent
                    sourceSize.width: 256
                    sourceSize.height: 256
                    source: BoardJS.imageFilepath(m_pieces[index])
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: magicClicked(magicIndex)
                }
                }
        }
    }

//------------------------------------------------------------------------------
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
        magicSnap();
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
        magicSnap();
    }

//------------------------------------------------------------------------------
    property var m_pieces: "QNRBBRNQbrnqqnrb"
    property var m_field

    function magicSnap()
    {
        if (!flip && pawn == "P" || flip && pawn != "P")
        {
            id_columnLayout.anchors.bottom = undefined;
            id_columnLayout.anchors.top = this.top;
        }
        else
        {
            id_columnLayout.anchors.top = undefined;
            id_columnLayout.anchors.bottom = this.bottom;
        }
    }

    function magicClicked(a)
    {
        visible = false;
        pieceSelected(m_pieces[a]);
    }
}
