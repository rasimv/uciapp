import QtQuick 2.7

QtObject
{
    property var m_this
    property var m_engineControl

    property int m_state: 0
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

    signal started()

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
            if (i < j) l_list.push(a.slice(i, j)); else return l_list
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
        if (a[0] == "uciok") l_node.type = "uciok";
        else if (a[0] == "readyok") l_node.type = "readyok"
        m_sequence.push(l_node)
    }

    function parse()
    {
        for (var s = line(); s; s = line()) parseSub(split(s))
        console.log(m_sequence[0].type)
    }

    function process()
    {}

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
