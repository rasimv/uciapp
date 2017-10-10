import QtQuick 2.9
import QtQuick.Layouts 1.3

Item
{
    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        PlayerBlock
        {
            Layout.fillWidth: true
            height: 50
        }

        Rectangle
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "yellow"
        }

        PlayerBlock
        {
            Layout.fillWidth: true
            height: 50
        }
    }
}
