import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

Item
{
    property var m_color

    function get()
    {
        if (id_pieceText.text == "\u265f") return id_pieceText.color == "white" ? "P" : "p"
        if (id_pieceText.text == "\u265c") return id_pieceText.color == "white" ? "R" : "r"
        if (id_pieceText.text == "\u265e") return id_pieceText.color == "white" ? "N" : "n"
        if (id_pieceText.text == "\u265d") return id_pieceText.color == "white" ? "B" : "b"
        if (id_pieceText.text == "\u265b") return id_pieceText.color == "white" ? "Q" : "q"
        if (id_pieceText.text == "\u265a") return id_pieceText.color == "white" ? "K" : "k"
        return ""
    }

    function set(a)
    {
        if (a == "P") { id_pieceText.text = "\u265f"; id_pieceText.color = "white" }
        else if (a == "p") { id_pieceText.text = "\u265f"; id_pieceText.color = "black" }
        else if (a == "R") { id_pieceText.text = "\u265c"; id_pieceText.color = "white" }
        else if (a == "r") { id_pieceText.text = "\u265c"; id_pieceText.color = "black" }
        else if (a == "N") { id_pieceText.text = "\u265e"; id_pieceText.color = "white" }
        else if (a == "n") { id_pieceText.text = "\u265e"; id_pieceText.color = "black" }
        else if (a == "B") { id_pieceText.text = "\u265d"; id_pieceText.color = "white" }
        else if (a == "b") { id_pieceText.text = "\u265d"; id_pieceText.color = "black" }
        else if (a == "Q") { id_pieceText.text = "\u265b"; id_pieceText.color = "white" }
        else if (a == "q") { id_pieceText.text = "\u265b"; id_pieceText.color = "black" }
        else if (a == "K") { id_pieceText.text = "\u265a"; id_pieceText.color = "white" }
        else if (a == "k") { id_pieceText.text = "\u265a"; id_pieceText.color = "black" }
        else id_pieceText.text = ""
    }

    Rectangle
    {
        anchors.fill: parent
        color: m_color
    }

    Item
    {
        id: id_piece
        anchors.fill: parent

        Text
        {
            id: id_pieceText

            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter

            minimumPointSize: 1
            font.pointSize: 100
            fontSizeMode: Text.Fit
        }
    }
}
