import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import "board.js" as BoardJS

Item
{
    property color magicColor

    Rectangle
    {
        anchors.fill: parent
        color: magicColor
    }

    Item
    {
        id: id_cell
        anchors.fill: parent
    }
}
