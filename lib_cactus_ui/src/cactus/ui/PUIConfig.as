package cactus.ui
{
	import cactus.common.resource.IResourceHelper;
	import cactus.ui.bind.PReflectUtil;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 *
	 * @author Peng
	 */
	public class PUIConfig
	{
		private static var _resourceHelperImpl:IResourceHelper;
		private static var _stage:Stage;
		
		private static var _reflectionRecycleTimer:Timer;
		public static function registeStage(stage:Stage):void
		{
			_stage = stage;
			
			// 启动反射回收机制,默认5分钟回收一次
			if ( !_reflectionRecycleTimer)
			{
				_reflectionRecycleTimer = new Timer(5 * 60 * 1000);
				_reflectionRecycleTimer.addEventListener(TimerEvent.TIMER,function(event:TimerEvent):void
				{
					PReflectUtil.clearDescribeType();
				});
				_reflectionRecycleTimer.start();
			}
		}
		
		public static function getStage():Stage
		{
			return _stage;
		}
		
		public static function initResourceHelper(helper:IResourceHelper):void
		{
			_resourceHelperImpl = helper;
		}
		
		public static function getMC(name:String):MovieClip
		{
			return _resourceHelperImpl.getMC(name);	
		}
		
		public static function loadByRelateObjectArr(arr:Array, completeFun:Function = null, errorFun:Function = null, progressFun:Function = null):void
		{
			return _resourceHelperImpl.loadByRelateObjectArr(arr,completeFun,errorFun,progressFun);	
		}
		
		// 定义后缀均为3个字符 
		// 绑定对象均使用下划线和大写

		/**
		 * 标示UI绑定对象
		 * @default
		 */
		public static const PB:String = "_PB";

		/**
		 * loading素材链接
		 * @default
		 */
		public static const RES_LOADING:String = "Loading";

		// 定义前缀均为4个字符
		// 资源中实例名均使用下划线和小写

		// 多帧的按钮前缀
		public static const PRIFIX_BUTTON:String = "btn_";

		// TweenButton前缀
		public static const PRIFIX_TWEEN_BUTTON:String = "ttn_";

		// 影片剪辑
		public static const PRIFIX_MOVIECLIP:String = "mmc_";

		// 文本框前缀
		public static const PRIFIX_TEXTFIELD:String = "txt_";

		// 静态TileList前缀
		public static const PRIFIX_STATIC_TILE_LIST:String = "slt_"

		// 具有Tween的TileList前缀
		public static const PRIFIX_TWEEN_TILE_LIST:String = "tlt_"

		// 复选框
		public static const PRIFIX_CHECKBOX:String = "chb_";

		// 步进器
		public static const PRIFIX_NUMBER_STEPPER:String = "nsp_";

		// 进度条
		public static const PRIFIX_PROGRESS_BAR:String = "pgb_";

		public function PUIConfig()
		{
		}
	}
}
