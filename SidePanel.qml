import QtQuick 2.9
import QtQuick.Layouts 1.3

Item
{
    Rectangle
    {
        anchors.fill: parent
        color: "yellow"
    }

    PlayerBlock
    {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: minimalHeight()
    }

    PlayerBlock
    {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: minimalHeight()
    }
}
