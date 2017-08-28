import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

Item
{
    GridLayout
    {
        anchors.fill: parent
        columns: 8
        rows: 8

        Repeater
        {
            model: [0, 1, 0, 1, 0, 1, 0, 1,
                    1, 0, 1, 0, 1, 0, 1, 0,
                    0, 1, 0, 1, 0, 1, 0, 1,
                    1, 0, 1, 0, 1, 0, 1, 0,
                    0, 1, 0, 1, 0, 1, 0, 1,
                    1, 0, 1, 0, 1, 0, 1, 0,
                    0, 1, 0, 1, 0, 1, 0, 1,
                    1, 0, 1, 0, 1, 0, 1, 0];

            Rectangle
            {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: modelData ? "blue" : "green"
            }
        }
    }
}
