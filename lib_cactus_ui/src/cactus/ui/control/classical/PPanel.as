package cactus.ui.control.classical
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import cactus.ui.control.layout.ILayout;

	/**
	 *	Panel
	 *  content的宽，高与主容器保持一致
	 * @author Peng
	 */
	public class PPanel extends PComponent
	{
		private var _content:PComponent
		private var _layout:ILayout;

		public function PPanel()
		{
			super();
			init();
		}

		/**
		 * 初始化
		 */
		override protected function init():void
		{
			if (!_content)
			{
				_content=new PComponent;
				addRawChild(_content);
			}
		}

		override public function setSize(w:Number, h:Number):void
		{
			_content.setSize(w,h);
			super.setSize(w,h);
		}
		
		/**
		 * 内容面板
		 * @return
		 */
		public function get content():Sprite
		{
			return _content;
		}
		
		/**
		 * 布局
		 * @return
		 */
		public function get layout():ILayout
		{
			return _layout;
		}

		public function set layout(value:ILayout):void
		{
			_layout=value;
		}

		/**
		 *
		 */
		public override function addChild(child:DisplayObject):DisplayObject
		{
			content.addChild(child);

			if (layout)
			{
				layout.layout();
			}
			return child;
		}

		/**
		 *
		 */
		public function addRawChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			return child;
		}

	}
}
