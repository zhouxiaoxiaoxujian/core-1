package cactus.ui.control
{
	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.classical.PRectangle;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 下拉选择框
	 * 
	 * Usage:
	 * 声明：	public var cbb_PB:PComboBox = new PComboBox(null, PRectangle, [100, 30], 40, 5); 参数详见文档
	 * 
	 * 使用：
	 * 
	 * 数据
	 * var cpListData:Array = [];
	 * for (i = 0; i < 50; i++)
	 * {
	 * 		cpListData.push({"label": "吼" + i.toString(), "value": i});
	 * }
	 * 
	 * 赋值：
	 * cbb_PB.data = cpListData;
	 * 
	 * 选择框改变的监听器
	 * cbb_PB.addEventListener(Event.SELECT, onCbbSelect);
	 * 
	 * 默认选中序列，当然可以不设置
	 * cbb_PB.selectedIndex = 5;
	 * 
	 * 
	 * @author Peng
	 */
	public class PComboBox extends PAutoView
	{
		public var btn_open_PB:PButton;
		public var btn_label_PB:PButton;
		[Bind]
		public var lst:PList = new PList(null, PRectangle, [100, 30, 0x0000ff]);

		protected var _defaultLabel:String = "";
		protected var _items:Array;
		protected var _numVisibleItems:int = 6;
		protected var _open:Boolean = false;

		protected var _listRenderClass:Class;
		protected var _listRenderClassParams:Array;
		protected var _listLineHeight:int;
		protected var _listLineGap:int;

		/**
		 * 
		 * @param $sourceName				绑定使用null
		 * @param $listRenderClass			列表渲染器
		 * @param $listRenderClassParams	列表渲染器参数
		 * @param $listLineHeight			每一行的高度
		 * @param $listLineGap				高度间隙
		 * @param defaultLabel				默认显示标签
		 */
		public function PComboBox($sourceName:String = null, $listRenderClass:Class = null, $listRenderClassParams:Array = null, $listLineHeight:int = 20, $listLineGap:int = 5, defaultLabel:String = "")
		{
			super($sourceName);
			_defaultLabel = defaultLabel;

			_listLineHeight = $listLineHeight;
			_listLineGap = $listLineGap;
			_listRenderClass = $listRenderClass;
			_listRenderClassParams = $listRenderClassParams;
		}

		override public function init():void
		{
			super.init();
			
			updateDisplayList();
		}

		public function updateDisplayList():void
		{
			setLabelButtonLabel();
			addChildren();
			removeList();
			
			lst.setStandard(_listLineHeight,_listLineGap);
			lst.setRenderer(_listRenderClass,_listRenderClassParams);
		}
		
		override public function destory():void
		{
			lst.removeEventListener(Event.SELECT, onSelect);

			btn_label_PB.removeEventListener(MouseEvent.CLICK, onDropDown);
			btn_open_PB.removeEventListener(MouseEvent.CLICK, onDropDown);
		}


		override public function set data(value:Object):void
		{
			lst.data = value;
		}

		
		public function setStandard( $listLineHeight:int = 20, $listLineGap:int = 5, defaultLabel:String = ""):void
		{
			_defaultLabel = defaultLabel;
			_listLineHeight = $listLineHeight;
			_listLineGap = $listLineGap;
			
			updateDisplayList();
		}
		
		public function setRenderer($listRenderClass:Class = null, $listRenderClassParams:Array = null):void
		{
			_listRenderClass = $listRenderClass;
			_listRenderClassParams = $listRenderClassParams;
			
			updateDisplayList();
		}
		
		protected function addChildren():void
		{
			lst.autoHideScrollBar = true;
			lst.addEventListener(Event.SELECT, onSelect);

			btn_label_PB.addEventListener(MouseEvent.CLICK, onDropDown);
			btn_open_PB.addEventListener(MouseEvent.CLICK, onDropDown);
		}

		/**
		 * 设置ComboBox选中的标签文本
		 */
		protected function setLabelButtonLabel():void
		{
			if (selectedItem == null)
			{
				btn_label_PB.setLabel(_defaultLabel);
			}
			else if (selectedItem is String)
			{
				btn_label_PB.setLabel(selectedItem as String);
			}
			else if (selectedItem.hasOwnProperty("label") && selectedItem.label is String)
			{
				btn_label_PB.setLabel(selectedItem.label);
			}
			else
			{
				btn_label_PB.setLabel(selectedItem.toString());
			}
		}

		/**
		 * 隐藏List，不是remove
		 */
		protected function removeList():void
		{
			lst.visible = false;
//			btn_open_PB.setLabel("+");
			btn_open_PB.selected = true;

			if (stage && stage.hasEventListener(MouseEvent.CLICK))
			{
				stage.removeEventListener(MouseEvent.CLICK, onStageClick);
			}
		}



		///////////////////////////////////
		// public methods
		///////////////////////////////////

		/**
		 * 添加一项
		 * @param item 可以是String，或者带有label属性的Object
		 */
		public function addItem(item:Object):void
		{
			lst.addItem(item);
		}

		/**
		 * 添加一项到指定位
		 * @param item 可以是String，或者带有label属性的Object
		 * @param index 添加下标
		 */
		public function addItemAt(item:Object, index:int):void
		{
			lst.addItemAt(item, index);
		}

		/**
		 * 删除一项
		 * @param item 如果是字符串，被包含就被删除。如果是Object，引用一致才能被删除
		 */
		public function removeItem(item:Object):void
		{
			lst.removeItem(item);
		}

		/**
		 * 删除一项
		 * @param index 被删除的下标
		 */
		public function removeItemAt(index:int):void
		{
			lst.removeItemAt(index);
		}

		/**
		 * 删除所有
		 */
		public function removeAll():void
		{
			lst.removeAll();
		}




		///////////////////////////////////
		// event handlers
		///////////////////////////////////

		/**
		 * 触发关闭或者打开列表
		 */
		protected function onDropDown(event:MouseEvent):void
		{
			_open = !_open;
			if (_open)
			{
				stage.addEventListener(MouseEvent.CLICK, onStageClick);
				lst.visible = true;
//				btn_open_PB.setLabel("-");
				btn_open_PB.selected = false;
			}
			else
			{
				removeList();
			}
		}

		/**
		 * 打开List点击ComboBox外，关闭List
		 */
		protected function onStageClick(event:MouseEvent):void
		{
			if (event.target == btn_open_PB.source || event.target == btn_label_PB.source)
				return;
			if (lst.hitTestPoint(event.stageX, event.stageY))
			// if (new Rectangle(lst_PB.x, lst_PB.y, lst_PB.width, lst_PB.height).contains(event.stageX, event.stageY))
				return;

			_open = false;
			removeList();
		}

		/**
		 * 当选中列表中的一项
		 */
		protected function onSelect(event:Event):void
		{
			_open = false;
			removeList();
			setLabelButtonLabel();
			dispatchEvent(event);
		}


		///////////////////////////////////
		// getter/setters
		///////////////////////////////////

		public function set selectedIndex(value:int):void
		{
			lst.selectedIndex = value;
			setLabelButtonLabel();
		}

		public function get selectedIndex():int
		{
			return lst.selectedIndex;
		}

		/**
		 * 设置选中
		 */
		public function set selectedItem(item:Object):void
		{
			lst.selectedItem = item;
			setLabelButtonLabel();
		}

		public function get selectedItem():Object
		{
			return lst.selectedItem;
		}


		/**
		 * 默认显示的Label
		 */
		public function set defaultLabel(value:String):void
		{
			_defaultLabel = value;
			setLabelButtonLabel();
		}

		public function get defaultLabel():String
		{
			return _defaultLabel;
		}

		/**
		 * 设置下拉列表中科显示的个数
		 */
		public function set numVisibleItems(value:int):void
		{
			_numVisibleItems = value;
			invalidate();
		}

		public function get numVisibleItems():int
		{
			return _numVisibleItems;
		}

		public function set items(value:Array):void
		{
			lst.items = value;
		}

		public function get items():Array
		{
			return lst.items;
		}

		/**
		 * 设置List的renderer
		 */
		public function set listItemClass(value:Class):void
		{
			lst.listItemClass = value;
		}

		public function get listItemClass():Class
		{
			return lst.listItemClass;
		}


		/**
		 * 是否使用alternateRows，功能未实现
		 */
		public function set alternateRows(value:Boolean):void
		{
			lst.alternateRows = value;
		}

		public function get alternateRows():Boolean
		{
			return lst.alternateRows;
		}

		/**
		 * 是否自动隐藏滚动条
		 */
		public function set autoHideScrollBar(value:Boolean):void
		{
			lst.autoHideScrollBar = value;
			invalidate();
		}

		public function get autoHideScrollBar():Boolean
		{
			return lst.autoHideScrollBar;
		}

		/**
		 * 下拉框是否打开
		 */
		public function get isOpen():Boolean
		{
			return _open;
		}
	}
}
