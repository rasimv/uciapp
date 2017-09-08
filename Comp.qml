import QtQuick 2.7

QtObject
{
    property var m_this
    property var m_engineControl

    property string m_state: "S_DEFAULT"
    property string m_buf
    property var m_sequence: []

    function start(a)
    {
        m_this = a
        m_engineControl = Qt.createQmlObject("import com.github.rasimv.uciapp 1.0; EngineController {}", m_this)
        m_engineControl.started.connect(onStarted)
        m_engineControl.error.connect(onError)
        m_engineControl.readyRead.connect(onReadyRead)
        m_engineControl.start()
    }

    signal started(var a)

    function turn(a)
    {}

    signal ply(int a_from, int a_to)

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
        if (a[0] == "uciok") l_node.type = "uciok"
        else if (a[0] == "readyok") l_node.type = "readyok"
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
            var q = find(m_sequence, function pred(a) { return a.type == "uciok" })
            if (typeof q != "undefined")
            {
                m_state = "S_WAIT_FOR_READYOK"
                m_sequence = []
                m_engineControl.write("isready\n")
            }
        }
        else if (m_state == "S_WAIT_FOR_READYOK")
        {
            var q = find(m_sequence, function pred(a) { return a.type == "readyok" })
            if (typeof q != "undefined")
            {
                m_state = "S_WAIT_READY"
                m_sequence = []
				started(m_this)
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
