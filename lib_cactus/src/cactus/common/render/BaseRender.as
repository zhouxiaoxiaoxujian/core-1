package cactus.common.render
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class BaseRender extends EventDispatcher
	{
		/**
		 * 是否为只渲染一次的渲染器
		 * @default
		 */
		protected var _isStatic:Boolean;
		/**
		 * 是否允许将要渲染
		 * @default
		 */
		protected var _willRender:Boolean = true;
		/**
		 * 绘制对象
		 * @default
		 */
		private var _paper:Sprite;
		
		
		public function BaseRender($isStatic:Boolean=true)
		{
			_isStatic = $isStatic;
		}

		/**
		 * 清除渲染
		 */
		public function clear():void
		{
			paper.graphics.clear();
		}

		/**
		 * 渲染
		 * @throws Error
		 */
		public function draw():void 
		{
			throw new Error("no impl");
		}
		
		/**
		 * 重绘 
		 */
		public function reDraw():void
		{
			clear();
			invalidate();
		}

		protected function invalidate():void
		{
			_willRender = true;
			addEventListener(Event.ENTER_FRAME, onInvalidate);
		}

		protected function onInvalidate(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onInvalidate);
			draw();
		}

		public function get paper():Sprite
		{
			return _paper;
		}

		public function set paper(value:Sprite):void
		{
			_paper = value;
		}
	}
}
