package peng.game.horse.view.control
{
	import flash.display.MovieClip;

	import cactus.ui.bind.PAutoView;

	/**
	 * 技能栏
	 * @author Peng
	 */
	public class PropHolder extends PAutoView
	{

		/**
		 * 主容器
		 * @default 
		 */
		public var mmc_holder_PB:MovieClip;

		/**
		 * icon链接名
		 * @default
		 */
		private var _propIconName:String;

		public function PropHolder($sourceName:String = null)
		{
			super($sourceName);
		}

		public function get propIconName():String
		{
			return _propIconName;
		}

		public function set propIconName(value:String):void
		{
			_propIconName = value;
		}

	}
}
