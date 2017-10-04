import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

Item
{
    property string filepath

    function magicSetCenter(a) { x = a.x - width / 2; y = a.y - height / 2; }
    function magicSetSize(a) { width = a.x; height = a.y; }

    Image
    {
        anchors.fill: parent
        sourceSize.width: 256
        sourceSize.height: 256
        source: filepath
    }
}
