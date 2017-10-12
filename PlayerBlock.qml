import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

Item
{
    function magicState() { return id_radioButtonComp.checked; }
    function magicSetState(a) { id_radioButtonComp.checked = a; id_radioButtonUser.checked = !a; }

    height: id_spacer1.height + id_textCompUser.height + id_rbCompUser.height + id_spacer2.height

    Rectangle
    {
        anchors.fill: parent
        color: "#a083d1"
    }

    Item
    {
        id: id_spacer1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 0.4 * id_textCompUser.height
    }

    Item
    {
        id: id_textCompUser

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: id_spacer1.bottom
        height: id_textComp.height

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
        id: id_rbCompUser

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: id_textCompUser.bottom
        height: id_radioButtonComp.height
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
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: id_rbCompUser.bottom
        height: 0.4 * id_textCompUser.height
    }
}
