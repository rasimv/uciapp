.pragma library

.import "chessutil.js" as ChessUtil

//------------------------------------------------------------------------------
var s_imageFilepaths = ["images/Chess_pdt45.svg", "images/Chess_pdt45.svg", "images/Chess_pdt45.svg",
                        "images/Chess_pdt45.svg", "images/Chess_pdt45.svg", "images/Chess_pdt45.svg",
                        "images/Chess_pdt45.svg", "images/Chess_pdt45.svg", "images/Chess_pdt45.svg",
                        "images/Chess_pdt45.svg", "images/Chess_pdt45.svg", "images/Chess_pdt45.svg"];

function imageFilepath(a)
{
    var l_found = ChessUtil.s_pawnsAndPieces.indexOf(a);
    return l_found < 0 ? "" : s_imageFilepaths[l_found];
}

//------------------------------------------------------------------------------
var BD_S_DEFAULT = 0;

//------------------------------------------------------------------------------
function BoardData(a_board)
{
    this.m_board = a_board;
    this.m_state = BD_S_DEFAULT;
}

BoardData.prototype.mousePosChanged = function (a_pos)
{
    console.log("" + a_pos.x + ":" + a_pos.y)
}

BoardData.prototype.mousePressed = function (a_pos)
{}

BoardData.prototype.mouseReleased = function (a_pos)
{}
