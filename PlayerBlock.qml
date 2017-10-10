import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

Item
{
    Rectangle
    {
        anchors.fill: parent
        color: "green"
    }

    /*GroupBox
    {
        RowLayout
        {
            ExclusiveGroup { id: id_tabPosGroup }

            RadioButton
            {
                text: "Top"
                checked: true
                exclusiveGroup: id_tabPosGroup
            }

            RadioButton
            {
                text: "Bottom"
                exclusiveGroup: id_tabPosGroup
            }
        }
    }*/
}
