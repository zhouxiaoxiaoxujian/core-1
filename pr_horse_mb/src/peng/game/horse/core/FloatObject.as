package peng.game.horse.core
{
	import cactus.common.tools.cache.single.DisplayCachePool;
	import cactus.common.xx.sprite.RectangleVehicle;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import peng.game.horse.HUtils;
	
	/**
	 * 随机形态的漂浮显示对象 
	 * 此物体不能自动触发销毁，必须手动销毁
	 * @author supperhpxd
	 */	
	public class FloatObject extends RectangleVehicle
	{
		/** 定义漂浮方向 **/
		public static const DIR_RIGHT_TO_LEFT:int = 1;
		public static const DIR_LEFT_TO_RIGHT:int = 2;
		public static const DIR_TOP_TO_BOTTOM:int = 4;
		public static const DIR_BOTTOM_TO_TOP:int = 8;
		public static const DIR_ALL:int 			=16;
		
		
		protected var _body:MovieClip;
		
		private var _linkage:String;
		private var _dir:int;
		
		public function FloatObject($linkage:String,$dir:int=16)
		{
			_linkage = $linkage;
			_dir = $dir;
			draw();
			super(_body.width,_body.height);
		}
		
		override public function destory():void
		{
			_body.stop();
			super.destory(); 
		}
		
		override public function init():void
		{
//			removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStage);
		}

		override public function update(delay:int):void  
		{
			super.update(delay);
		}
		override protected function draw():void
		{
			if (!_body)
			{
				_body = HUtils.getBitmapMovieClip(_linkage);
				_body.play();
				addChild(_body);
			}
		}
		
		override public function get body():MovieClip
		{
			return _body;
		}
		
	}
}