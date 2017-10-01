.pragma library

.import "chessutil.js" as ChessUtil

var s_imageFilepaths = ["images/Chess_pdt45.svg", "images/Chess_pdt45.svg", "images/Chess_pdt45.svg",
                        "images/Chess_pdt45.svg", "images/Chess_pdt45.svg", "images/Chess_pdt45.svg",
                        "images/Chess_pdt45.svg", "images/Chess_pdt45.svg", "images/Chess_pdt45.svg",
                        "images/Chess_pdt45.svg", "images/Chess_pdt45.svg", "images/Chess_pdt45.svg"];

function imageFilepath(a)
{
    var l_found = ChessUtil.s_pawnsAndPieces.indexOf(a);
    return l_found < 0 ? "" : s_imageFilepaths[l_found];
}
