/*

function SlotPlantFlag()
{
	PvPMinigame.PlantCTFFlags();
}

*/

import com.GameInterface.Tooltip.TooltipData;
import com.GameInterface.Tooltip.TooltipInterface;
import com.GameInterface.Tooltip.TooltipManager;
import com.GameInterface.DistributedValue;
import com.Utils.Archive;
import com.GameInterface.PvPMinigame.PvPMinigame;

//Crap for Viper's Bar

var m_Icon:MovieClip;
var m_VTIOIsLoadedMonitor:DistributedValue;

var m_CompassCheckTimerID:Number;
var m_CompassCheckTimerLimit:Number = 256;
var m_CompassCheckTimerCount:Number = 0;

var VTIOAddonInfo:String = "Plant Relic|Belladawna|1.0||_root.plantrelic\\plantrelic.m_Icon";

function onLoad():Void
{
	
	///////////////////////////////////////////
	////Crap for Viper's Bar
	///////////////////////////////////////////
	
	// Setting up the VTIO loaded monitor.
	m_VTIOIsLoadedMonitor = DistributedValue.Create("VTIO_IsLoaded");
	m_VTIOIsLoadedMonitor.SignalChanged.Connect(SlotCheckVTIOIsLoaded, this);
		
	// Setting up your icon.
	m_Icon = attachMovie("Icon", "m_Icon", getNextHighestDepth());
	m_Icon._width = 18;
	m_Icon._height = 18;
	m_Icon.onMousePress = function(buttonID) {
		if (buttonID == 1) {
			PvPMinigame.PlantCTFFlags();
			//Plant relic
		} else if (buttonID == 2) {
			com.GameInterface.Chat.SignalShowFIFOMessage.Emit("Right click doesn't do anything.", 0);
			// Do right mouse button stuff.
		}
	}

	m_Icon.onRollOver = function() {
		if (m_Tooltip != undefined) m_Tooltip.Close();
        var tooltipData:TooltipData = new TooltipData();
		tooltipData.AddAttribute("", "<font face='_StandardFont' size='13' color='#FF8000'><b>PlantRelic by Belladawna</b></font>");
        tooltipData.AddAttributeSplitter();
        tooltipData.AddAttribute("", "");
        tooltipData.AddAttribute("", "<font face='_StandardFont' size='12' color='#FFFFFF'>Left click to plan the relic.  Right click to do nothing.</font>");
        tooltipData.m_Padding = 4;
        tooltipData.m_MaxWidth = 210;
		m_Tooltip = TooltipManager.GetInstance().ShowTooltip(undefined, TooltipInterface.e_OrientationVertical, 0, tooltipData);
	}
	m_Icon.onRollOut = function() {
		if (m_Tooltip != undefined)	m_Tooltip.Close();
	}

	// Start the compass check.
	m_CompassCheckTimerID = setInterval(PositionIcon, 100);
	PositionIcon();

	// Check if VTIO is loaded (if it loaded before this add-on was).
	SlotCheckVTIOIsLoaded();
	
	
	//////////////////////////////////////////////////
	//////End Crap for Viper's Bar
	//////////////////////////////////////////////////
	
}

///////////////////////////
//Functions for Viper's Bar
///////////////////////////


// The compass check function.
function PositionIcon() {
	m_CompassCheckTimerCount++;
	if (m_CompassCheckTimerCount > m_CompassCheckTimerLimit) clearInterval(m_CompassCheckTimerID);
	if (_root.compass._x > 0) {
		clearInterval(m_CompassCheckTimerID);
		m_Icon._x = _root.compass._x - 128;
		m_Icon._y = _root.compass._y + 0;
	}
}

// The function that checks if VTIO is actually loaded and if it is sends the add-on information defined earlier.
// This function will also get called if VTIO loads after your add-on. Make sure not to remove the check for seeing if the value is actually true.
function SlotCheckVTIOIsLoaded() {
	if (DistributedValue.GetDValue("VTIO_IsLoaded")) DistributedValue.SetDValue("VTIO_RegisterAddon", VTIOAddonInfo);
}