import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import "board.js" as BoardJS

Item
{
    property int magicIndex
    property color magicColor
    property bool magicMask: false
    property string magicValue: "0"

    function magicCenter() { return Qt.point(x + width / 2, y + height / 2); }
    function magicSize() { return Qt.point(width, height); }

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

    onMagicMaskChanged:
    {
        id_image.visible = !magicMask;
    }

    onMagicValueChanged:
    {
        var l_filepath = BoardJS.imageFilepath(magicValue);
        id_image.source = l_filepath;
        id_image.visible = l_filepath != "";
    }
}
