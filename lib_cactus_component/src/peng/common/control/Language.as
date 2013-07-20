package peng.common.control
{

	/**
	 * 语言
	 * @author Peng
	 */
	public class Language
	{
		/**
		 * 语言名 和 AS3 Capabilities 匹配
		 * @default
		 */
		private var _name:String;
		/**
		 * 该语言需要特定使用的字体
		 * @default
		 */
		private var _fontName:String;
		/**
		 * 该语言是否使用资源内嵌的字体
		 * @default
		 */
		private var _userEmbed:Boolean;
		/**
		 * 素材对应的帧数
		 * @default
		 */
		private var _resFrame:Object;

		public function Language()
		{
		}


		public function get resFrame():Object
		{
			return _resFrame;
		}

		/**
		 * @private
		 */
		public function set resFrame(value:Object):void
		{
			_resFrame = value;
		}

		public function get userEmbed():Boolean
		{
			return _userEmbed;
		}

		public function set userEmbed(value:Boolean):void
		{
			_userEmbed = value;
		}

		public function get fontName():String
		{
			return _fontName;
		}

		public function set fontName(value:String):void
		{
			_fontName = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

	}
}
