.pragma library

//------------------------------------------------------------------------------
function CompData(a_comp)
{
    this.m_comp = a_comp;
    this.m_engineControl = Qt.createQmlObject("import com.github.rasimv.uciapp 1.0; EngineController {}", this.m_comp);
}

CompData.prototype.start = function ()
{
    this.m_engineControl.started.connect(this.onStarted);
    this.m_engineControl.error.connect(this.onError);
    this.m_engineControl.readyRead.connect(this.onReadyRead);
    this.m_engineControl.start();
}

CompData.prototype.onStarted = function ()
{
}

CompData.prototype.onError = function ()
{
}

CompData.prototype.onReadyRead = function ()
{
}
