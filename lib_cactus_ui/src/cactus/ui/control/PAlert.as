package cactus.ui.control
{
	import cactus.common.manager.PopupManager;
	import cactus.common.tools.Local;
	
	import flash.events.EventDispatcher;

	public class PAlert extends EventDispatcher
	{
		public function PAlert()
		{
		}

		public static function show(title:String = "", buttonFlag:int = 2, callbackFunctions:Array = null, buttonLabels:Array = null):void
		{
			if (!buttonLabels)
			{
				buttonLabels = [Local.getString("btn_ok"), Local.getString("btn_cancel")];
			} 
			PopupManager.getInstance().showPanel(PCommonAlert_POP, null, [title, buttonFlag, callbackFunctions, buttonLabels]);
		}
	}
}
