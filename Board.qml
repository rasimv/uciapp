import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

Item
{
    id: id_board
    property var m_colors: ["#707070", "#909090"]

    function qqq()
    {
        id_repeater.itemAt(5).set("P");
    }

    GridLayout
    {
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
                m_index: index
                m_color: m_colors[(Math.floor(index / 8) % 2 + index % 2) % 2]

                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}
