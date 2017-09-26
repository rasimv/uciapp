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

function isOcc(a)
{
    return a != "0"
}

function isOpp(a_one, a_another)
{
    if (!isOcc(a_one) || !isOcc(a_another)) return false
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

Coords.prototype.isNeighbour = function (a)
{
    return Math.abs(a.c - this.c) <= 1 && Math.abs(a.r - this.r) <= 1
}

Coords.prototype.clone = function ()
{
    return new Coords(this.c, this.r)
}

Coords.prototype.add = function (a)
{
    this.c += a.c; this.r += a.r
    return this
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
function notatePair(a_from, a_to)
{
    return a_from.notation() + a_to.notation()
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

Layout.prototype.swap = function (a_one, a_another)
{
    var x = this.m[a_one.r][a_one.c]
    this.m[a_one.r][a_one.c] = this.m[a_another.r][a_another.c]
    this.m[a_another.r][a_another.c] = x
}

Layout.prototype.clear = function ()
{
    for (var i = 0; i < 8; i++)
        for (var j = 0; j < 8; j++)
            this.m[i][j] = "0"
}

Layout.prototype.findFirst = function (a_pawnOrPiece)
{
    for (var i = 0; i < 8; i++)
        for (var j = 0; j < 8; j++)
            if (this.m[i][j] == a_pawnOrPiece) return new Coords(j, i)
    return new Coords(-1, -1)
}

Layout.prototype.direction1 = function (a_from, a_dir)
{
    var q = []
    for (var i = a_from.clone().add(a_dir); i.isValid(); i.add(a_dir))
    {
        if (!isOcc(this.item(i))) { q.push(i.clone()); continue }
        if (isOpp(this.item(i), this.item(a_from))) q.push(i.clone())
        break
    }
    return q
}

Layout.prototype.direction2 = function (a_from, a_dir)
{
    var i = a_from.clone().add(a_dir)
    for (; i.isValid() && !isOcc(this.item(i)); i.add(a_dir));
    return i
}

Layout.prototype.bishopScope = function (a_from)
{
    var q = []
    q = q.concat(this.direction1(a_from, new Coords(1, -1)))
    q = q.concat(this.direction1(a_from, new Coords(-1, -1)))
    q = q.concat(this.direction1(a_from, new Coords(-1, 1)))
    q = q.concat(this.direction1(a_from, new Coords(1, 1)))
    return q
}

Layout.prototype.rookScope = function (a_from)
{
    var q = []
    q = q.concat(this.direction1(a_from, new Coords(1, 0)))
    q = q.concat(this.direction1(a_from, new Coords(0, -1)))
    q = q.concat(this.direction1(a_from, new Coords(-1, 0)))
    q = q.concat(this.direction1(a_from, new Coords(0, 1)))
    return q
}

Layout.prototype.queenScope = function (a_from)
{
    var q = []
    q = q.concat(this.bishopScope(a_from))
    q = q.concat(this.rookScope(a_from))
    return q
}

Layout.prototype.isPossible = function (a_from, a_to)
{
    return !isOcc(this.item(a_to)) || isOpp(this.item(a_to), this.item(a_from))
}

Layout.prototype.specialScope = function (a_from, a_rel)
{
    var q = []
    for (var i = 0; i < a_rel.length; i++)
    {
        var z = a_from.clone().add(new Coords(a_rel[i][0], a_rel[i][1]))
        if (z.isValid() && this.isPossible(a_from, z)) q.push(z)
    }
    return q
}

Layout.prototype.knightScope = function (a_from)
{
    var v = [[2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2], [1, 2], [2, 1]]
    return this.specialScope(a_from, v)
}

Layout.prototype.kingScope = function (a_from)
{
    var v = [[1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1], [0, 1], [1, 1]]
    return this.specialScope(a_from, v)
}

Layout.prototype.pawnScope = function (a_from)
{
    var f = function (a_this, a_dir)
    {
        var q = []
        var u = a_from.clone().add(new Coords(0, a_dir))
        if (u.isValid() && !isOcc(a_this.item(u)))
        {
            q.push(u)
            if (a_dir < 0 && a_from.r == 6 || a_dir > 0 && a_from.r == 1)
            {
                u = a_from.clone().add(new Coords(0, 2 * a_dir))
                if (!isOcc(a_this.item(u))) q.push(u)
            }
        }
        u = a_from.clone().add(new Coords(-1, a_dir))
        if (u.isValid() && (!isOcc(a_this.item(u)) || isOpp(a_this.item(u), a_this.item(a_from)))) q.push(u)
        u = a_from.clone().add(new Coords(1, a_dir))
        if (u.isValid() && (!isOcc(a_this.item(u)) || isOpp(a_this.item(u), a_this.item(a_from)))) q.push(u)
        return q
    }
    return this.item(a_from) == "P" ? f(this, -1) : f(this, 1)
}

Layout.prototype.pawnOrPieceScope = function (a_from)
{
    var x = this.item(a_from)
    if (x == "P" || x == "p") return this.pawnScope(a_from)
    if (x == "R" || x == "r") return this.rookScope(a_from)
    if (x == "N" || x == "n") return this.knightScope(a_from)
    if (x == "B" || x == "b") return this.bishopScope(a_from)
    if (x == "Q" || x == "q") return this.queenScope(a_from)
    if (x == "K" || x == "k") return this.kingScope(a_from)
    return []
}

Layout.prototype.attackDiagonal = function (a_place)
{
    var q = []
    var v = [[1, -1], [-1, -1], [-1, 1], [1, 1]]
    for (var i = 0; i < v.length; i++)
    {
        var u = this.direction2(a_place, new Coords(v[i][0], v[i][1]))
        if (!u.isValid()) continue
        var x = this.item(u)
        if ((x == "B" || x == "b" || x == "Q" || x == "q") ||
            a_place.isNeighbour(u) && (x == "K" || x == "k")) q.push(u)
    }
    return q
}

Layout.prototype.attackHorVert = function (a_place)
{
    var q = []
    var v = [[1, 0], [0, -1], [-1, 0], [0, 1]]
    for (var i = 0; i < v.length; i++)
    {
        var u = this.direction2(a_place, new Coords(v[i][0], v[i][1]))
        if (!u.isValid()) continue
        var x = this.item(u)
        if ((x == "R" || x == "r" || x == "Q" || x == "q") ||
            a_place.isNeighbour(u) && (x == "K" || x == "k")) q.push(u)
    }
    return q
}

Layout.prototype.attackKnight = function (a_place)
{
    var q = []
    var v = [[2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2], [1, 2], [2, 1]]
    for (var i = 0; i < v.length; i++)
    {
        var u = a_place.clone().add(new Coords(v[i][0], v[i][1]))
        if (!u.isValid()) continue
        var x = this.item(u)
        if (x == "N" || x == "n") q.push(u)
    }
    return q
}

Layout.prototype.attackPawn = function (a_place)
{
    var q = []
    var v = [[1, -1], [-1, -1], [-1, 1], [1, 1]]
    for (var i = 0; i < v.length; i++)
    {
        var u = a_place.clone().add(new Coords(v[i][0], v[i][1]))
        if (!u.isValid()) continue
        var x = this.item(u)
        if (x == "P" && u.r > a_place.r || x == "p" && u.r < a_place.r) q.push(u)
    }
    return q
}

Layout.prototype.isAttacked = function (a_king, a_place)
{
    var q = []
    q = q.concat(this.attackDiagonal(a_place))
    q = q.concat(this.attackHorVert(a_place))
    q = q.concat(this.attackKnight(a_place))
    q = q.concat(this.attackPawn(a_place))
    for (var i = 0; i < q.length; i++) if (isOpp(a_king, this.item(q[i]))) return true
    return false
}

Layout.prototype.isCheck = function (a_king)
{
    var l_place = this.findFirst(a_king)
    return this.isAttacked(a_king, l_place)
}

Layout.prototype.isCheckTurn = function (a_king, a_from, a_to)
{
    var l_save = this.item(a_to)
    this.setItem(a_to, this.item(a_from))
    this.setItem(a_from, "0")
    var q = this.isCheck(a_king)
    this.setItem(a_from, this.item(a_to))
    this.setItem(a_to, l_save)
    return q
}

Layout.prototype.regularTurns = function (a_king, a_from)
{
    var q = []
    var l_scope = this.pawnOrPieceScope(a_from)
    for (var i = 0; i < l_scope.length; i++)
    {
        var l_to = l_scope[i]
        if ((this.item(a_from) == "P" || this.item(a_from) == "p") &&
            l_to.c != a_from.c && !isOcc(this.item(l_to))) continue
        if (this.isCheckTurn(a_king, a_from, l_to)) continue
        q.push(l_to)
    }
    return q
}

Layout.prototype.notationsAndPromotions = function (a_king, a_from)
{
    var q = []
    var v = this.regularTurns(a_king, a_from)
    for (var k = 0; k < v.length; k++)
    {
        var s = notatePair(a_from, v[k])
        if (this.item(a_from) == "P" && v[k].r == 0 || this.item(a_from) == "p" && v[k].r == 7)
            for (var l = 0; l < 4; l++) q.push(s + s_pawnsAndPieces[l])
        else
            q.push(s)
    }
    return q
}

Layout.prototype.enPassant = function (a_king, a_enPas)
{
    var q = []
    var l_long = new Coords(a_enPas.c, a_enPas.r + (a_king == "K" ? 1 : -1))
    var l_lr = [new Coords(l_long.c - 1, l_long.r), new Coords(l_long.c + 1, l_long.r)]
    for (var i = 0; i < l_lr.length; i++)
    {
        if (!l_lr[i].isValid()) continue
        var x = this.item(l_lr[i])
        if (x != "P" && x != "p" || isOpp(x, a_king)) continue
        this.swap(a_enPas, l_long)
        if (!this.isCheckTurn(a_king, l_lr[i], a_enPas)) q.push(notatePair(l_lr[i], a_enPas))
        this.swap(a_enPas, l_long)
    }
    return q
}

Layout.prototype.castling = function (a_king, a_castling)
{
    var q = []
    var i = new Coords(4, a_king == "K" ? 7 : 0)
    if (this.isAttacked(a_king, i)) return []
    var l_startIndex = (a_king == "K" ? 0 : 2)
    if (a_castling[l_startIndex] != "")
    {
        for (i.c = 5; i.c < 7 && !isOcc(this.item(i)) && !this.isAttacked(a_king, i); i.c++);
        if (i.c >= 7) q.push("0-0")
    }
    if (a_castling[l_startIndex + 1] != "")
    {
        for (i.c = 3; i.c > 0 && !isOcc(this.item(i)) && (i.c < 2 || !this.isAttacked(a_king, i)); i.c--);
        if (i.c <= 0) q.push("0-0-0")
    }
    return q
}

Layout.prototype.legalTurns = function (a_king, a_enPas, a_castling)
{
    var q = []
    for (var i = 0; i < 8; i++)
        for (var j = 0; j < 8; j++)
        {
            var y = new Coords(j, i)
            if (!isOcc(this.item(y)) || isOpp(a_king, this.item(y))) continue
            q = q.concat(this.notationsAndPromotions(a_king, y))
        }
    q = q.concat(this.enPassant(a_king, a_enPas))
    q = q.concat(this.castling(a_king, a_castling))
    return q
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
            if (!isOcc(this.m[i][j])) { l_empyCount++; continue }
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
    for (var i = 0; i < 8; i++) {
        for (var j = 0; k < a.length; k++)
        {
            if (sepChar(a[k])) return k
            if (a[k] == "/") { k++; break }
            if (j > 7) continue
            if (s_pawnsAndPieces.indexOf(a[k]) >= 0) { this.m[i][j++] = a[k]; continue }
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
    this.m_enPassant = new Coords(-1, -1)
    this.m_castling = ["K", "Q", "k", "q"]
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
