import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

Item
{
    property var m_color

    Rectangle
    {
        anchors.fill: parent
        color: m_color
    }
}
