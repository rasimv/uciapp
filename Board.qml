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
        id: id_layout

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
                m_aggr: id_board
                m_index: index
                m_color: m_colors[(Math.floor(index / 8) % 2 + index % 2) % 2]

                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    function dragActiveChanged(a)
    {
        var l_pos = a.dragPos();
        console.log("x: " + l_pos.x + "; y:" + l_pos.y);
        var l_this = mapFromItem(a, l_pos.x, l_pos.y);
        console.log(id_layout.childAt(l_this.x, l_this.y));
    }
}
