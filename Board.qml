import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

Item
{
    property var m_colors: ["#707070", "#909090"]

    GridLayout
    {
        columns: 8
        rows: 8
        anchors.fill: parent
        rowSpacing: 0
        columnSpacing: 0

        Repeater
        {
            model: 64
            Field
            {
                m_color: m_colors[(Math.floor(index / 8) % 2 + index % 2) % 2]

                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}
