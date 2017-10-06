import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import "chessutil.js" as ChessUtil
import "board.js" as BoardJS

Item
{
    id: id_board

    property bool flip: false
    property var magicColors: ["#909090", "#707070"]
    property var transfVelocity: 10    // sq/s

    function qqq1()
    {
        //console.log("qqq1"); id_repeater.itemAt(57).magicSetValue("N");
        //transfer(new ChessUtil.Coords(1, 7), new ChessUtil.Coords(7, 1))
        id_promoPanel.king = id_promoPanel.king == "P" ? "p" : "P";
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
    property var m_flipMatrix: Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)

    property var m_drag
    property var m_placeholder

    property var m_transfFrom
    property var m_transfTo
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
    {
        id: id_promoPanel
        flip: id_board.flip
        x: 100
        width: 100
        height: 400
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
        onTriggered: callable()

        property var callable
    }

//------------------------------------------------------------------------------
    onFlipChanged:
    {
        m_flipMatrix.m22 = flip ? -1 : 1; m_flipMatrix.m24 = flip ? 7 : 0;
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
        if (m_transfTo == null) return;
        var l_timeFix = new Date().getTime();
        var l_elapsed = (l_timeFix - m_transfTimeFix) / 1000;
        var l_path = transfVelocity * l_elapsed;
        var h = m_transfTo.c - m_transfFrom.c, v = m_transfTo.r - m_transfFrom.r;
        var l = Math.sqrt(h * h + v * v);
        if (l > l_path)
        {
            var l_relPos = m_flipMatrix.times(m_transfMatrix.times(Qt.vector4d(l_path, 0, 0, 1)));
            var l_size = Qt.size(id_layout.width / id_layout.columns, id_layout.height / id_layout.rows);
            var l_center = Qt.point(l_size.width * (0.5 + l_relPos.x), l_size.height * (0.5 + l_relPos.y));
            m_placeholder.magicSetCenter(l_center);
            return;
        }
        id_timer.stop();
        m_placeholder.visible = false;
        var l_source = fieldByCoords(m_transfFrom), l_target = fieldByCoords(m_transfTo);
        l_target.magicSetValue(l_source.magicValue()); l_source.magicSetValue("0");
        m_transfTo = null;
        m_transfFunc();
    }

    function transfer(a_from, a_to)
    {
        m_transfFrom = a_from, m_transfTo = a_to;
        var l_source = fieldByCoords(m_transfFrom);
        m_placeholder = placeholderByValue(l_source.magicValue());
        m_placeholder.magicSetSize(l_source.magicSize());
        m_placeholder.magicSetCenter(l_source.magicCenter());
        var h = a_to.c - a_from.c, v = a_to.r - a_from.r, l = Math.sqrt(h * h + v * v);
        m_transfMatrix = Qt.matrix4x4(h / l, -v / l, 0, a_from.c, v / l, h / l, 0, a_from.r, 0, 0, 1, 0, 0, 0, 0, 1);
        m_placeholder.visible = true; l_source.magicSetMask(true);
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
        var l_field = fieldAt(a_pos);
        m_drag = m_data.indexToCoords(l_field.magicIndex);
        m_placeholder = placeholderByValue(l_field.magicValue());
        m_placeholder.magicSetSize(l_field.magicSize());
        m_placeholder.magicSetCenter(a_pos);
        m_placeholder.visible = true; l_field.magicSetMask(true);
    }

    function dragging(a_pos)
    {
        console.log("dragging");
        m_placeholder.magicSetCenter(a_pos);
    }

    function drop(a_pos)
    {
        console.log("drop");
        var l_source = fieldByCoords(m_drag);
        var l_target = fieldAt(a_pos);
        if (l_target != null && l_source != l_target)
        {
            var l_drop = m_data.indexToCoords(l_target.magicIndex);
            var l_info = m_data.findPly(m_drag, l_drop);
            if (l_info != null)
            {
                l_target.magicSetValue(l_source.magicValue());
                l_source.magicSetValue("0");
            }
        }
        l_source.magicSetMask(false);
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
