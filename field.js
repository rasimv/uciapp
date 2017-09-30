.pragma library

.import "chessutil.js" as ChessUtil

var s_imageFilenames = ["images/Chess_pdg45.svg", "images/Chess_pdg45.svg", "images/Chess_pdg45.svg",
                        "images/Chess_pdg45.svg", "images/Chess_pdg45.svg", "images/Chess_pdg45.svg",
                        "images/Chess_pdg45.svg", "images/Chess_pdg45.svg", "images/Chess_pdg45.svg",
                        "images/Chess_pdg45.svg", "images/Chess_pdg45.svg", "images/Chess_pdg45.svg"];

function imageFilename(a)
{
    var l_found = ChessUtil.s_pawnsAndPieces.indexOf(a);
    return l_found < 0 ? "" : s_imageFilenames[l_found];
}

function imageQML(a_filename)
{
    var s = "import QtQuick 2.7\n" +
            "import QtQuick.Controls 2.0\n" +
            "Image\n" +
            "{\n" +
                "anchors.fill: parent\n" +
                "sourceSize.width: 256\n" +
                "sourceSize.height: 256\n" +
                "source: \"%1\"\n" +
            "}\n";
    return s.arg(a_filename);
}
