package cactus.ui.control
{
	import cactus.ui.bind.PAutoView;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * 滚动区域
	 * @author Peng
	 */
	public class PScrollPane extends PAutoView
	{
		// 绑定素材
		/**
		 * 滚动条
		 * @default
		 */
		public var scrollBar:PScrollBarEx
		/**
		 * 显示区域遮罩
		 * @default
		 */
		public var viewport_PB:MovieClip;
		/**
		 * 容器
		 * @default
		 */
		private var content:Sprite;
		
		protected var _scrollBarSkin:Class;


		public function PScrollPane($sourceName:String = null,scrollBarSkin:Class = null)
		{
			_scrollBarSkin = scrollBarSkin;
			super($sourceName);
		}


		override public function init():void
		{
			super.init();
			addEventListener(Event.RESIZE, onResize);
			addEventListener(Event.ADDED, onResize);

			// 调整content位置到视口
			content = new Sprite();
			content.x = viewport_PB.x;
			content.y = viewport_PB.y;

			super.addChild(content);

			content.mask = viewport_PB;
			
			
			
			// 将滚动条自动设置到List的位置
			scrollBar =  new PScrollBarEx(_scrollBarSkin,PSliderEx.VERTICAL);
			scrollBar.x = viewport_PB.width;
			scrollBar.y = 0;
			scrollBar.addEventListener(Event.CHANGE, onScroll);
			scrollBar.setSliderParams(0, 0, 0);
			addChild(scrollBar);
			
			autoHideScrollBar = true;
		}

		override public function destory():void
		{
			removeEventListener(Event.RESIZE, onResize);
			removeEventListener(Event.ADDED, onResize);
		}


		///////////////////////////////////
		// public methods
		///////////////////////////////////

		/**
		 * 向容器中添加显示组件
		 * @param child
		 */
		public function addContent(child:DisplayObject):void
		{
			content.addChild(child);
			invalidate();
		}

		override public function draw():void
		{
			super.draw();

			var vPercent:Number = (viewport_PB.height - 10) / content.height;

			scrollBar.setThumbPercent(vPercent);
			scrollBar.maximum = Math.max(0, content.height - viewport_PB.height + 10);
			scrollBar.pageSize = viewport_PB.height - 10;

			if (vPercent >= 1)
			{
				content.x = viewport_PB.x;
				content.y = viewport_PB.y;
			}

		}

		public function update():void
		{
			invalidate();
		}

		///////////////////////////////////
		// event handlers
		///////////////////////////////////

		/**
		 * 当滚动条滑动时
		 */
		protected function onScroll(event:Event):void
		{
//			trace("onScroll pscrollslider",vScrollbar_PB.value);
			content.y = (viewport_PB.y - scrollBar.value);
		}

		protected function onResize(event:Event):void
		{
			invalidate();
		}

		public function set autoHideScrollBar(value:Boolean):void
		{
			scrollBar.autoHide = value;
		}

		public function get autoHideScrollBar():Boolean
		{
			return scrollBar.autoHide;
		}
	}
}
