import QtQuick 2.7

QtObject
{
    property var m_this
    property var m_logic
    property var m_engineControl

    property string m_state: "S_DEFAULT"
    property string m_buf
    property var m_sequence: []

    property string m_last

    function start(a_this, a_logic)
    {
        m_this = a_this; m_logic = a_logic
        m_engineControl = Qt.createQmlObject("import com.github.rasimv.uciapp 1.0; EngineController {}", m_this)
        m_engineControl.started.connect(onStarted)
        m_engineControl.error.connect(onError)
        m_engineControl.readyRead.connect(onReadyRead)
        m_engineControl.start()
    }

    function startNewGame()
    {
        if (m_state != "S_READY") return false
        m_state = "S_WAIT_FOR_NEWGAME"
        m_engineControl.write("ucinewgame\n")
        m_engineControl.write("isready\n")
		return true
    }

    signal started(var a)
    signal newGameStarted(var a)

    function turn()
    {
        if (m_state != "S_NEWGAME") return false
        m_engineControl.write("position fen " + m_logic.fen() + "\n")
        m_engineControl.write("go movetime 2000\n")
    }

    signal ply(var a)

    function last() { return m_last }

    function delim(a) { return a == ' ' || a == '\t' || a == '\r' }
    function split(a)
    {
        var l_list = []
        for (var i = 0, j = 0; ; i = j)
        {
            for (; i < a.length && delim(a[i]); i++);
            j = i
            for (; j < a.length && !delim(a[j]); j++);
            if (i < j) l_list.push(a.slice(i, j))
            else return l_list
        }
    }

    function line()
    {
        var i = 0
        for (; i < m_buf.length && m_buf[i] != '\n'; i++);
        if (i >= m_buf.length) return ""
        var s = m_buf.slice(0, i)
        m_buf = m_buf.slice(i + 1)
        return s
    }

    function parseSub(a)
    {
        if (a.length <= 0) return
        var l_node = {}
        if (a[0] == "uciok") l_node.m_type = "uciok"
        else if (a[0] == "readyok") l_node.m_type = "readyok"
        else if (a[0] == "bestmove")
        {
            l_node.m_type = "bestmove"
            l_node.m_ply = a.length < 2 ? "" : a[1]
        }
        else return
        m_sequence.push(l_node)
    }

    function parse()
    {
        for (var s = line(); s; s = line()) parseSub(split(s))
    }

    function find(a_array, a_pred)
    {
        for (var i = 0; i < a_array.length; i++)
            if (a_pred(a_array[i])) return i
	}

    function process()
    {
        if (m_state == "S_DEFAULT")
        {
            m_state = "S_WAIT_FOR_ICUOK"
            m_sequence = []
            m_engineControl.write("uci\n")
        }
        else if (m_state == "S_WAIT_FOR_ICUOK")
        {
            var q = find(m_sequence, function pred(a) { return a.m_type == "uciok" })
            if (typeof q != "undefined")
            {
                m_state = "S_WAIT_FOR_READYOK"
                m_sequence = []
                m_engineControl.write("isready\n")
            }
        }
        else if (m_state == "S_WAIT_FOR_READYOK")
        {
            var q = find(m_sequence, function pred(a) { return a.m_type == "readyok" })
            if (typeof q != "undefined")
            {
                m_state = "S_READY"
                m_sequence = []
                started(m_this)
            }
        }
        else if (m_state == "S_WAIT_FOR_NEWGAME")
        {
            var q = find(m_sequence, function pred(a) { return a.m_type == "readyok" })
            if (typeof q != "undefined")
            {
                m_state = "S_NEWGAME"
                m_sequence = []
                newGameStarted(m_this)
            }
        }
        else if (m_state == "S_NEWGAME")
        {
            var q = find(m_sequence, function pred(a) { return a.m_type == "bestmove" })
            if (typeof q != "undefined")
            {
                m_last = m_sequence[q].m_ply
                m_sequence = []
                ply(m_this)
            }
        }
    }

    function onStarted()
    {
        console.log("onStarted")
    }

    function onError()
    {
        console.log("onError")
    }

    function onReadyRead()
    {
        m_buf += m_engineControl.read()
        parse()
        process()
    }
}
