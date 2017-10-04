import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import "board.js" as BoardJS

Item
{
    id: id_board

    property bool flip: false
    property var magicColors: ["#707070", "#909090"]
    property var transfVelocity: 80

    function qqq1() { console.log("qqq1"); id_repeater.itemAt(57).magicValue = "N"; }
    function qqq2() { console.log("qqq2"); flip = !flip; }

    function setLegalPlies(a) { m_data.m_legalPlies = a; }

//------------------------------------------------------------------------------
    property var m_data: new BoardJS.BoardData(this)

    property var m_dragged
    property var m_placeholder

//------------------------------------------------------------------------------
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

                magicIndex: index
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

//------------------------------------------------------------------------------
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

//------------------------------------------------------------------------------
    Timer
    {
        id: id_timer
        interval: 30; repeat: true
    }

//------------------------------------------------------------------------------
    onFlipChanged:
    {
        for (var i = 0; i < 4; i++)
            for (var j = 0; j < 8; j++)
            {
                var o = id_repeater.itemAt(m_data.coordsToIndex(Qt.point(j, i)));
                var a = id_repeater.itemAt(m_data.coordsToIndex(Qt.point(j, 7 - i)));
                var v = o.magicValue; o.magicValue = a.magicValue; a.magicValue = v;
            }
    }

//------------------------------------------------------------------------------
    function fieldAt(a) { return id_layout.childAt(a.x, a.y); }

//------------------------------------------------------------------------------
    function transfer()
    {
    }

//------------------------------------------------------------------------------
    function isDraggable(a_pos)
    {
        var l_field = fieldAt(a_pos);
        return l_field != null && BoardJS.pawnOrPieceIndex(l_field.magicValue) >= 0;
    }

    function dragStarted(a_pos)
    {
        console.log("drag started");
        m_dragged = fieldAt(a_pos);
        m_placeholder = id_placeholders.itemAt(BoardJS.pawnOrPieceIndex(m_dragged.magicValue));
        m_placeholder.width = m_dragged.width; m_placeholder.height = m_dragged.height;
        m_placeholder.setCenter(a_pos);
        m_placeholder.visible = true;
        m_dragged.magicMask = true;
    }

    function dragging(a_pos)
    {
        console.log("dragging");
        m_placeholder.setCenter(a_pos);
    }

    function drop(a_pos)
    {
        console.log("drop");
        var l_target = fieldAt(a_pos);
        if (l_target != null && l_target != m_dragged)
        {
            var l_from = m_data.indexToCoords(m_dragged.magicIndex);
            var l_to = m_data.indexToCoords(l_target.magicIndex);
            var l_info = m_data.findPly(l_from, l_to);
            if (l_info != null)
            {
                l_target.magicValue = m_dragged.magicValue;
                m_dragged.magicValue = "0";
            }
        }
        m_dragged.magicMask = false;
        m_placeholder.visible = false;
    }

//------------------------------------------------------------------------------
}
