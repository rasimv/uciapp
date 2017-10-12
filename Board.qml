import QtQuick 2.9
import QtQuick.Layouts 1.3
import "chessutil.js" as ChessUtil
import "board.js" as BoardJS

Item
{
    id: id_board

//------------------------------------------------------------------------------
    property bool flip: false
    property var magicColors: ["#cfd6e5", "#4c6082"]
    property var transfVelocity: 20    // sq/s

    function compPly(a_info)
    {
        makePly(a_info);
    }

    function userPly(a_legal)
    {
        setLegalPlies(a_legal);
        m_dragEnabled = true;
    }

    signal compPlyMade(variant a_info);
    signal userPlyMade(variant a_info);

    function fromLayout(a)
    {
        for (var i = 0; i < id_repeater.count; i++)
        {
            var l_field = id_repeater.itemAt(i);
            var l_coords = m_data.indexToCoords(l_field.magicIndex);
            l_field.magicSetValue(a.item(l_coords));
        }
    }

    function stop()
    {
        id_timer1.stop(); id_timer2.stop();
        m_data.reset();
        id_placeholders.magicHide();
        id_repeater.magicSetMask(false);
    }

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
            function magicSetMask(a) { for (var i = 0; i < count; i++) itemAt(i).magicSetMask(a); }
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
        function magicHide() { for (var i = 0; i < count; i++) itemAt(i).visible = false; }
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

    PromoPanel
    {
        id: id_promoPanel
        flip: id_board.flip

        function activateExt(a_field, a_callable) { m_callable = a_callable; magicActivate(a_field); }

        visible: false
        width: id_layout.width / id_layout.columns
        fieldHeight: id_layout.height / id_layout.rows

        anchors.top: parent.top
        anchors.bottom: parent.bottom

        property var m_callable
        onPieceSelected: { m_callable(a); }
    }

    Timer
    {
        id: id_timer1
        function magicStart(a_callable, a_arg) { m_callable = a_callable; m_arg = a_arg; start(); }
        interval: 30; repeat: true
        onTriggered: m_callable(m_arg)
        property var m_callable
        property var m_arg
    }

    SingleShotTimer { id: id_timer2 }

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
    property var m_data: new BoardJS.BoardData(this)
    property var m_flipMatrix: Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)

    property var m_dragEnabled: false
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
    function fieldAt(a) { return id_layout.childAt(a.x, a.y); }
    function fieldByCoords(a) { return id_repeater.itemAt(m_data.coordsToIndex(a)); }
    function placeholderByValue(a) { return id_placeholders.itemAt(BoardJS.pawnOrPieceIndex(a)); }

//------------------------------------------------------------------------------
    function transfOnTimer(a)
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
        id_timer1.stop();
        m_placeholder.visible = false;
        var l_source = fieldByCoords(m_transfFrom), l_target = fieldByCoords(m_transfTo);
        l_target.magicSetValue(l_source.magicValue()); l_source.magicSetValue("0");
        m_transfTo = null;
        m_transfFunc();
    }

    function transfer(a_from, a_to)
    {
        m_transfFrom = a_from; m_transfTo = a_to;
        var l_source = fieldByCoords(m_transfFrom);
        m_placeholder = placeholderByValue(l_source.magicValue());
        m_placeholder.magicSetSize(l_source.magicSize());
        m_placeholder.magicSetCenter(l_source.magicCenter());
        var h = a_to.c - a_from.c, v = a_to.r - a_from.r, l = Math.sqrt(h * h + v * v);
        m_transfMatrix = Qt.matrix4x4(h / l, -v / l, 0, a_from.c, v / l, h / l, 0, a_from.r, 0, 0, 1, 0, 0, 0, 0, 1);
        m_placeholder.visible = true; l_source.magicSetMask(true);
        m_transfTimeFix = new Date().getTime();
        id_timer1.magicStart(transfOnTimer, 0);
    }

//------------------------------------------------------------------------------
    function isDraggable(a_pos)
    {
        var l_field = fieldAt(a_pos);
        return l_field != null && BoardJS.pawnOrPieceIndex(l_field.magicValue()) >= 0;
    }

    function dragStarted(a_pos)
    {
        var l_field = fieldAt(a_pos);
        m_drag = m_data.indexToCoords(l_field.magicIndex);
        m_placeholder = placeholderByValue(l_field.magicValue());
        m_placeholder.magicSetSize(l_field.magicSize());
        m_placeholder.magicSetCenter(a_pos);
        m_placeholder.visible = true; l_field.magicSetMask(true);
    }

    function dragging(a_pos)
    {
        m_placeholder.magicSetCenter(a_pos);
    }

    function drop(a_pos)
    {
        var l_source = fieldByCoords(m_drag);
        var l_target = fieldAt(a_pos);
        if (l_target != null && l_source != l_target)
        {
            var l_drop = m_data.indexToCoords(l_target.magicIndex);
            var l_info = m_data.findPly(m_drag, l_drop);
            if (l_info != null)
            {
                l_source.magicSetMask(false); m_placeholder.visible = false;
                finishPly(l_info);
                return;
            }
        }
        l_source.magicSetMask(false); m_placeholder.visible = false;
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
        id_timer2.singleShot(emitCompPly, m_plyInfo);
    }

    function emitCompPly(a)
    {
        compPlyMade(a);
    }

//------------------------------------------------------------------------------
    function finishPly(a_info)
    {
        m_plyInfo = a_info;
        m_dragEnabled = false;
        var t = a_info.transp[0];
        var l_source = fieldByCoords(t[0]);
        var l_target = fieldByCoords(t[1]);
        l_target.magicSetValue(l_source.magicValue());
        l_source.magicSetValue("0");
        if (a_info.promotion != "")
        {
            id_promoPanel.activateExt(l_target, finishPlyFunc);
            return;
        }
        if (a_info.transp.length < 2)
        {
            id_timer2.singleShot(emitUserPly, m_plyInfo);
            return;
        }
        var t = a_info.transp[1];
        if (!t[1].isValid())
        {
            fieldByCoords(t[0]).magicSetValue("0");
            id_timer2.singleShot(emitUserPly, m_plyInfo);
            return;
        }
        l_source = fieldByCoords(t[0]);
        l_target = fieldByCoords(t[1]);
        l_target.magicSetValue(l_source.magicValue());
        l_source.magicSetValue("0");
        id_timer2.singleShot(emitUserPly, m_plyInfo);
    }

    function finishPlyFunc(a)
    {
        var t = m_plyInfo.transp[0];
        var l_info = m_data.findPly(t[0], t[1], a.toLowerCase());
        t = l_info.transp[0];
        var l_target = fieldByCoords(t[1]);
        l_target.magicSetValue(a);
        id_timer2.singleShot(emitUserPly, l_info);
    }

    function emitUserPly(a)
    {
        userPlyMade(a);
    }

//------------------------------------------------------------------------------
    function setLegalPlies(a) { m_data.m_legalPlies = a; }
}
