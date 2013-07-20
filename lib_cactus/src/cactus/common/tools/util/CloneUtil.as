package cactus.common.tools.util
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * 克隆工具 
	 * @author Peng
	 */
	public class CloneUtil
	{
		public function CloneUtil()
		{
		}

		public static function cloneObject(source:Object):Object
		{
			var byte:ByteArray = new ByteArray;
			byte.writeObject(source);
			byte.position = 0;
			
			return byte.readObject() as Object;
		}
		
		public static function cloneArray(source:Array):Array
		{
			return cloneObject(source) as Array;
		}

		public static function cloneDictionary(source:Dictionary):Dictionary
		{
			return cloneObject(source) as Dictionary;
		}
	}
}
