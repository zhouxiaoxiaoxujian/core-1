package cactus.common.frame.resource
{
	/**
	 * 资源类型 
	 * @author Pengx
	 * 
	 */
	public class ResourceType
	{
		/**
		 * swf文件
		 */
		public static const SWF:String = "swf";
		
		/**
		 * 文本文件
		 */
		public static const TXT:String = "txt";
		/**
		 * 图片文件
		 */
		public static const IMG:String = "img";
		/**
		 * 二进制文件
		 */
		public static const BIN:String = "bin";
		
		/**
		 * XML
		 * @default
		 */
		public static const XML:String = "xml";
		
		/**
		 * 类型列表
		 */
		public static const TYPE_LIST:Array = [ "swf", "txt", "img", "bin", "xml", "lazy", "" ];;
		
		
		/**
		 * 是否支持此类型资源 
		 * @param type
		 * @return 
		 * 
		 */
		public static function canSupportType(type:String):Boolean
		{
			if(TYPE_LIST.indexOf(type) == -1)
			{
				return false;
			}
			return true;
		}
	}
}