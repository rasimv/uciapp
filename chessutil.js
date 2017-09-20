.pragma library

//------------------------------------------------------------------------------
var s_horizontals = "abcdefgh"
var s_verticals = "87654321"
var s_pawnsAndPieces = "rnbqkpPRNBQK"

//------------------------------------------------------------------------------
function sepChar(a) { return a == " " || a == "\t" }

function split_s(a_input, a_sepPred)
{
    var q = []
    var j = 0
    while (j < a_input.length)
    {
        for (; j < a_input.length && a_sepPred(a_input[j]); j++);
        var i = j
        for (; j < a_input.length && !a_sepPred(a_input[j]); j++);
        if (i < j) q.push(a_input.substring(i, j))
    }
    return q
}

//------------------------------------------------------------------------------
function indexToHorizontal(a)
{
    return a >= 0 && a < 8 ? s_horizontals[a] : ""
}

function indexToVertical(a)
{
    return a >= 0 && a < 8 ? s_verticals[a] : ""
}

function horizontalToIndex(a)
{
    return s_horizontals.indexOf(a)
}

function verticalToIndex(a)
{
    return s_verticals.indexOf(a)
}

function isPawnOrPiece(a)
{
    return s_pawnsAndPieces.indexOf(a) >= 0
}

function isOpp(a_one, a_another)
{
    if (!isPawnOrPiece(a_one) || !isPawnOrPiece(a_another)) return false
    return (a_one == a_one.toLowerCase()) != (a_another == a_another.toLowerCase())
}

//------------------------------------------------------------------------------
function Coords(a_col, a_row)
{
    this.c = a_col
    this.r = a_row
}

Coords.prototype.isValid = function ()
{
    return this.c >= 0 && this.c < 8 && this.r >= 0 && this.r < 8
}

Coords.prototype.isEqual = function (a)
{
    return a.c == this.c && a.r == this.r
}

Coords.prototype.clone = function ()
{
    return new Coords(this.c, this.r)
}

Coords.prototype.notation = function ()
{
    return indexToHorizontal(this.c) + indexToVertical(this.r)
}

Coords.prototype.fromNotation = function (a)
{
    this.c = -1; this.r = -1
    if (a.length < 1) return
    if (a.length == 1)
    {
        this.c = horizontalToIndex(a[0])
        if (this.c < 0) this.r = verticalToIndex(a[0])
        return
    }
    this.c = horizontalToIndex(a[0])
    this.r = verticalToIndex(a[1])
}

//------------------------------------------------------------------------------
function Layout()
{
    this.m = [["r","n","b","q","k","b","n","r"],
              ["p","p","p","p","p","p","p","p"],
              ["0","0","0","0","0","0","0","0"],
              ["0","0","0","0","0","0","0","0"],
              ["0","0","0","0","0","0","0","0"],
              ["0","0","0","0","0","0","0","0"],
              ["P","P","P","P","P","P","P","P"],
              ["R","N","B","Q","K","B","N","R"]]
}

Layout.prototype.item = function (a)
{
    return this.m[a.r][a.c]
}

Layout.prototype.setItem = function (a_where, a_value)
{
    this.m[a_where.r][a_where.c] = a_value
}

Layout.prototype.clear = function ()
{
    for (var i = 0; i < 8; i++)
        for (var j = 0; j < 8; j++)
            this.m[i][j] = "0"
}

Layout.prototype.fen = function ()
{
    var l_fen = ""
    for (var i = 0; i < 8; i++)
    {
        if (i > 0) l_fen += "/"
        var l_empyCount = 0
        for (var j = 0; j < 8; j++)
        {
            if (!isPawnOrPiece(this.m[i][j])) { l_empyCount++; continue }
            if (l_empyCount > 0) l_fen += l_empyCount
            l_fen += this.m[i][j]
            l_empyCount = 0
        }
        if (l_empyCount > 0) l_fen += l_empyCount
    }
    return l_fen
}

Layout.prototype.fromFen = function (a)
{
    var k = 0
    for (var i = 0; i < 8; i++)
    {
        for (var j = 0; k < a.length; k++)
        {
            if (sepChar(a[k])) return k
            if (a[k] == "/") { k++; break }
            if (j > 7) continue
            if (isPawnOrPiece(a[k])) { this.m[i][j++] = a[k]; continue }
            var q = parseInt(a[k])
            if (isNaN(q)) { this.m[i][j++] = "0"; continue }
            for (var l = 0; l < q && j < 8; l++) this.m[i][j++] = "0"
        }
    }
    return k
}

Layout.prototype.asText = function (a_newline)
{
    var s = ""
    for (var i = 0; i < 8; i++)
    {
        if (i > 0) s += a_newline
        for (var j = 0; j < 8; j++)
            s += this.m[i][j]
    }
    return s
}

//------------------------------------------------------------------------------
function Position()
{
    this.m_layout = new Layout()
    this.m_castling = ["K", "Q", "k", "q"]
    this.m_enPassant = new Coords(-1, -1)
    this.m_pawnCaptCount = 0
    this.m_turnCount = 0
}

Position.prototype.fen = function ()
{
    //"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    var l_fen = this.m_layout.fen()
    l_fen += " " + (this.m_turnCount % 2 ? "b" : "w") + " "
    var l_castling = ""
    for (var i = 0; i < this.m_castling.length; i++)
        if (this.m_castling[i] != "") l_castling += this.m_castling[i]
    l_fen += (l_castling != "" ? l_castling : "-")
    l_fen += " " + (this.m_enPassant.isValid() ? this.m_enPassant.notation() : "-")
    l_fen += " " + this.m_pawnCaptCount + " " + (Math.floor(this.m_turnCount / 2) + 1)
    return l_fen
}

Position.prototype.fromFen = function (a)
{
    var q = split_s(a, sepChar)
    if (q.length > 0) this.m_layout.fromFen(q[0])
    var b = 0
    if (q.length > 1 && q[1].length > 0 && q[1][0] == "b")
    {
        b = 1
        if (this.m_turnCount % 2 == 0) this.m_turnCount++
    }
    if (q.length > 2)
    {
        this.m_castling = ["", "", "", ""]
        for (var i = 0; i < q[2].length; i++)
        {
            if (q[2][i] == "K") this.m_castling[0] = "K"
            else if (q[2][i] == "Q") this.m_castling[1] = "Q"
            else if (q[2][i] == "k") this.m_castling[2] = "k"
            else if (q[2][i] == "q") this.m_castling[3] = "q"
        }
    }
    if (q.length > 3) this.m_enPassant.fromNotation(q[3])
    if (q.length > 4)
    {
        var n = Number(q[4])
        this.m_pawnCaptCount = (isNaN(n) || n < 0 ? 0 : Math.round(n))
    }
    if (q.length > 5)
    {
        var n = Number(q[5])
        this.m_turnCount = (isNaN(n) || n < 1 ? 0 : 2 * Math.round(n - 1)) + b
    }
}

Position.prototype.asText = function (a_newline)
{
    var s = this.m_layout.asText(a_newline)
    s += a_newline + "castling: |" + this.m_castling[0] + this.m_castling[1] + this.m_castling[2] + this.m_castling[3] + "|"
    s += a_newline + "enpassant: |" + this.m_enPassant.c + "," + this.m_enPassant.r + "|"
    s += a_newline + "pawn capt count: |" + this.m_pawnCaptCount + "|"
    s += a_newline + "turn count: |" + this.m_turnCount + "|"
    return s
}
