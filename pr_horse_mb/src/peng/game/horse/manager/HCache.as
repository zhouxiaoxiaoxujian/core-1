package peng.game.horse.manager
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	import cactus.common.frame.resource.ResourceFacade;

	/**
	 * 全局缓存
	 * @author supperhpxd
	 */
	public class HCache
	{
		private static var instance:HCache = new HCache();

		protected var bitmapDataDict:Dictionary = new Dictionary;

		public function HCache()
		{
		}

		public static function getIns():HCache
		{
			return instance;
		}

		/**
		 *
		 */
		public function init():void
		{
			addBitmapData("bg", ResourceFacade.getBD("bg"));
			addBitmapData("bg1_0", ResourceFacade.getBD("bg1_0"));
			addBitmapData("bg1_1", ResourceFacade.getBD("bg1_1"));
			addBitmapData("bg1_2", ResourceFacade.getBD("bg1_2"));
			addBitmapData("bg1_3", ResourceFacade.getBD("bg1_3"));
			addBitmapData("bg2", ResourceFacade.getBD("bg2"));
			addBitmapData("bg3", ResourceFacade.getBD("bg3"));
			addBitmapData("bg4", ResourceFacade.getBD("bg4"));
			addBitmapData("bg5", ResourceFacade.getBD("bg5"));
			addBitmapData("bg6", ResourceFacade.getBD("bg6"));
			addBitmapData("bg7", ResourceFacade.getBD("bg7"));
			addBitmapData("bg8", ResourceFacade.getBD("bg8"));
			addBitmapData("bg9", ResourceFacade.getBD("bg9"));
			addBitmapData("bg10", ResourceFacade.getBD("bg10"));
		}

		/**
		 * 只有当游戏关闭才会清空缓存
		 */
		public function destory():void
		{
			bitmapDataDict = new Dictionary;
		}

		public function addBitmapData(name:String, obj:BitmapData):void
		{
			bitmapDataDict[name] = obj;
		}

		public function getBitmapData(name:String):BitmapData
		{
			if (bitmapDataDict[name] == undefined || bitmapDataDict[name] == null)
			{
				throw new Error("不存在的cache", name);
			}
			return bitmapDataDict[name];
		}
	}
}
