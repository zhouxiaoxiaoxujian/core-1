package cactus.ui.control
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import cactus.ui.events.ViewEvent;

	/**
	 * 按钮组
	 * 可以放入所有实现IPGroupItem接口的对象
	 * @author: Peng
	 */
	[Event(name="GROUP_ITEM_CHANGE", type="com.he.ui.events.ViewEvent")]
	public class PButtonGroup extends EventDispatcher
	{
		private var _children : Vector.<IPGroupItem>;
		private var _selectItem : IPGroupItem;

		public function PButtonGroup()
		{

		}

		public function addChild(item : IPGroupItem) : void
		{
			children.push(item);
			item.addEventListener(ViewEvent.GROUP_ITEM_SELECT, onChange);
		}

		protected function onChange(event : Event) : void
		{
			// all to unselect
			for each (var item : IPGroupItem in _children)
			{
				item.selected = false;
			}
			selectItem = IPGroupItem(event.target);
			selectItem.selected = true;

			dispatchEvent(new ViewEvent(ViewEvent.GROUP_ITEM_CHANGE));
		}

		public function clear() : void
		{
			_children = new Vector.<IPGroupItem>;
		}

		public function get children() : Vector.<IPGroupItem>
		{
			if (!_children)
				_children = new Vector.<IPGroupItem>;
			return _children;
		}

		public function get selectItem() : IPGroupItem
		{
			return _selectItem;
		}

		public function set selectItem(value : IPGroupItem) : void
		{
			if (_selectItem == value)
				return;
			_selectItem = value;
		}
	}
}
