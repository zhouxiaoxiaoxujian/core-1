package cactus.common.tools
{
	import flash.utils.Dictionary;

	/**
	 * 全局的配置数据
	 *
	 * 形如
	 * <property key="test" value="1"/>
	 *
	 * @author Peng
	 */
	public class Hook
	{

		private static var _dictionary:Dictionary = new Dictionary();

		public function Hook()
		{
		}

		public static function getInt(key:String):int
		{
			return int(_dictionary[key]);
		}

		public static function getNumber(key:String):Number
		{
			return Number(_dictionary[key]);
		}

		public static function getString(key:String):String
		{
			return String(_dictionary[key]);
		}

		public static function parse(xml:XML):void
		{
			if (xml)
			{
				var line:XML;
				for each (line in xml..property)
				{
					setValue(String(line.@key), line.@value);
				}
			}
			else
			{
				throw new Error("不存在的文件xml");
			}
		}

		private static function setValue(key:String, value:String):void
		{
			_dictionary[key] = value
		}
	}
}
