package peng.game.horse.core
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import cactus.common.frame.resource.ResourceFacade;
	import cactus.common.xx.sprite.GameDispose;
	import cactus.ui.events.ViewEvent;

	/**
	 * 会自动移除的影片剪辑
	 * @author Peng
	 */
	public class AutoDisposeMovieClip extends GameDispose
	{
		protected var _body:MovieClip;

		public function AutoDisposeMovieClip($sourceName:String)
		{
			super();

			_body=ResourceFacade.getMC($sourceName);
		}

		public function get body():MovieClip
		{
			return _body;
		}

		public function set body(value:MovieClip):void
		{
			_body = value;
		}

		override public function init():void
		{
			_body.addEventListener(ViewEvent.SHOW_OUTED, onShowOuted);
			_body.gotoAndStop(1);
			addChild(_body);
			
			// 可以提取更多的方法
			_body.play();
		}

		override public function destory():void
		{
			_body.stop();
			_body=null;
		}

		protected function onShowOuted(event:Event):void
		{
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
		}

	}
}
