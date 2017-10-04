import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

Item
{
	property string filepath

	function setCenter(a_pos)
	{
		x = a_pos.x - width / 2; y = a_pos.y - height / 2;
	}

	Image
	{
		anchors.fill: parent
		sourceSize.width: 256
		sourceSize.height: 256
		source: filepath
	}
}
