package cactus.ui.bind
{

	/**
	 * Metadata Object
	 * @author Peng
	 */
	public class MTObj
	{
		/**
		 * 属性名
		 * @default
		 */
		public var propertyName:String = "";
		/**
		 * 对齐
		 * @default
		 */
		public var align:String = "";
		/**
		 * 按照比例调整位置，优先级低于align的设置
		 * @default
		 */
		public var ref:String = "";
		/**
		 * 是否自动变形
		 * @default
		 */
		public var scale:Boolean = false;

		public function MTObj()
		{
		}
	}
}