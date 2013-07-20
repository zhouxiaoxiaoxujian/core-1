package cactus.ui.control
{
	import cactus.common.tools.util.ClassUtil;
	import cactus.ui.control.classical.PRectangle;
	
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;


	/**
	 * 具有滚动效果的单行TileList
	 * @author: Peng
	 */
	public class PTweenTileList extends PPageBase
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


		// 定位Renderer的信息
		public var paddingTop : Number;
		public var paddingLeft : Number;
		public var hgap : Number;
		public var vgap : Number;

		public var cols : int;
		public var rows : int; // @TBD 暂定只有一行
		public var rendererClass : Class;
		public var rendererClassParams : Array;

		// 可视区域遮罩
		private var _masker : PRectangle;

		// Renderer容器
		private var _itemHolder : Sprite;
		private var _children : Vector.<IPTileListRenderer>;
		private var _foreRenderers : Vector.<IPTileListRenderer>;
		private var _backRenderers : Vector.<IPTileListRenderer>;

		public function PTweenTileList($sourceName : String = null, $cols : int = 0, $rows : int = 1, $rendererClass : Class = null, $rendererClassParams : Array = null, $pTop : Number = 0, $pLeft : Number = 0, $hgap : Number = 0, $vgap : Number = 0)
		{
			cols = $cols;
			rows = $rows;
			rendererClass = $rendererClass;
			rendererClassParams = $rendererClassParams;
			paddingTop = $pTop;
			paddingLeft = $pLeft;
			hgap = $hgap;
			vgap = $vgap;
			
			if (!rendererClassParams)
			{
				rendererClassParams = new Array;
			}
			super($sourceName);
		}

		override public function init() : void
		{
			super.init();

			_children = new Vector.<IPTileListRenderer>;
			_foreRenderers = new Vector.<IPTileListRenderer>;
			_backRenderers = new Vector.<IPTileListRenderer>;

			if (btn_left1_PB)
				btn_left1_PB.addEventListener(MouseEvent.CLICK, on_btn_left1_click);
			if (btn_right1_PB)
				btn_right1_PB.addEventListener(MouseEvent.CLICK, on_btn_right1_click);

			if (btn_left1p_PB)
				btn_left1p_PB.addEventListener(MouseEvent.CLICK, on_btn_left1p_click);
			if (btn_right1p_PB)
				btn_right1p_PB.addEventListener(MouseEvent.CLICK, on_btn_right1p_click);

			if (btn_first_PB)
				btn_first_PB.addEventListener(MouseEvent.CLICK, on_btn_first_click);
			if (btn_last_PB)
				btn_last_PB.addEventListener(MouseEvent.CLICK, on_btn_last_click);


			// 根据素材中的滚动区域，动态添加Renderer
//			trace("----- 初始化一个TileList -----");
//			trace("viewport_PB x y widht height ", viewport_PB.x, viewport_PB.y, viewport_PB.width, viewport_PB.height)
//			trace("cols", cols);
//			trace("rows", rows);

			paddingLeft = viewport_PB.x + paddingLeft;
			paddingTop = viewport_PB.y + paddingTop;

//			trace("间距",paddingLeft,paddingTop);  

			draw();
		}

		override public function draw():void
		{
			addChildren();
			layout();
			
			if (_data)
			{
				this.data=_data;
			}
		}
		
		override public function destory() : void
		{
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
		public function setStandard($cols:int=0, $rows:int=0, $pLeft:Number=0, $pTop:Number=0, $hgap:Number=0, $vgap:Number=0):void
		{
			cols=$cols;
			rows=$rows;
			paddingTop=$pTop;
			paddingLeft=$pLeft;
			hgap=$hgap;
			vgap=$vgap;
			
			paddingLeft=viewport_PB.x + paddingLeft;
			paddingTop=viewport_PB.y + paddingTop;
			
			invalidate();
		}
		
		/**
		 * 设置渲染器
		 * @param $rendererClass
		 * @param $rendererClassParams
		 */
		public function setRenderer($rendererClass:Class=null, $rendererClassParams:Array=null):void
		{
			rendererClass=$rendererClass;
			rendererClassParams=$rendererClassParams;
			if (!rendererClassParams)
			{
				rendererClassParams=new Array;
			}
			invalidate();
		}
		
		
		/**
		 * 更新当前页的模型
		 */
		private function showPage() : void
		{
			var model : Array = getCurrPageModel();

			// 为前景Renderer赋值
			for each (var item : IPTileListRenderer in _foreRenderers)
				item.visible = false;

			for (var i : int = 0; i < model.length; i++)
			{
				// 以行优先的模型
				if (_foreRenderers.length >= (i + 1))
				{
					_foreRenderers[i].data = model[i];
					_foreRenderers[i].visible = true;
				}
			}

			afterShowPage();
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
			if (!_masker)
			{
				_masker =new PRectangle(viewport_PB.width, viewport_PB.height, 0x000000, 0xff0000, 0xffffff, false);
				_masker.x = viewport_PB.x;
				_masker.y = viewport_PB.y;
				addChild(_masker);
				viewport_PB.visible = false;
			}

			if (!_itemHolder)
			{
				_itemHolder = new Sprite();
				addChild(_itemHolder);
			}

			_children=new Vector.<IPTileListRenderer>;
			_foreRenderers = new Vector.<IPTileListRenderer>;
			_backRenderers = new Vector.<IPTileListRenderer>;
			while (_itemHolder.numChildren > 0)
			{
				_itemHolder.removeChildAt(0);
			}
			
			// 添加Renderer，比显示出的Renderer需要多出两列，左侧多一列，右侧也多一列
			var len : int = getEveryPageCount() * 2;
			for (var i : int = 0; i < len; i++)
			{
				var renderer:IPTileListRenderer = ClassUtil.construct(rendererClass,rendererClassParams);
				_itemHolder.addChild(DisplayObject(renderer));
				_children.push(renderer);
			}

			_itemHolder.mask = _masker;
		}

		private function layout() : void
		{
			// 排列前景中的Renderer
			var currRenderer : IPTileListRenderer;
			for (var i : int = 0; i < cols; i++)
			{
				currRenderer = _children.shift();
				currRenderer.x = paddingLeft + (currRenderer.width + hgap) * i;
				currRenderer.y = paddingTop;
				_foreRenderers.push(currRenderer);
			}

			// 将剩余的加入到背景Renderer
			for each (var render : IPTileListRenderer in _children)
			{
				render.visible = false;
				_backRenderers.push(render);
			}
		}


		/**
		 * 第一页
		 * @param event
		 */
		protected function on_btn_first_click(event : MouseEvent) : void
		{
			killAllTween();
			layoutBackRenderersTweenRight();
			firstPage();
			adjustForeAndBackTweenRight(getEveryPageCount());
			startTweenRight(getEveryPageCount())
		}

		/**
		 * 左移一个
		 * @param event
		 */
		protected function on_btn_left1_click(event : MouseEvent) : void
		{
			killAllTween();
			layoutBackRenderersTweenRight();
			prevItem();
			adjustForeAndBackTweenRight(1);
			startTweenRight(1)
		}

		/**
		 * 左移一页
		 * @param event
		 */
		protected function on_btn_left1p_click(event : MouseEvent) : void
		{
			killAllTween();
			layoutBackRenderersTweenRight();
			var scrollCount : int = getEveryPageCount();
			if (currIndex - getEveryPageCount() < 0)
				scrollCount = currIndex;
			prevPage();
			adjustForeAndBackTweenRight(scrollCount);
			startTweenRight(scrollCount)
		}

		/**
		 * 右移一个
		 * @param event
		 */
		protected function on_btn_right1_click(event : MouseEvent) : void
		{
			killAllTween();

			layoutBackRenderersTweenLeft();
			nextItem();
			adjustForeAndBackTweenLeft(1);
			startTweenLeft(1)
		}

		/**
		 * 右移一页
		 * @param event
		 */
		protected function on_btn_right1p_click(event : MouseEvent) : void
		{
			killAllTween();
			layoutBackRenderersTweenLeft();

			var scrollCount : int = getEveryPageCount();
			if (currIndex + getEveryPageCount() * 2 >= getModel().length)
				scrollCount = getModel().length - currIndex - getEveryPageCount();

			nextPage();
			adjustForeAndBackTweenLeft(scrollCount);
			startTweenLeft(scrollCount)
		}

		/**
		 * 右移到最后页
		 * @param event
		 */
		protected function on_btn_last_click(event : MouseEvent) : void
		{
			killAllTween();
			layoutBackRenderersTweenLeft();
			lastPage();
			adjustForeAndBackTweenLeft(getEveryPageCount());
			startTweenLeft(getEveryPageCount())
		}


		/**
		 * 结束所有缓动
		 */
		private function killAllTween() : void
		{
			var renderer : IPTileListRenderer;
			for each (renderer in _foreRenderers)
			{
				TweenLite.killTweensOf(renderer, true);
			}

			for each (renderer in _backRenderers)
			{
				TweenLite.killTweensOf(renderer, true);
			}
		}

		// ------------------------ 缓动相关 -----------------------------------

		/**
		 * [按下右箭头]将BackRenderer排列到列表右侧
		 */
		private function layoutBackRenderersTweenLeft() : void
		{
			// 布局
			var currRenderer : IPTileListRenderer;
			for (var i : int = 0; i < _backRenderers.length; i++)
			{
				currRenderer = _backRenderers[i];
				currRenderer.x = paddingLeft + (currRenderer.width + hgap) * (cols + i);
				currRenderer.y = paddingTop;
				currRenderer.visible = true;
			}

			// 赋值
			var model : Array = getNextPageModel();

			for (i = 0; i < model.length; i++)
			{
				_backRenderers[i].data = model[i];
				_backRenderers[i].visible = true;
			}
		}

		/**
		 * [按下左箭头]将BackRenderer排列到列表左侧
		 */
		private function layoutBackRenderersTweenRight() : void
		{
			// 布局
			var currRenderer : IPTileListRenderer;
			for (var i : int = 0; i < _backRenderers.length; i++)
			{
				currRenderer = _backRenderers[i];
				currRenderer.x = paddingLeft - (currRenderer.width + hgap) * (_backRenderers.length - i);
				currRenderer.y = paddingTop;
				currRenderer.visible = true;
			}

			// 赋值
			var model : Array = getPrevPageModel();

			for (i = 0; i < model.length; i++)
			{
				_backRenderers[i].data = model[i];
				_backRenderers[i].visible = true;
			}
		}

		/**
		 * [按下右箭头]调整背景和前景的Renderer,并改变当前下标
		 * @param count
		 */
		private function adjustForeAndBackTweenLeft(count : int) : void
		{
			for (var i : int = 0; i < count; i++)
			{
				_backRenderers.push(_foreRenderers.shift());
			}

			for (i = 0; i < count; i++)
			{
				_foreRenderers.push(_backRenderers.shift());
			}
		}

		/**
		 * [按下左箭头]调整背景和前景的Renderer,并改变当前下标
		 * @param count
		 */
		private function adjustForeAndBackTweenRight(count : int) : void
		{
			for (var i : int = 0; i < count; i++)
			{
				_backRenderers.unshift(_foreRenderers.pop());
			}

			for (i = 0; i < count; i++)
			{
				_foreRenderers.unshift(_backRenderers.pop());
			}
		}

		/**
		 * [按下右箭头]向左移一个的位置
		 * @param tileCount	需要移动的Tile宽度个数
		 */
		private function startTweenLeft(tileCount : int = 1) : void
		{
			var renderer : IPTileListRenderer;
			var destination : int;
			for each (renderer in _foreRenderers)
			{
				destination = renderer.x - (hgap + renderer.width) * tileCount;
				TweenLite.to(renderer, .5, {x: destination, onStart: tweenStart, onComplete: tweenComplete});
			}

			for each (renderer in _backRenderers)
			{
				destination = renderer.x - (hgap + renderer.width) * tileCount;
				TweenLite.to(renderer, .5, {x: destination, onStart: tweenStart, onComplete: tweenComplete});
			}
		}

		/**
		 * [按下左箭头]向左移一个的位置
		 * @param tileCount	需要移动的Tile宽度个数
		 */
		private function startTweenRight(tileCount : int = 1) : void
		{
			var renderer : IPTileListRenderer;
			var destination : int;
			for each (renderer in _foreRenderers)
			{
				destination = renderer.x + (hgap + renderer.width) * tileCount;
				TweenLite.to(renderer, .5, {x: destination, onStart: tweenStart, onComplete: tweenComplete});
			}

			for each (renderer in _backRenderers)
			{
				destination = renderer.x + (hgap + renderer.width) * tileCount;
				TweenLite.to(renderer, .5, {x: destination, onStart: tweenStart, onComplete: tweenComplete});
			}
		}

		private var tweenIndex : int = 0;

		private function tweenStart() : void
		{
			tweenIndex++;
		}

		/**
		 * 一次缓动结束
		 */
		private function tweenComplete() : void
		{
//			tweenIndex++;
//			if (tweenIndex >= getEveryPageCount() * 2)
			tweenIndex--;
			if (tweenIndex == 0)
			{
				showPage();

				// 隐藏BackRenderers
				for each (var renderer : IPTileListRenderer in _backRenderers)
				{
					renderer.visible = false;
				}
				tweenIndex = 0;
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
			return cols;
		}
	}
}
