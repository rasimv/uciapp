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
        rowSpacing: 0
        columnSpacing: 0

        Repeater
        {
            model: 64
            Field
            {
                Layout.fillWidth: true
                Layout.fillHeight: true
                m_color: (Math.floor(index / 8) % 2 + index % 2) % 2 ? "#707070" : "#909090"
            }
        }
    }
}
