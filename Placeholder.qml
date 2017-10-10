import QtQuick 2.9

Item
{
    property string filepath

    function magicSetCenter(a) { x = a.x - width / 2; y = a.y - height / 2; }
    function magicSetSize(a) { width = a.width; height = a.height; }

    Image
    {
        anchors.fill: parent
        sourceSize.width: 256
        sourceSize.height: 256
        source: filepath
    }
}
