import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

Item
{
    property var m_color;

    function setColor(a) { id_colorRect.color = a; }
    function set(a)
    {
    }

    Rectangle
    {
        id: id_colorRect
        anchors.fill: parent
        color: m_color
    }

    Item
    {
        anchors.fill: parent
    }
}
