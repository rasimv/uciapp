import QtQuick 2.9
import "board.js" as BoardJS

Item
{
    property int magicIndex
    property color magicColor

    function magicCenter() { return Qt.point(x + width / 2, y + height / 2); }
    function magicSize() { return Qt.size(width, height); }

    function magicValue() { return m_value; }
    function magicSetValue(a)
    {
        m_value = a;
        var l_filepath = BoardJS.imageFilepath(m_value);
        id_image.source = l_filepath;
        id_image.visible = l_filepath != "";
    }

    function magicSetMask(a) { id_image.visible = !a; }

//------------------------------------------------------------------------------
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

//------------------------------------------------------------------------------
    property string m_value: "0"
}
