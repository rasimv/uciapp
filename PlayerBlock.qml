import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

Item
{
    function magicState() { return id_radioButtonComp.checked; }
    function magicSetState(a) { id_radioButtonComp.checked = a; id_radioButtonUser.checked = !a; }

    function minimalHeight()
    {
        return id_spacer1.height + id_textComp.height + id_radioButtonComp.height + id_spacer2.height;
    }

    Rectangle
    {
        anchors.fill: parent
        color: "#a083d1"
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            id: id_spacer1
            Layout.fillWidth: true
            height: 0.4 * id_textComp.height
        }

        Item
        {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Text
            {
                id: id_textComp
                anchors.left: parent.left
                width: id_radioButtonComp.width

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                text: "Comp"
            }

            Text
            {
                id: id_textUser
                anchors.right: parent.right
                width: id_radioButtonUser.width

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
                id: id_radioButtonComp
                Layout.fillWidth: true
            }

            RadioButton
            {
                id: id_radioButtonUser
                Layout.fillWidth: true

                checked: true
            }
        }

        Item
        {
            id: id_spacer2
            Layout.fillWidth: true
            height: 0.4 * id_textComp.height
        }
    }
}
