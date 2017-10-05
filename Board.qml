import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import "chessutil.js" as ChessUtil
import "board.js" as BoardJS

Item
{
    id: id_board

    property bool flip: false
    property var magicColors: ["#707070", "#909090"]
    property var transfVelocity: 10    // sq/s

    function qqq1()
    {
        console.log("qqq1"); //id_repeater.itemAt(57).magicSetValue("N");
        transfer(new ChessUtil.Coords(1, 7), new ChessUtil.Coords(7, 1))
    }

    function qqq2() { console.log("qqq2"); flip = !flip; }

    function setLegalPlies(a) { m_data.m_legalPlies = a; }

    function fromLayout(a)
    {
        for (var i = 0; i < id_repeater.count; i++)
        {
            var l_field = id_repeater.itemAt(i);
            var l_coords = m_data.indexToCoords(l_field.magicIndex);
            l_field.magicSetValue(a.item(l_coords));
        }
    }

//------------------------------------------------------------------------------
    property var m_data: new BoardJS.BoardData(this)

    property var m_dragged
    property var m_placeholder

    property var m_transfTarget
    property var m_transfTimeFix
    property var m_transfMatrix
    property var m_transfFunc

    property var m_plyInfo
    property var m_makePlyState

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

    PromoPanel
    {}

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
        onTriggered: callable()

        property var callable
    }

//------------------------------------------------------------------------------
    onFlipChanged:
    {
        for (var i = 0; i < 4; i++)
            for (var j = 0; j < 8; j++)
            {
                var o = fieldByCoords(new ChessUtil.Coords(j, i));
                var a = fieldByCoords(new ChessUtil.Coords(j, 7 - i));
                var v = o.magicValue(); o.magicSetValue(a.magicValue()); a.magicSetValue(v);
            }
    }

//------------------------------------------------------------------------------
    function fieldAt(a) { return id_layout.childAt(a.x, a.y); }
    function fieldByCoords(a) { return id_repeater.itemAt(m_data.coordsToIndex(a)); }
    function placeholderByValue(a) { return id_placeholders.itemAt(BoardJS.pawnOrPieceIndex(a)); }

//------------------------------------------------------------------------------
    function transfOnTimer()
    {
		if (m_transfTarget == null) return;
        var l_timeFix = new Date().getTime();
        var l_elapsed = (l_timeFix - m_transfTimeFix) / 1000;
        var l_path = transfVelocity * l_elapsed;
        var l_from = m_data.indexToCoords(m_dragged.magicIndex);
        var l_to = m_data.indexToCoords(m_transfTarget.magicIndex);
        var v = l_to.c - l_from.c, h = l_to.r - l_from.r, l = Math.sqrt(h * h + v * v);
        if (l > l_path)
        {
            var l_relPos = m_transfMatrix.times(Qt.vector4d(l_path, 0, 0, 1));
            var l_size = Qt.size(id_layout.width / id_layout.columns, id_layout.height / id_layout.rows);
            var l_center = Qt.point(l_size.width * (0.5 + l_relPos.x), l_size.height * (0.5 + l_relPos.y));
            m_placeholder.magicSetCenter(l_center);
            return;
        }
        id_timer.stop();
        m_placeholder.visible = false;
        m_transfTarget.magicSetValue(m_dragged.magicValue()); m_dragged.magicSetValue("0");
        m_transfTarget = null;
        m_transfFunc();
    }

    function transfer(a_from, a_to)
    {
        m_dragged = fieldByCoords(a_from);
        m_transfTarget = fieldByCoords(a_to);
        m_placeholder = placeholderByValue(m_dragged.magicValue());
        m_placeholder.magicSetSize(m_dragged.magicSize());
        m_placeholder.magicSetCenter(m_dragged.magicCenter());
        var v = a_to.c - a_from.c, h = a_to.r - a_from.r, l = Math.sqrt(h * h + v * v);
        m_transfMatrix = Qt.matrix4x4(v / l, -h / l, 0, a_from.c, h / l, v / l, 0, a_from.r, 0, 0, 1, 0, 0, 0, 0, 1);
        m_placeholder.visible = true; m_dragged.magicSetMask(true);
        m_transfTimeFix = new Date().getTime();
        id_timer.callable = transfOnTimer;
        id_timer.start();
    }

//------------------------------------------------------------------------------
    function isDraggable(a_pos)
    {
        var l_field = fieldAt(a_pos);
        return l_field != null && BoardJS.pawnOrPieceIndex(l_field.magicValue()) >= 0;
    }

    function dragStarted(a_pos)
    {
        console.log("drag started");
        m_dragged = fieldAt(a_pos);
        m_placeholder = placeholderByValue(m_dragged.magicValue());
        m_placeholder.magicSetSize(m_dragged.magicSize());
        m_placeholder.magicSetCenter(a_pos);
        m_placeholder.visible = true; m_dragged.magicSetMask(true);
    }

    function dragging(a_pos)
    {
        console.log("dragging");
        m_placeholder.magicSetCenter(a_pos);
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
                l_target.magicSetValue(m_dragged.magicValue());
                m_dragged.magicSetValue("0");
            }
        }
        m_dragged.magicSetMask(false);
        m_placeholder.visible = false;
    }

//------------------------------------------------------------------------------
    function makePly(a_info)
    {
        m_plyInfo = a_info;
        m_makePlyState = 0;
        m_transfFunc = makePlyFunc;
        makePlyFunc();
    }

    function makePlyFunc()
    {
        if (m_makePlyState < m_plyInfo.transp.length)
        {
            var l_pair = m_plyInfo.transp[m_makePlyState];
            if (l_pair[1].isValid()) { transfer(l_pair[0], l_pair[1]); m_makePlyState++; }
            else { fieldByCoords(l_pair[0]).magicSetValue("0"); m_makePlyState++; makePlyFunc(); }
            return;
        }
        if (m_plyInfo.promotion != "")
        {
            var l_pair = m_plyInfo.transp[0];
            fieldByCoords(l_pair[1]).magicSetValue(m_plyInfo.promotion);
        }
    }
}
