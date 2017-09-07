import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

Item
{
    function setFromArray(a_pos)
    {
        for (var i = 0; i < 8; i++)
            for (var j = 0; j < 8; j++)
                id_repeater.itemAt(8 * i + j).set(a_pos[i][j])
    }

    GridLayout
    {
        id: id_boardLayout

        columns: 8
        rows: 8
        anchors.fill: parent
        rowSpacing: 0
        columnSpacing: 0

        Repeater
        {
            id: id_repeater
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
