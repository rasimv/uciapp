.pragma library

function sepChar(a) { return a == " " || a == "\t" }

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

//------------------------------------------------------------------------------
function isPawnOrPiece(a)
{
    var l_all = "rnbqkpPRNBQK"
    for (var i = 0; i < l_all.length; i++)
        if (a == l_all[i]) return true
    return false
}

function isOpp(a_one, a_another)
{
    if (!isPawnOrPiece(a_one) || !isPawnOrPiece(a_another)) return false
    return (a_one == a_one.toLowerCase()) != (a_another == a_another.toLowerCase())
}

//------------------------------------------------------------------------------
function Map()
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

Map.prototype.field = function (a)
{
    return this.m[a.r][a.c]
}

Map.prototype.setField = function (a_where, a_value)
{
    this.m[where.r][where.c] = a_value
}

Map.prototype.clear = function ()
{
    for (var i = 0; i < 8; i++)
        for (var j = 0; j < 8; j++)
            this.m[i][j] = "0"
}

Map.prototype.findFirst = function (a_pawnOrPiece)
{
    for (var i = 0; i < 8; i++)
        for (var j = 0; j < 8; j++)
            if (this.m[i][j] == a_pawnOrPiece) return new Coords(j, i)
    return new Coords(-1, -1)
}

Map.prototype.direction = function (a_from, a_hInc, a_vInc)
{
    for (var i = new Coords(a_from.c + a_hInc, a_from.r + a_vInc); i.isValid(); i.c += a_hInc, i.r += a_vInc)
        if (isPawnOrPiece(this.m[i.r][i.c])) return i
    return new Coords(-1, -1)
}

Map.prototype.isBeating = function (a_attacker, a_field)
{
    var l_attacker = this.m[a_attacker.r][a_attacker.c]
    if (l_attacker == "P")
    {
        var q = new Coords(a_attacker.c - 1, a_attacker.r - 1)
        if (q.isValid() && q.isEqual(a_field)) return true
        q = new Coords(a_attacker.c + 1, a_attacker.r - 1)
        if (q.isValid() && q.isEqual(a_field)) return true
    }
    if (l_attacker == "p")
    {
        var q = new Coords(a_attacker.c - 1, a_attacker.r + 1)
        if (q.isValid() && q.isEqual(a_field)) return true
        q = new Coords(a_attacker.c + 1, a_attacker.r + 1)
        if (q.isValid() && q.isEqual(a_field)) return true
    }
    return false
}

Map.prototype.fromFen = function (a)
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

Map.prototype.asText = function (a_newline)
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
