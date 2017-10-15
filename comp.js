.pragma library

//------------------------------------------------------------------------------
function delim(a) { return a == ' ' || a == '\t' || a == '\r'; }

function split(a)
{
    var q = [];
    for (var i = 0, j = 0; ; i = j)
    {
        for (; i < a.length && delim(a[i]); i++);
        j = i;
        for (; j < a.length && !delim(a[j]); j++);
        if (i < j) q.push(a.slice(i, j));
        else return q;
    }
}

//------------------------------------------------------------------------------
var CD_MT_EMPTY = 0;
var CD_MT_UCIOK = 1;
var CD_MT_READYOK = 2;
var CD_MT_BESTMOVE = 3;
var CD_MT_UCI = 4;
var CD_MT_ISREADY = 5;
var CD_MT_UCINEWGAME = 6;
var CD_MT_POSITION = 7;
var CD_MT_GO = 8;

function Message(a_type, a_arg)
{
    this.type = a_type;
    if (a_type == CD_MT_BESTMOVE) this.best = a_arg;
    else if (a_type == CD_MT_POSITION) this.fen = a_arg;
    else if (a_type == CD_MT_GO) this.time = a_arg;
}

Message.prototype.toString = function ()
{
    var s = "";
    if (this.type == CD_MT_UCI) s = "uci";
    else if (this.type == CD_MT_ISREADY) s = "isready";
    else if (this.type == CD_MT_UCINEWGAME) s = "ucinewgame";
    else if (this.type == CD_MT_POSITION) s = "position fen " + this.fen;
    else if (this.type == CD_MT_GO) s = "go movetime " + this.time;
    return s;
}

function messageFromString(a)
{
    var q = this.split(a);
    if (q.length < 1) return new Message(CD_MT_EMPTY);
    if (q[0] == "uciok") return new Message(CD_MT_UCIOK);
    else if (q[0] == "readyok") return new Message(CD_MT_READYOK);
    else if (q[0] == "bestmove") return new Message(CD_MT_BESTMOVE, q[1]);
    return new Message(CD_MT_EMPTY);
}

//------------------------------------------------------------------------------
var CD_S_DEFAULT = 0;
var CD_S_WAIT_FOR_ICUOK = 1;
var CD_S_WAIT_FOR_READY = 2;
var CD_S_WAIT_FOR_NEWGAME = 3;
var CD_S_NEWGAME = 4;

function CompData(a_comp)
{
    this.m_comp = a_comp;
    this.m_state = CD_S_DEFAULT;
    this.m_buf = "";
    this.m_messages = [];
    this.m_engineControl = Qt.createQmlObject("import com.github.rasimv.uciapp 1.0; EngineController {}", this.m_comp);
}

CompData.prototype.start = function ()
{
    this.m_engineControl.started.connect(this.onStarted);
    this.m_engineControl.error.connect(this.onError);
    this.m_engineControl.readyRead.connect(this.onReadyRead);
    this.m_engineControl.start(this);
}

CompData.prototype.stop = function ()
{
    this.m_engineControl.readyRead.disconnect(this.onReadyRead);
}

CompData.prototype.position = function (a_fen)
{
    this.sendMessage(new Message(CD_MT_POSITION, a_fen));
}

CompData.prototype.turn = function ()
{
    this.sendMessage(new Message(CD_MT_GO, 2000));
}

CompData.prototype.onStarted = function (a_this) {}

CompData.prototype.onError = function (a_this) {}

CompData.prototype.onReadyRead = function (a_this)
{
    a_this.m_buf += a_this.m_engineControl.read();
    a_this.parse();
    while (a_this.process());
}

CompData.prototype.line = function ()
{
    var i = 0;
    for (; i < this.m_buf.length && this.m_buf[i] != '\n'; i++);
    if (i >= this.m_buf.length) return null;
    var s = this.m_buf.slice(0, i);
    this.m_buf = this.m_buf.slice(i + 1);
    return s;
}

CompData.prototype.parse = function ()
{
    for (var s = this.line(); s != null; s = this.line())
        this.m_messages.push(messageFromString(s));
}

CompData.prototype.findMessage = function (a_type)
{
    for (var i = 0; i < this.m_messages.length; i++)
        if (a_type == this.m_messages[i].type) return i;
    return -1;
}

CompData.prototype.process = function ()
{
    if (this.m_state == CD_S_DEFAULT)
    {
        this.m_state = CD_S_WAIT_FOR_ICUOK;
        this.m_messages = [];
        this.sendMessage(new Message(CD_MT_UCI));
    }
    else if (this.m_state == CD_S_WAIT_FOR_ICUOK)
    {
        if (this.findMessage(CD_MT_UCIOK) >= 0)
        {
            this.m_state = CD_S_WAIT_FOR_READY;
            this.m_messages = [];
            this.sendMessage(new Message(CD_MT_ISREADY));
        }
    }
    else if (this.m_state == CD_S_WAIT_FOR_READY)
    {
        if (this.findMessage(CD_MT_READYOK) >= 0)
        {
            this.m_state = CD_S_WAIT_FOR_NEWGAME;
            this.m_messages = [];
            this.sendMessage(new Message(CD_MT_UCINEWGAME));
            this.sendMessage(new Message(CD_MT_ISREADY));
        }
    }
    else if (this.m_state == CD_S_WAIT_FOR_NEWGAME)
    {
        if (this.findMessage(CD_MT_READYOK) >= 0)
        {
            this.m_state = CD_S_NEWGAME;
            this.m_messages = [];
            this.m_comp.queueStarted();
        }
    }
    else if (this.m_state == CD_S_NEWGAME)
    {
        var g = this.findMessage(CD_MT_BESTMOVE);
        if (g >= 0)
        {
            var w = this.m_messages[g];
            this.m_messages = [];
            this.m_comp.queueCompPly(w.best);
        }
    }
    return false;
}

CompData.prototype.sendMessage = function (a)
{
    this.m_engineControl.write(a + "\n");
}
