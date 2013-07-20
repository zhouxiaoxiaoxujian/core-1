
package cactus.ui.control
{
	import cactus.common.tools.util.ClassUtil;
	import cactus.ui.bind.PAutoView;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	[Event(name="select", type="flash.events.Event")]
	/**
	 *
	 * PList 待完善
	 * 绑定的实例名称
	 * scrollBar： 一个PVScrollBar类型，内嵌的实例名称详见ScrollBar
	 * viewprot:可视区域
	 *
	 * Renderer实现IPListRenderer接口
	 * @author Peng
	 */
	public class PList extends PAutoView
	{
		// 绑定的UI
		// 滚动条应该不可以随意指定，而是由皮肤类指定
		public var scrollBar:PScrollBarEx;

		// 显示区域
		public var viewport_PB:MovieClip;

		// item数据源 
		protected var _items:Array=[];

		// Renderer类
		protected var _itemRendererClass:Class;

		// Renderer 参数
		protected var _itemRendererClassParams:Array;

		protected var _lineHeight:int=0;

		protected var _lineGap:int=0;

		/**
		 * 选中的index
		 * @default
		 */
		protected var _selectedIndex:int=-1;

		/**
		 * 是否交换行
		 * @default
		 */
		protected var _alternateRows:Boolean=false;

		/**
		 * 存放各种itemRenderer
		 * @default
		 */
		protected var _itemHolder:Sprite;

		/**
		 * 滚动条皮肤，如果不传递，使用
		 * @default
		 */
		protected var _scrollBarSkin:Class;

		/**
		 * 滚动条的大小
		 * @default
		 */
		protected var _scrollBarSize:Number;

		public function PList($souceName:*=null, $rendererClass:Class=null, $rendererClassParams:Array=null, $lineHeight:int=20, $lineGap:int=0, scrollBarSkin:Class=null, scrollBarSize:Number=1)
		{
			_itemRendererClass=$rendererClass;
			_itemRendererClassParams=$rendererClassParams;
			_lineHeight=$lineHeight;
			_lineGap=$lineGap;
			_scrollBarSkin=scrollBarSkin;
			_scrollBarSize=scrollBarSize;

			if (!$rendererClassParams)
				_itemRendererClassParams=new Array;
			super($souceName);
		}

		override public function init():void
		{
			addChildren();

			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			addEventListener(Event.RESIZE, onResize);
			makeListItems();
			fillItems();
		}

		override public function destory():void
		{
			super.destory();
		}

		override public function fireDataChange():void
		{
			if ( _itemRendererClass)
			{
				invalidate();
				makeListItems();
				fillItems();
			}
		}

		override public function set data(value:Object):void
		{
			_items=value as Array;
			super.data=value;
		}


		public function setStandard($lineHeight:int=20, $lineGap:int=0, scrollBarSkin:Class=null, scrollBarSize:Number=1):void
		{
			_lineHeight=$lineHeight;
			_lineGap=$lineGap;
			_scrollBarSkin=scrollBarSkin;
			_scrollBarSize=scrollBarSize;

			addChildren();
			makeListItems();
			fillItems();

		}

		public function setRenderer($rendererClass:Class=null, $rendererClassParams:Array=null):void
		{
			_itemRendererClass=$rendererClass;
			_itemRendererClassParams=$rendererClassParams;

			if (!$rendererClassParams)
				_itemRendererClassParams=new Array;

			addChildren();
			makeListItems();
			fillItems();
		}

		protected function addChildren():void
		{
			_itemHolder=new Sprite();
			_itemHolder.x=viewport_PB.x;
			_itemHolder.y=viewport_PB.y;
			addChild(_itemHolder);

			_itemHolder.mask=viewport_PB;

			// 将滚动条自动设置到List的位置
			scrollBar=new PScrollBarEx(_scrollBarSkin, PSliderEx.VERTICAL, null, _scrollBarSize);
			scrollBar.x=viewport_PB.width;
			scrollBar.y=0;
			scrollBar.autoHide=true;
			scrollBar.addEventListener(Event.CHANGE, onScroll);
			scrollBar.setSliderParams(0, 0, 0);
			addChild(scrollBar);
		}

		/**
		 * 根据data创建ListItem
		 */
		protected function makeListItems():void
		{
			// 删除itemHolder的全部内容
			var item:IPListRenderer;
			while (_itemHolder.numChildren > 0)
			{
				item=IPListRenderer(_itemHolder.getChildAt(0));
				item.removeEventListener(MouseEvent.CLICK, onSelect);
				_itemHolder.removeChildAt(0);
			}

			// 根据高度计算item的数量
			var numItems:int=Math.ceil(viewport_PB.height / _lineHeight);

			numItems=Math.min(numItems, _items.length);
//			numItems=Math.max(numItems, 1);
			for (var i:int=0; i < numItems; i++)
			{
				
					// 对Renderer布局
					item=ClassUtil.construct(_itemRendererClass, _itemRendererClassParams);
					item.x=0;
					item.y=i * _lineHeight;
					item.addEventListener(MouseEvent.CLICK, onSelect);
					_itemHolder.addChild(item as DisplayObject);
			}
		}

		/**
		 *
		 */
		protected function fillItems():void
		{
			if (!_itemRendererClass)
				return;
			
			var offset:int=scrollBar.value;
			var numItems:int=Math.ceil(viewport_PB.height / _lineHeight);
			numItems=Math.min(numItems, _items.length);
			for (var i:int=0; i < numItems; i++)
			{
				var item:IPListRenderer=_itemHolder.getChildAt(i) as IPListRenderer;
				if (offset + i < _items.length)
				{
					item.data=_items[offset + i];
//					trace("fill", item.x, item.y, _items[offset + i]);
				}
//				else
//				{
//					item.data="";
//				}
//				if (_alternateRows)
//				{
//					item.defaultColor=((offset + i) % 2 == 0) ? _defaultColor : _alternateColor;
//				}
//				else
//				{
//					item.defaultColor=_defaultColor;
//				}
				if (offset + i == _selectedIndex)
				{
					item.selected=true;
				}
				else
				{
					item.selected=false;
				}
			}
		}

		/**
		 * If the selected item is not in view, scrolls the list to make the selected item appear in the view.
		 */
		protected function scrollToSelection():void
		{
			var numItems:int=Math.ceil(viewport_PB.height / _lineHeight);
			if (_selectedIndex != -1)
			{
				if (scrollBar.value > _selectedIndex)
				{
					scrollBar.value=_selectedIndex;
				}
				else if (scrollBar.value + numItems <= _selectedIndex)
				{
					scrollBar.value=_selectedIndex - numItems + 1;
				}
			}
			else
			{
				scrollBar.value=0;
			}
			fillItems();
		}

		///////////////////////////////////
		// public methods
		///////////////////////////////////
		override public function draw():void
		{
			super.draw();

			_selectedIndex=Math.min(_selectedIndex, _items.length - 1);

			// scrollbar
			scrollBar.x=viewport_PB.width;
			var contentHeight:Number=_items.length * _lineHeight;
			scrollBar.setThumbPercent(viewport_PB.height / contentHeight);

			var pageSize:Number=Math.floor(viewport_PB.height / _lineHeight);
			scrollBar.maximum=Math.max(0, _items.length - pageSize);
			scrollBar.pageSize=pageSize;
			scrollBar.draw();
			scrollBar.height=viewport_PB.height;

			scrollToSelection();
		}

		/**
		 * 向List中添加item
		 * @param item :The item to add. Can be a string or an object containing a string property named label.
		 */
		public function addItem(item:Object):void
		{
			_items.push(item);
			invalidate();
			makeListItems();
			fillItems();
		}

		/**
		 * 向List的指定index中添加一个Item
		 * @param item 	:The item to add. Can be a string or an object containing a string property named label.
		 * @param index	:The index at which to add the item.
		 */
		public function addItemAt(item:Object, index:int):void
		{
			index=Math.max(0, index);
			index=Math.min(_items.length, index);
			_items.splice(index, 0, item);
			invalidate();
			fillItems();
		}

		/**
		 * Removes the referenced item from the list.
		 * @param item The item to remove. If a string, must match the item containing that string. If an object, must be a reference to the exact same object.
		 */
		public function removeItem(item:Object):void
		{
			var index:int=_items.indexOf(item);
			removeItemAt(index);
		}

		/**
		 * Removes the item from the list at the specified index
		 * @param index The index of the item to remove.
		 */
		public function removeItemAt(index:int):void
		{
			if (index < 0 || index >= _items.length)
				return;
			_items.splice(index, 1);
			invalidate();
			fillItems();
		}

		/**
		 * Removes all items from the list.
		 */
		public function removeAll():void
		{
			_items.length=0;
			invalidate();
			fillItems();
		}

		///////////////////////////////////
		// event handlers
		///////////////////////////////////

		/**
		 * 当选中列表中的一个Item
		 */
		protected function onSelect(event:Event):void
		{
			// 注意Renderer中的target何currentTarge区别
			if (!(event.target is IPListRenderer) && !(event.currentTarget is IPListRenderer))
				return;

			var offset:int=scrollBar.value;

			for (var i:int=0; i < _itemHolder.numChildren; i++)
			{
				if (_itemHolder.getChildAt(i) == event.currentTarget)
					_selectedIndex=i + offset;
				IPListRenderer(_itemHolder.getChildAt(i)).selected=false;
			}
			// IPListRenderer(event.target).selected = true;
			IPListRenderer(event.currentTarget).selected=true;
			dispatchEvent(new Event(Event.SELECT));
		}

		/**
		 * 拖动滚动条时
		 */
		protected function onScroll(event:Event):void
		{
			fillItems();
		}

		/**
		 * 滚动鼠标滑轮
		 */
		protected function onMouseWheel(event:MouseEvent):void
		{
			scrollBar.value-=event.delta;
			fillItems();
		}

		protected function onResize(event:Event):void
		{
			makeListItems();
			fillItems();
		}

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////

		public function set selectedIndex(value:int):void
		{
			if (value >= 0 && value < _items.length)
			{
				_selectedIndex=value;
//				scrollBar.value = _selectedIndex;
			}
			else
			{
				_selectedIndex=-1;
			}
			invalidate();
			dispatchEvent(new Event(Event.SELECT));
		}

		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedItem(item:Object):void
		{
			var index:int=_items.indexOf(item);
			selectedIndex=index;
			invalidate();
			dispatchEvent(new Event(Event.SELECT));
		}

		public function get selectedItem():Object
		{
			if (_selectedIndex >= 0 && _selectedIndex < _items.length)
			{
				return _items[_selectedIndex];
			}
			return null;
		}

		public function set items(value:Array):void
		{
			_items=value;
			invalidate();
		}

		public function get items():Array
		{
			return _items;
		}

		public function set listItemClass(value:Class):void
		{
			_itemRendererClass=value;
			makeListItems();
			invalidate();
		}

		public function get listItemClass():Class
		{
			return _itemRendererClass;
		}

		public function set alternateRows(value:Boolean):void
		{
			_alternateRows=value;
			invalidate();
		}

		public function get alternateRows():Boolean
		{
			return _alternateRows;
		}

		public function set autoHideScrollBar(value:Boolean):void
		{
			scrollBar.autoHide=value;
		}

		public function get autoHideScrollBar():Boolean
		{
			return scrollBar.autoHide;
		}

		/**
		 * 行间距
		 * @default
		 */
		public function get lineGap():int
		{
			return _lineGap;
		}

		/**
		 * @private
		 */
		public function set lineGap(value:int):void
		{
			_lineGap=value;
			fireDataChange();
		}

		/**
		 * 每一行的高度，根据Renderer获得
		 * @default
		 */
		public function get lineHeight():int
		{
			return _lineHeight;
		}

		/**
		 * @private
		 */
		public function set lineHeight(value:int):void
		{
			_lineHeight=value;
			fireDataChange();
		}

		public function get itemRendererClassParams():Array
		{
			return _itemRendererClassParams;
		}

		public function set itemRendererClassParams(value:Array):void
		{
			_itemRendererClassParams=value;
		}

		public function get itemRendererClass():Class
		{
			return _itemRendererClass;
		}

		public function set itemRendererClass(value:Class):void
		{
			_itemRendererClass=value;
		}

	}
}
