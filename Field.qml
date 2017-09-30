import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import "field.js" as FieldJS

Item
{
    property var m_aggr
    property var m_index
    property var m_color
    property string m_value: "0"

    function set(a) { m_value = a; id_cell.set(a); }
    function value() { return m_value; }

    function dragPos()
    {
        var l_ofs = id_cell.offset();
        var l_center = id_cell.center();
        return Qt.point(l_ofs.x + l_center.x, l_ofs.y + l_center.y);
    }

    Rectangle
    {
        anchors.fill: parent
        color: m_color
    }

    Item
    {
        id: id_cell
        width: parent.width
        height: parent.height

        function center() { return Qt.point(x + width / 2, y + height / 2); }
        function setPos(a) { x = a.x; y = a.y; }

        function set(a)
        {
            for (var i = 0; i < id_nested.children.length; i++) id_nested.children[i].destroy();
            id_nested.children.length = 0;
            var l_fileName = FieldJS.imageFilename(a);
            if (l_fileName == "") return;
            Qt.createQmlObject(FieldJS.imageQML("images/Chess_pdt45.svg"), id_nested, "Field.qml");
        }

        function offset(a) { return Qt.point(id_nested.x, id_nested.y); }
        function setOffset(a) { id_nested.x = a.x; id_nested.y = a.y; }

        Item
        {
            id: id_nested
            width: parent.width
            height: parent.height
        }
    }

    property real m_z
    property bool dragActive: id_mouseArea.drag.active

    onDragActiveChanged:
    {
        if (dragActive)
        {
            var l_center = id_cell.center();
            var l_mousePos = id_mouseArea.pressedPos();
            var l_ofs = Qt.point(l_mousePos.x - l_center.x, l_mousePos.y - l_center.y);
            id_cell.setOffset(l_ofs);
            m_z = z; z = 1;
        }
        else
        {
            id_cell.setOffset(Qt.point(0, 0));
            id_cell.setPos(Qt.point(0, 0));
            z = m_z;
        }
        m_aggr.dragActiveChanged(this);
    }

    MouseArea
    {
        id: id_mouseArea
        anchors.fill: parent
        drag.target: id_cell

        property var m_pressedPos
        function pressedPos() { return m_pressedPos; }
        onPressed: { m_pressedPos = Qt.point(mouseX, mouseY); }
    }
}
