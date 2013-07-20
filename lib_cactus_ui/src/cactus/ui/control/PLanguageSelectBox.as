package cactus.ui.control
{
	import cactus.common.control.LanguageSelectBox;
	import cactus.ui.bind.PAutoView;

	/**
	 * 语言选择框
	 * @author Peng
	 */
	public class PLanguageSelectBox extends PAutoView
	{

		private var _box:LanguageSelectBox;
		private var _dir:String;


		public function PLanguageSelectBox($sourceName:String = null)
		{
			super($sourceName);
		}

		public function get dir():String
		{
			return _dir;
		}

		public function set dir(value:String):void
		{
			_dir = value;
			_box.dir = value;
		}

		override public function init():void
		{
			if (!_box)
			{
				_box = new LanguageSelectBox;
				addChild(_box);
			}
		}

		override public function destory():void
		{
			if (_box)
			{
				_box.destory();
			}
		}
	}
}
