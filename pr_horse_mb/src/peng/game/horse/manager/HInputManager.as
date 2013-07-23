package peng.game.horse.manager
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	import cactus.common.Global;
	
	/**
	 * 输入
	 * @author Administrator
	 */
	public class HInputManager
	{
		private static var _instance:HInputManager = new HInputManager;
		
		private var _stage:Stage;
		
		private var _stageMouseDown:Function;
		private var _stageMouseUp:Function;
		
		public function HInputManager()
		{
		}
		
		public static function getIns():HInputManager
		{
			return _instance;
		}
		
		public function init($onStageMouseDown:Function, $onStageMouseUp:Function):void
		{
			_stage = Global.stage;
			_stageMouseDown = $onStageMouseDown;
			_stageMouseUp = $onStageMouseUp;
			
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, _stageMouseDown);
			_stage.addEventListener(MouseEvent.MOUSE_UP, _stageMouseUp);
			
		}
		
		public function destory():void
		{
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN, _stageMouseDown);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, _stageMouseUp);
		}
	}
}
