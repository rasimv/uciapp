import QtQml 2.2
import "comp.js" as CompJS

QtObject
{
    function start()
    {
        m_data.start();
    }

    function turn(a_fen)
    {
    }

    signal started(variant a_player);
    signal compPly(variant a_player, string a_notation);
    signal userPly(variant a_player);

    property var m_data: new CompJS.CompData(this)
}
