import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import "board.js" as BoardJS

Item
{
    id: id_board

    property bool flip: false
    property var magicColors: ["#707070", "#909090"]

    function qqq()
    {
        flip = !flip;
        id_repeater.itemAt(5).value = flip ? "0" : "P";
    }

    property var m_data: new BoardJS.BoardData(this)
    property var m_dragged
    property var m_placeholder

    GridLayout
    {
        id: id_layout
        columns: 8
        rows: 8
        anchors.fill: parent
        rowSpacing: 0
        columnSpacing: 0

        Repeater
        {
            id: id_repeater
            model: 64

            Field
            {
                Layout.fillWidth: true
                Layout.fillHeight: true

                magicColor: { return magicColors[(Math.floor(index / 8) % 2 + index % 2 + flip) % 2]; }
            }
        }
    }

    Repeater
    {
        id: id_placeholders
        model: BoardJS.s_imageFilepaths

        Placeholder
        {
            visible: false
            filepath: modelData
        }
    }

    MouseArea
    {
        anchors.fill: parent

        onPressed:
        {
            m_data.mousePressed(Qt.point(mouse.x, mouse.y));
        }

        onPositionChanged:
        {
            m_data.mousePosChanged(Qt.point(mouse.x, mouse.y));
        }

        onReleased:
        {
            m_data.mouseReleased(Qt.point(mouse.x, mouse.y));
        }
    }

    function fieldAt(a) { return id_layout.childAt(a.x, a.y); }
    function isDraggable(a_pos)
    {
        var l_field = fieldAt(a_pos);
        return l_field != null && BoardJS.pawnOrPieceIndex(l_field.value) >= 0;
    }

    function dragStarted(a_pos)
    {
        console.log("drag started");
        m_dragged = fieldAt(a_pos);
        m_placeholder = id_placeholders.itemAt(BoardJS.pawnOrPieceIndex(m_dragged.value));
        m_placeholder.width = m_dragged.width; m_placeholder.height = m_dragged.height;
        m_placeholder.setCenter(a_pos);
        m_placeholder.visible = true;
        m_dragged.mask = true;
    }

    function dragging(a_pos)
    {
        console.log("dragging");
        m_placeholder.setCenter(a_pos);
    }

    function drop(a_pos)
    {
        console.log("drop");
    }
}
