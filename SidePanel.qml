import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

Item
{
    function setFlip(a)
    {
        if (a != id_flip.checked) { id_flip.checked = !id_flip.checked; flip(); }
    }

    function setStartStop(a) { id_startStopButton.magicState = a; }

    function setResult(a_line1, a_line2)
    {
        if (a_line1 == "" && a_line2 == "") id_result.visible = false;
        id_resultLine1.text = a_line1; id_resultLine2.text = a_line2;
        id_result.visible = true;
    }

    signal flipped(bool a);
    signal magicStart(bool a_compUser1, bool a_compUser2);
    signal magicStop();

    PlayerBlock
    {
        id: id_topPlayerBlock
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        enabled: !id_startStopButton.magicState
    }

    Rectangle
    {
        anchors.top: id_topPlayerBlock.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: id_bottomPlayerBlock.top
        color: "#ffa66a"

        Item
        {
            width: parent.width
            anchors.top: parent.top
            anchors.bottom: id_startStopFlip.top

            Item
            {
                id: id_result
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                height: id_resultLine1.height + id_resultLine2.height

                Text
                {
                    id: id_resultLine1
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text
                {
                    id: id_resultLine2
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Item
        {
            id: id_startStopFlip
            width: parent.width
            height: id_startStopButton.height + id_flip.height
            anchors.centerIn: parent

            Button
            {
                id: id_startStopButton

                property var magicState: false

                text: magicState ? "Stop" : "Start"

                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter

                onClicked:
                {
                    magicState = !magicState;
                    if (!magicState) magicStop();
                    else if (id_flip.checked)
                        magicStart(id_topPlayerBlock.magicState(), id_bottomPlayerBlock.magicState());
                    else
                        magicStart(id_bottomPlayerBlock.magicState(), id_topPlayerBlock.magicState());
                }
            }

            CheckBox
            {
                id: id_flip

                text: "Flip"

                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter

                onToggled: flip()
            }
        }
    }

    PlayerBlock
    {
        id: id_bottomPlayerBlock
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        enabled: !id_startStopButton.magicState
    }

    function flip()
    {
        var s = id_topPlayerBlock.magicState();
        id_topPlayerBlock.magicSetState(id_bottomPlayerBlock.magicState());
        id_bottomPlayerBlock.magicSetState(s);
        flipped(id_flip.checked);
    }

    Item { Component.onCompleted: id_topPlayerBlock.magicSetState(true); }
}
