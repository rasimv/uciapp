.pragma library

//------------------------------------------------------------------------------
var CD_S_DEFAULT = 0;
var CD_S_WAIT_FOR_ICUOK = 1;
var CD_S_WAIT_FOR_READY = 2;
var CD_S_WAIT_FOR_NEWGAME = 3;
var CD_S_NEWGAME = 4;

var CD_MT_UCIOK = 0;
var CD_MT_READYOK = 1;
var CD_MT_BESTMOVE = 2;

//------------------------------------------------------------------------------
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

CompData.prototype.onStarted = function (a_this) {}

CompData.prototype.onError = function (a_this) {}

CompData.prototype.onReadyRead = function (a_this)
{
    a_this.m_buf += a_this.m_engineControl.read();
    a_this.parse();
    while (a_this.process());
}

CompData.prototype.delim = function (a) { return a == ' ' || a == '\t' || a == '\r'; }

CompData.prototype.split = function (a)
{
    var q = [];
    for (var i = 0, j = 0; ; i = j)
    {
        for (; i < a.length && this.delim(a[i]); i++);
        j = i;
        for (; j < a.length && !this.delim(a[j]); j++);
        if (i < j) q.push(a.slice(i, j));
        else return q;
    }
}

CompData.prototype.line = function ()
{
    var i = 0;
    for (; i < this.m_buf.length && this.m_buf[i] != '\n'; i++);
    if (i >= this.m_buf.length) return "";
    var s = this.m_buf.slice(0, i);
    this.m_buf = this.m_buf.slice(i + 1);
    return s;
}

CompData.prototype.parseSub = function (a)
{
    if (a.length <= 0) return;
    var l_mesg = {};
    if (a[0] == "uciok") l_mesg.type = CD_MT_UCIOK;
    else if (a[0] == "readyok") l_mesg.type = CD_MT_READYOK;
    else if (a[0] == "bestmove")
    {
        l_mesg.type = CD_MT_BESTMOVE;
        l_mesg.ply = a.length < 2 ? "" : a[1];
    }
    else return;
    this.m_messages.push(l_mesg);
}

CompData.prototype.parse = function ()
{
    for (var s = this.line(); s; s = this.line()) this.parseSub(this.split(s));
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
        this.m_engineControl.write("uci\n");
    }
    else if (this.m_state == CD_S_WAIT_FOR_ICUOK)
    {
        if (this.findMessage(CD_MT_UCIOK) >= 0)
        {
            this.m_state = CD_S_WAIT_FOR_READY;
            this.m_messages = [];
            this.m_engineControl.write("isready\n");
        }
    }
    else if (this.m_state == CD_S_WAIT_FOR_READY)
    {
        if (this.findMessage(CD_MT_READYOK) >= 0)
        {
            this.m_state = CD_S_WAIT_FOR_NEWGAME;
            this.m_messages = [];
            this.m_engineControl.write("ucinewgame\n");
            this.m_engineControl.write("isready\n");
        }
    }
    else if (this.m_state == CD_S_WAIT_FOR_NEWGAME)
    {
        if (this.findMessage(CD_MT_READYOK) >= 0)
        {
            this.m_state = CD_S_NEWGAME;
            this.m_messages = [];
            console.log("new game");
        }
    }
    return false;
}
