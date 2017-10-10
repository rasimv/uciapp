import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

Item
{
    function minimalHeight()
    {
        return id_item1.height + id_text1.height + id_radioButton1.height + id_item2.height;
    }

    Rectangle
    {
        anchors.fill: parent
        color: "green"
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            id: id_item1
            Layout.fillWidth: true
            height: 0.4 * id_text1.height
        }

        Item
        {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Text
            {
                id: id_text1
                anchors.left: parent.left
                width: id_radioButton1.width

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                text: "Comp"
            }

            Text
            {
                id: id_text2
                anchors.right: parent.right
                width: id_radioButton2.width

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                text: "User"
            }
        }

        RowLayout
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            RadioButton
            {
                id: id_radioButton1
                Layout.fillWidth: true

                checked: true
            }

            RadioButton
            {
                id: id_radioButton2
                Layout.fillWidth: true
            }
        }

        Item
        {
            id: id_item2
            Layout.fillWidth: true
            height: 0.4 * id_text1.height
        }
    }
}
