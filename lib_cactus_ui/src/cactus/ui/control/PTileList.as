package cactus.ui.control
{

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.engine.RenderingMode;

	import cactus.common.tools.util.ArrayUtils;
	import cactus.common.tools.util.ClassUtil;
	import cactus.ui.control.classical.PRectangle;

	/**
	 * TileList，适用于多行多列
	 * 固定，不支持动画翻滚
	 * 支持一次翻一页，或者一次翻到首尾
	 * @author: Peng
	 */
	public class PTileList extends PPageBase
	{
		// 固定存在的按钮
		public var btn_left1_PB : PButton;
		public var btn_left1p_PB : PButton;
		public var btn_first_PB : PButton;

		public var btn_right1_PB : PButton;
		public var btn_right1p_PB : PButton;
		public var btn_last_PB : PButton;

		// 可视区域
		public var viewport_PB : MovieClip;

		// 显示页码
		public var txt_page_PB : TextField;

		// 定位Renderer的信息
		public var paddingTop : Number;
		public var paddingLeft : Number;
		public var hgap : Number;
		public var vgap : Number;

		// Tile的列数 行数
		public var cols : int;
		public var rows : int;
		public var rendererClass : Class;
		public var rendererClassParams : Array;

		// 是否为默认的从左到右排序
		protected var leftToRight : Boolean;

		// 可视区域遮罩
		private var masker : PRectangle;

		// Renderer容器
		private var _itemHolder : Sprite;
		private var _children : Vector.<IPTileListRenderer>;
		private var _paddingLastPage : Boolean;

		public function PTileList($sourceName : String = null, $cols : int = 0, $rows : int = 0, $rendererClass : Class =
			null, $rendererClassParams : Array = null, $pLeft : Number = 0, $pTop : Number = 0, $hgap : Number = 0, $vgap : Number =
			0, $leftToRight : Boolean = true)
		{
			cols = $cols;
			rows = $rows;
			rendererClass = $rendererClass;
			rendererClassParams = $rendererClassParams;
			paddingTop = $pTop;
			paddingLeft = $pLeft;
			hgap = $hgap;
			vgap = $vgap;

			leftToRight = $leftToRight;
			if (!rendererClassParams)
			{
				rendererClassParams = new Array;
			}
			super($sourceName);
		}

		/**
		 * 是否补齐最后一页
		 * @default
		 */
		public function get paddingLastPage() : Boolean
		{
			return _paddingLastPage;
		}

		/**
		 * @private
		 */
		public function set paddingLastPage(value : Boolean) : void
		{
			_paddingLastPage = value;
		}

		override public function init() : void
		{
			super.init();

			if (btn_left1p_PB)
			{
				btn_left1p_PB.enabled = false;
				btn_left1p_PB.addEventListener(MouseEvent.CLICK, on_btn_left1p_click);
			}

			if (btn_right1p_PB)
			{
				btn_right1p_PB.enabled = false;
				btn_right1p_PB.addEventListener(MouseEvent.CLICK, on_btn_right1p_click);
			}

			if (btn_left1_PB)
			{
				btn_left1_PB.enabled = false;
				btn_left1_PB.addEventListener(MouseEvent.CLICK, on_btn_left1_click);
			}

			if (btn_right1_PB)
			{
				btn_right1_PB.enabled = false;
				btn_right1_PB.addEventListener(MouseEvent.CLICK, on_btn_right1_click);
			}

			if (btn_first_PB)
			{
				btn_first_PB.enabled = false;
				btn_first_PB.addEventListener(MouseEvent.CLICK, on_btn_first_click);
			}

			if (btn_last_PB)
			{
				btn_last_PB.enabled = false;
				btn_last_PB.addEventListener(MouseEvent.CLICK, on_btn_last_click);
			}

			// 根据素材中的滚动区域，动态添加Renderer
//			trace("----- 初始化一个TileList -----");
//			trace("viewport_PB x y widht height ", viewport_PB.x, viewport_PB.y, viewport_PB.width, viewport_PB.height)
//			trace("cols", cols);
//			trace("rows", rows);

			_children = new Vector.<IPTileListRenderer>;

			paddingLeft = viewport_PB.x + paddingLeft;
			paddingTop = viewport_PB.y + paddingTop;

			draw();
		}

		override public function draw() : void
		{
			addChildren();
			layout();

			if (_data)
			{
				this.data = _data;
			}
		}

		override public function destory() : void
		{
			if (_children)
			{
				for each (var item : IPTileListRenderer in _children)
				{
					item.removeEventListener(MouseEvent.CLICK, onSelect);
				}
			}

			while (this.numChildren > 0)
				removeChildAt(0);

			_children = new Vector.<IPTileListRenderer>;

			if (btn_left1p_PB)
				btn_left1p_PB.removeEventListener(MouseEvent.CLICK, on_btn_left1p_click);
			if (btn_right1p_PB)
				btn_right1p_PB.removeEventListener(MouseEvent.CLICK, on_btn_right1p_click);
			if (btn_first_PB)
				btn_first_PB.removeEventListener(MouseEvent.CLICK, on_btn_first_click);
			if (btn_last_PB)
				btn_last_PB.removeEventListener(MouseEvent.CLICK, on_btn_last_click);
			if (btn_left1_PB)
				btn_left1_PB.removeEventListener(MouseEvent.CLICK, on_btn_left1_click);
			if (btn_right1_PB)
				btn_right1_PB.removeEventListener(MouseEvent.CLICK, on_btn_right1_click);
		}

		override public function fireDataChange() : void
		{
			super.fireDataChange();
			showPage();
		}

		/**
		 * 设置相关参数
		 * @param $cols
		 * @param $rows
		 * @param $pLeft
		 * @param $pTop
		 * @param $hgap
		 * @param $vgap
		 * @param $leftToRight
		 */
		public function setStandard($cols : int = 0, $rows : int = 0, $pLeft : Number = 0, $pTop : Number = 0, $hgap : Number =
			0, $vgap : Number = 0, $leftToRight : Boolean = true) : void
		{
			cols = $cols;
			rows = $rows;
			paddingTop = $pTop;
			paddingLeft = $pLeft;
			hgap = $hgap;
			vgap = $vgap;

			leftToRight = $leftToRight;

			paddingLeft = viewport_PB.x + paddingLeft;
			paddingTop = viewport_PB.y + paddingTop;

			invalidate();
		}

		/**
		 * 设置渲染器
		 * @param $rendererClass
		 * @param $rendererClassParams
		 */
		public function setRenderer($rendererClass : Class = null, $rendererClassParams : Array = null) : void
		{
			rendererClass = $rendererClass;
			rendererClassParams = $rendererClassParams;
			if (!rendererClassParams)
			{
				rendererClassParams = new Array;
			}
			invalidate();
		}

		/**
		 * 根据输入数据获得renderer的引用
		 * @param $data	PTileList中的数据
		 * @return	持有该数据的Renderer
		 */
		public function getRenderer($data : *) : IPTileListRenderer
		{
			var index : int = ArrayUtils.getItemIndex(getModel(), $data);
			if (index != -1)
			{
				index = index % getEveryPageCount();
				return children[index];
			}
			return null;
		}

		public function get children() : Vector.<IPTileListRenderer>
		{
			return _children;
		}

		private function changePageText() : void
		{
			if (txt_page_PB)
			{
				txt_page_PB.text = currPage + "/" + getTotalPage();
			}
		}

		protected function on_btn_last_click(event : MouseEvent) : void
		{
			lastPage();
			showPage();
		}

		protected function on_btn_first_click(event : MouseEvent) : void
		{
			firstPage();
			showPage();
		}

		protected function on_btn_right1p_click(event : MouseEvent) : void
		{
			nextPage();
			showPage();
		}

		protected function on_btn_left1p_click(event : MouseEvent) : void
		{
			prevPage();
			showPage();
		}

		protected function on_btn_left1_click(event : MouseEvent) : void
		{
			currIndex--;
			showPage();
		}

		protected function on_btn_right1_click(event : MouseEvent) : void
		{
			currIndex++;
			showPage();
		}

		override public function set currIndex(value : int) : void
		{
			_currIndex = value;

			if (_paddingLastPage)
			{
				if (_currIndex + getEveryPageCount() >= getModel().length)
					_currIndex = getModel().length - getEveryPageCount();
			}
			else
			{
				if (_currIndex >= getModel().length)
					_currIndex = getModel().length - getEveryPageCount();
			}


			if (_currIndex < 0)
				_currIndex = 0;
		}

		override public function get currIndex() : int
		{
			currIndex = _currIndex;
			return _currIndex;
		}

		/**
		 * 更新当前页的模型
		 */
		private function showPage() : void
		{
			clearSelect();

			var model : Array = getCurrPageModel();

			for each (var item : IPTileListRenderer in _children)
				item.visible = false;

			for (var i : int = 0; i < model.length; i++)
			{
				// 以行优先的模型
				if (_children.length >= (i + 1))
				{
					_children[i].data = model[i];
					_children[i].visible = true;
				}
			}

			afterShowPage();

			showSelect();

			changePageText();
		}

		private function afterShowPage() : void
		{
			if (btn_last_PB)
				btn_last_PB.enabled = true;
			if (btn_first_PB)
				btn_first_PB.enabled = true;
			if (btn_left1_PB)
				btn_left1_PB.enabled = true;
			if (btn_left1p_PB)
				btn_left1p_PB.enabled = true;
			if (btn_right1_PB)
				btn_right1_PB.enabled = true;
			if (btn_right1p_PB)
				btn_right1p_PB.enabled = true;

			// 更新按钮状态
			if (!hasPrevPage() && btn_left1p_PB)
				btn_left1p_PB.enabled = false;

			if (!hasNextPage() && btn_right1p_PB)
				btn_right1p_PB.enabled = false;

			if (!hasPrevItem() && btn_left1_PB)
				btn_left1_PB.enabled = false;

			if (!hasNextItem() && btn_right1_PB)
				btn_right1_PB.enabled = false;

			if (isFirstPage() && btn_first_PB)
				btn_first_PB.enabled = false;

			if (isLastPage() && btn_last_PB)
				btn_last_PB.enabled = false;
		}

		private function addChildren() : void
		{
			if (!masker)
			{
				masker = new PRectangle(viewport_PB.width, viewport_PB.height, 0xffffff, 0xff0000, 0xffffff, false);
				masker.x = viewport_PB.x;
				masker.y = viewport_PB.y;
				addChild(masker);
				viewport_PB.visible = false;
			}

			if (!_itemHolder)
			{
				_itemHolder = new Sprite();
				addChild(_itemHolder);
			}

			_children = new Vector.<IPTileListRenderer>;
			while (_itemHolder.numChildren > 0)
			{
				_itemHolder.removeChildAt(0);
			}

			// 添加Renderer，比显示出的Renderer需要多出两列，左侧多一列，右侧也多一列
			var len : int = cols * rows;
			for (var i : int = 0; i < len; i++)
			{
				if (rendererClass)
				{
					var renderer : IPTileListRenderer = ClassUtil.construct(rendererClass, rendererClassParams);
					renderer.visible = false;
					renderer.master = this;
					_itemHolder.addChild(DisplayObject(renderer));
					renderer.addEventListener(MouseEvent.CLICK, onSelect);
					_children.push(renderer);
				}
			}
			_itemHolder.mask = masker;
		}

		// ==================== 选中功能添加 ====================
		protected var _selectedIndex : int = -1;

		/**
		 * 当选中列表中的一个Item
		 *
		 */
		protected function onSelect(event : Event) : void
		{
			// 注意Renderer中的target何currentTarge区别
			if (!(event.target is IPListRenderer) && !(event.currentTarget is IPListRenderer))
				return;

			// 页数
			var offset : int = getEveryPageCount() * (currIndex / getEveryPageCount());

			for (var i : int = 0; i < _itemHolder.numChildren; i++)
			{
				if (_itemHolder.getChildAt(i) == event.currentTarget)
					_selectedIndex = i + offset;
				IPListRenderer(_itemHolder.getChildAt(i)).selected = false;
			}

			IPListRenderer(event.currentTarget).selected = true;
			dispatchEvent(new Event(Event.SELECT));
			// trace("_selectedIndex", _selectedIndex);
		}

		// 翻页时清空
		protected function clearSelect() : void
		{
			// trace("clearSelect");
			for (var i : int = 0; i < _itemHolder.numChildren; i++)
			{
				if (_itemHolder.getChildAt(i) is IPListRenderer)
				{
					IPListRenderer(_itemHolder.getChildAt(i)).selected = false;
				}
			}
		}

		protected function showSelect() : void
		{
			var max : int = (getEveryPageCount()) * (currIndex / getEveryPageCount()) + getEveryPageCount();
			var min : int = (getEveryPageCount()) * (currIndex / getEveryPageCount());
			var idx : int = _selectedIndex % getEveryPageCount();
			// trace("idx", idx, "max", max, "min", min);
			if (_selectedIndex < max && _selectedIndex >= min)
			{
				for (var i : int = 0; i < _itemHolder.numChildren; i++)
				{
					if (_itemHolder.getChildAt(i) is IPListRenderer)
					{
						IPListRenderer(_itemHolder.getChildAt(i)).selected = false;
					}
				}

				IPListRenderer(_itemHolder.getChildAt(idx)).selected = true;
			}
		}

		/**
		 * 获得选中的结点
		 * @return
		 */
		public function getSelectedItem() : IPTileListRenderer
		{
			if (_selectedIndex < 0 || _children == null)
			{
				return null;
			}

			var id : int = _selectedIndex % _children.length;
			return _children[_selectedIndex];
		}


		// ==================== 选中功能 end ====================

		private function layout() : void
		{
			var item : IPTileListRenderer;
			var currRow : int = 0;
			var currCol : int = 0;
			var i : int = 0;

			// 默认从左到右的排列方式
			if (leftToRight)
			{
				currCol = 0;
				for (i = 0; i < _children.length; i++)
				{
					item = _children[i];

					// 计算行列号
					if (currCol >= cols)
					{
						currCol = 0;
						currRow++;
					}

					// 调整位置
					item.x = paddingLeft + (item.width + hgap) * (currCol);
					item.y = paddingTop + (item.height + vgap) * currRow;

					currCol++;
				}
			}
			// 从右到左的排列方式
			else
			{
				currCol = cols - 1;
				for (i = 0; i < _children.length; i++)
				{
					item = _children[i];

					// 计算行列号
					if (currCol < 0)
					{
						currCol = cols - 1;
						currRow++;
					}

					// 调整位置
					item.x = paddingLeft + (item.width + hgap) * (currCol);
					item.y = paddingTop + (item.height + vgap) * currRow;

					currCol--;
				}
			}

		}


		/**
		 * 获得所有数据
		 * @return
		 */
		override public function getModel() : Array
		{
			return this.data as Array;
		}

		/**
		 * 每页需要的数据项
		 * @return
		 */
		override public function getEveryPageCount() : int
		{
			return cols * rows;
		}

	}
}
