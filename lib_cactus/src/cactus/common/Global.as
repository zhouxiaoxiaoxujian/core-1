package cactus.common
{
	import cactus.common.tools.util.Debugger;

	import flash.display.Stage;
	import flash.system.Capabilities;

	public class Global
	{
		/**
		 * 数据中心的URL
		 * @default
		 */
		public static var dataCenterURL : String;

		public static var stage : Stage;

		public static var gameWorld : *;

		// =========================================
		// ============  加载模式		============
		// =========================================

		/**
		 * 程序运行模式
		 * @default
		 */
		public static var mode : int = -1;
		/**
		 * 普通单文件模式
		 * @default
		 */
		public static const MODE_SINGLE : int = 1;
		/**
		 * 普通多文件模式
		 * @default
		 */
		public static const MODE_MULTI : int = 2;

		// =========================================
		// ============  运行平台		============
		// =========================================

		/**
		 * 运行平台
		 * @default
		 */
		public static var platform : int = 0;

		/**
		 * PC平台
		 * @default
		 */
		public static const PLATFORM_PC : int = 1;
		public static const PLATFORM_ANDROID : int = 2;
		public static const PLATFORM_IOS : int = 3;

		/**
		 * 是否为PC
		 * @return
		 */
		public static function isPC() : Boolean
		{
			return platform == PLATFORM_PC;
		}

		/**
		 * 是否为移动设备
		 * @return
		 */
		public static function isMobile() : Boolean
		{
			return (platform == PLATFORM_IOS) || (platform == PLATFORM_ANDROID);
		}

		/**
		 * 是否为安卓
		 * @return
		 */
		public static function isAndroid() : Boolean
		{
			return platform == PLATFORM_ANDROID;
		}

		/**
		 * 是否为IOS
		 * @return
		 */
		public static function isIOS() : Boolean
		{
			return platform == PLATFORM_IOS;
		}

		// =========================================
		// ============  平台相关		============
		// =========================================

		public static var originalScreenW : Number;

		public static var originalScreenH : Number;

		public static var screenW : Number;

		public static var screenH : Number;



		public function Global()
		{
		}

		/**
		 * 初始化平台相关
		 * @param $width			游戏宽
		 * @param $height			游戏高
		 * @param $reverseMobile	是否翻转手机的默认方向	true代表宽度要大于高度
		 * @param $manufacturer		平台，默认为null，应该由程序捕捉。但ADL中可能存在错误，需要手动设置
		 */
		public static function initCapabilities($originalScreenW : Number, $originalScreenH : Number, $reverseMobile : Boolean =
			false, $manufacturer : String = null) : void
		{
			// 如果不是移动平台，则使用传入的宽高
			originalScreenW = screenW = $originalScreenW;
			originalScreenH = screenH = $originalScreenH;

			var manufacturer : String = $manufacturer || Capabilities.manufacturer;
			if (manufacturer.toLowerCase().indexOf("android") != -1)
			{
//				screenW = ($reverseMobile == false) ? stage.stageWidth : stage.stageHeight;
//				screenH = ($reverseMobile == false) ? stage.stageHeight : stage.stageWidth;

				if ($reverseMobile)
				{
					screenW = Math.max(stage.stageWidth, stage.stageHeight);
					screenH = Math.min(stage.stageWidth, stage.stageHeight);
				}
				else
				{
					screenW = Math.min(stage.stageWidth, stage.stageHeight);
					screenH = Math.max(stage.stageWidth, stage.stageHeight);
				}
//				screenW = stage.stageWidth;
//				screenH = stage.stageHeight;
			}
			else
			{
				screenW = stage.stageWidth;
				screenH = stage.stageHeight;
			}

			Debugger.warn("screenW", screenW, "screenH", screenH, "originalScreenW", originalScreenW, "originalScreenH", originalScreenH);
			Debugger.warn("stage width", stage.stageWidth, "stage height", stage.stageHeight);
		}

		/**
		 * 屏幕的高度缩放比例
		 */
		public static function heightRatio() : Number
		{
			return originalScreenH / screenH;
		}

		/**
		 * 屏幕的宽度缩放比例
		 */
		public static function widthRatio() : Number
		{
			return originalScreenW / screenW;
		}

		/**
		 * 原x坐标映射到现在屏幕坐标
		 * @param originalY
		 * @return
		 */
		public static function mapToScreenX(originalX : Number) : Number
		{
			return originalX / originalScreenW * screenW;
		}

		/**
		 * 原y坐标映射到现在屏幕坐标
		 * @param originalY
		 * @return
		 */
		public static function mapToScreenY(originalY : Number) : Number
		{
			return originalY / originalScreenH * screenH;
		}

		/**
		 * 宽度映射
		 * @param iWidth
		 * @return
		 */
		public static function mapToWidth(iWidth : Number) : Number
		{
			return mapToScreenX(iWidth);
		}

		/**
		 * 高度映射
		 * @param iHeight
		 * @return
		 */
		public static function mapToHeight(iHeight) : Number
		{
			return mapToScreenY(iHeight);
		}

		public static function isSingleMode() : Boolean
		{
			return mode == MODE_SINGLE;
		}

		public static function isMultiMode() : Boolean
		{
			return mode == MODE_MULTI;
		}



	}
}
