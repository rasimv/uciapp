import QtQml 2.2

QtObject
{
    function start()
    {
        m_timer.singleShot(started, this);
    }

    function position(a_fen)
    {
    }

    function turn()
    {
        m_timer.singleShot(userPly, this);
    }

    signal started(variant a_player);
    signal compPly(variant a_player, string a_notation);
    signal userPly(variant a_player);

    property var m_timer: Qt.createQmlObject("SingleShotTimer {}", this, "User.qml")
}
