import QtQml 2.2
import "comp.js" as CompJS

QtObject
{
    function start() { m_data.start(); }
    function position(a_fen) { m_data.position(a_fen); }
    function turn() { m_data.turn(); }

    signal started(variant a_player);
    signal compPly(variant a_player, string a_notation);
    signal userPly(variant a_player);

    property var m_data: new CompJS.CompData(this)
    property var m_timer: Qt.createQmlObject("SingleShotTimer {}", this, "Comp.qml")

    function queueStarted() { m_timer.singleShot(started, this); }
    function queueCompPly(a_notation) { m_timer.singleShot(compPly, this, a_notation); }
}
