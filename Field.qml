import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import "field.js" as FieldJS

Item
{
    property var m_index
    property var m_color

    function set(a) { id_cell.set(a); }

    Rectangle
    {
        anchors.fill: parent
        color: m_color
    }

    Item
    {
        id: id_cell
        x: 0; y: 0
        width: parent.width
        height: parent.height

        function set(a)
        {
            for (var i = 0; i < children.length; i++) children[i].destroy();
            children.length = 0;
            var l_fileName = FieldJS.imageFilename(a);
            if (l_fileName == "") return;
            Qt.createQmlObject(FieldJS.imageQML("images/Chess_pdt45.svg"), id_cell, "Field.qml");
        }
    }
}
