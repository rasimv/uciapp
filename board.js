.pragma library

//------------------------------------------------------------------------------
var s_pawnsAndPieces = "rnbqkpPRNBQK";

var s_imageFilepaths = ["images/Chess_rdt45.svg", "images/Chess_ndt45.svg", "images/Chess_bdt45.svg",
                        "images/Chess_qdt45.svg", "images/Chess_kdt45.svg", "images/Chess_pdt45.svg",
                        "images/Chess_plt45.svg", "images/Chess_rlt45.svg", "images/Chess_nlt45.svg",
                        "images/Chess_blt45.svg", "images/Chess_qlt45.svg", "images/Chess_klt45.svg"];

function pawnOrPieceIndex(a) { return s_pawnsAndPieces.indexOf(a); }

function imageFilepath(a)
{
    var l_index = pawnOrPieceIndex(a);
    return l_index < 0 ? "" : s_imageFilepaths[l_index];
}

//------------------------------------------------------------------------------
var BD_S_DEFAULT = 0;
var BD_S_MOUSE_PRESSED_1 = 1;
var BD_S_MOUSE_PRESSED_2 = 2;
var BD_S_MOUSE_DRAG_STARTED = 3;
var BD_S_MOUSE_DRAGGING = 4;
var BD_S_MOUSE_DROP = 5;

var BD_SIG_DEFAULT = 0;
var BD_SIG_MOUSE_PRESSED = 1;
var BD_SIG_MOUSE_POS_CHANGED = 2;
var BD_SIG_MOUSE_RELEASED = 3;

//------------------------------------------------------------------------------
var s_dragTolerance = 5;

//------------------------------------------------------------------------------
function BoardData(a_board)
{
    this.m_board = a_board;
    this.m_state = BD_S_DEFAULT;
}

BoardData.prototype.indexToCoords = function (a)
{
    var r = Math.floor(a / 8);
    return Qt.point(a % 8, this.m_board.flip ? 7 - r : r);
}

BoardData.prototype.coordsToIndex = function (a)
{
    var r = this.m_board.flip ? 7 - a.y : a.y;
    return a.x + 8 * r;
}

BoardData.prototype.transition = function (a_sig)
{
    switch (this.m_state)
    {
        case BD_S_DEFAULT:
            if (a_sig == BD_SIG_MOUSE_PRESSED)
            {
                this.m_state = BD_S_MOUSE_PRESSED_1;
                return true;
            }
            break;
        case BD_S_MOUSE_PRESSED_1:
            this.m_state = this.m_board.isDraggable(this.m_pressedPos) ? BD_S_MOUSE_PRESSED_2 : BD_S_DEFAULT;
            break;
        case BD_S_MOUSE_PRESSED_2:
            if (a_sig == BD_SIG_MOUSE_RELEASED) this.m_state = BD_S_DEFAULT;
            else if (Math.abs(this.m_pos.x - this.m_pressedPos.x) > s_dragTolerance ||
                Math.abs(this.m_pos.y - this.m_pressedPos.y) > s_dragTolerance)
            {
                this.m_state = BD_S_MOUSE_DRAG_STARTED;
                return true;
            }
            break;
        case BD_S_MOUSE_DRAG_STARTED:
            this.m_state = BD_S_MOUSE_DRAGGING;
            break;
        case BD_S_MOUSE_DRAGGING:
            if (a_sig == BD_SIG_MOUSE_RELEASED)
            {
                this.m_state = BD_S_MOUSE_DROP;
                return true;
            }
            break;
        case BD_S_MOUSE_DROP:
            this.m_state = BD_S_DEFAULT;
            break;
    }
    return false;
}

BoardData.prototype.action = function (a_sig)
{
    switch (this.m_state)
    {
        case BD_S_DEFAULT:
            break;
        case BD_S_MOUSE_PRESSED_1:
            this.m_pressedPos = Qt.point(this.m_pos.x, this.m_pos.y);
            break;
        case BD_S_MOUSE_PRESSED_2:
            break;
        case BD_S_MOUSE_DRAG_STARTED:
            this.m_board.dragStarted(this.m_pressedPos);
            break;
        case BD_S_MOUSE_DRAGGING:
            this.m_board.dragging(this.m_pos);
            break;
        case BD_S_MOUSE_DROP:
            this.m_board.drop(this.m_pos);
            break;
    }
}

BoardData.prototype.machine = function (a_sig)
{
    while (true)
    {
        var q = this.transition(a_sig);
        this.action(a_sig);
        if (!q) break;
    }
}

BoardData.prototype.mousePressed = function (a_pos)
{
    this.m_pos = a_pos;
    this.machine(BD_SIG_MOUSE_PRESSED);
}

BoardData.prototype.mousePosChanged = function (a_pos)
{
    this.m_pos = a_pos;
    this.machine(BD_SIG_MOUSE_POS_CHANGED);
}

BoardData.prototype.mouseReleased = function (a_pos)
{
    this.m_pos = a_pos;
    this.machine(BD_SIG_MOUSE_RELEASED);
}
