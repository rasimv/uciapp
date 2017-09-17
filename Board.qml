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

    function move(a)
    {
        var c = Math.floor(a.length / 4)
        for (var i = 0; i < c; i++)
        {
            var k = 4 * i
            var q = id_repeater.itemAt(a[k] + 8 * a[k + 1]).get()
            id_repeater.itemAt(a[k + 2] + 8 * a[k + 3]).set(q)
            id_repeater.itemAt(a[k] + 8 * a[k + 1]).set("")
        }
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
