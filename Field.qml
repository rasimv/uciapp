import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import "board.js" as BoardJS

Item
{
    property color magicColor
    property bool mask: false
    property string value: "0"

    Rectangle
    {
        anchors.fill: parent
        color: magicColor
    }

    Image
    {
        id: id_image
        anchors.fill: parent
        sourceSize.width: 256
        sourceSize.height: 256
    }

    onMaskChanged:
    {
        id_image.visible = !mask;
    }

    onValueChanged:
    {
        var l_filepath = BoardJS.imageFilepath(value);
        id_image.source = l_filepath;
        id_image.visible = l_filepath != "";
    }
}
