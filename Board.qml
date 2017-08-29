import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

Item
{
    GridLayout
    {
        columns: 8
        rows: 8
        anchors.fill: parent

        Repeater
        {
            id: id_repeater
            model: 64

            Rectangle
            {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: (Math.floor(index / 8) % 2 + index % 2) % 2 ? "yellow" : "brown"
            }
        }
    }
}
