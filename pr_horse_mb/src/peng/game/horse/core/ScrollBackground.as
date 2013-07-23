package peng.game.horse.core
{
	import cactus.common.Global;
	import cactus.common.frame.interfaces.IAutoScrollView;
	import cactus.ui.base.BaseView;
	
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 滚动背景
	 * @author Peng
	 */
	public class ScrollBackground extends BaseView implements IAutoScrollView
	{
		// 源位图数据
		private var bgData:BitmapData;
		private var bgBitmap:Bitmap;

		// 源位图数据的宽，高
		private var W:Number;
		private var H:Number;

		// 屏幕显示区域的宽，高
		private var w:Number;
		private var h:Number;

		// 绘制背景的目标位图区域
		private var drawBmd:BitmapData;

		// 滚动的速度
		protected var _spx:Number = 0;
		protected var _spy:Number = 0;

		// x，y当前滚动的位置
		protected var _currX:Number = 0;
		protected var _currY:Number = 0;

		// 宽，高差
		private var _deltaW:Number = 0;
		private var _deltaH:Number = 0;

		/**
		 *
		 * @param $target 绘制背景的目标对象
		 */
		public function ScrollBackground()
		{
			// 初始化位图区域
			drawBmd = new BitmapData(Global.screenW, Global.screenH);
			super(false);
		}

		public function init($sourceBmd:BitmapData = null):void
		{
			if ($sourceBmd)
			{
				bgData = $sourceBmd;

				W = bgData.width;
				H = bgData.height;

				w = Global.screenW;
				h = Global.screenH;

				_deltaW = W - w;
				_deltaH = H - h;

				bgBitmap = new Bitmap(drawBmd);
				bgBitmap.bitmapData = bgData;
				// TODO 
//				StManager.addBitmapData(this.name,drawBmd);
				addChild(bgBitmap);
			}
		}

		override public function destory():void
		{
			for each (var bg:ScrollBackground in _children)
			{
				bg.destory();
			}
			while (numChildren > 0)
			{
				removeChildAt(0);
			}
			_children = new Vector.<ScrollBackground>;
		}

		/**
		 * 向屏幕拉伸
		 * @param screenW
		 * @param screenH
		 */
		public function mapToScreen(originalScreenW:Number, originalScreenH:Number, screenW:Number, screenH:Number):void
		{
			var xScale:Number = screenW / originalScreenW;
			var yScale:Number = screenH / originalScreenH;

			// @Warning:
			// 如果 源位图的宽度和高度 都大于屏幕宽高，则什么都不用做
			// 否则 将改变bgBitmap的scale
			if (W >= screenW && H >= screenH)
			{

			}
			else
			{
				bgBitmap.scaleX = xScale;
				bgBitmap.scaleY = yScale;
			}
		}

		/**
		 * 设置图像滚动速度
		 * @param $speedX
		 * @param $speedY
		 */
		public function setScrollSpeed($speedX:int = 0, $speedY:int = 0):void
		{
			_spx = $speedX;
			_spy = $speedY;
		}

		/**
		 * 设置偏移
		 * @param offsetX
		 * @param offsetY
		 */
		public function setOffset(offsetX:Number, offsetY:Number):void
		{
			bgBitmap.x = offsetX;
			bgBitmap.y = offsetY;
		}

		public function update(delay:int):void
		{
			updateChildren(delay);


			// 绘制滚动位图区域
			if (_spx == 0 && _spy == 0)
			{
				// do nothing
			}
			else
			{
				if (bgData)
				{
					_currX += _spx;
					_currY += _spy;

					// 余数
					var mx:int = _currX % W;
					var my:int = _currY * H;

					// 无需左右拼接的位图
					if (mx >= 0 && mx <= _deltaW)
					{
						drawBmd.copyPixels(bgData, new Rectangle(mx, 0, w, h), new Point(0, 0));
					}
					else
					{
						var remainX:Number = W - mx;
						drawBmd.copyPixels(bgData, new Rectangle(mx, 0, remainX, h), new Point(0, 0));

						// 右部分
						drawBmd.copyPixels(bgData, new Rectangle(0, 0, w - remainX, h), new Point(remainX, 0));
					}

					// TODO
					bgBitmap.bitmapData = drawBmd;
//					StManager.updateBitmapData(this.name,drawBmd);
				}
			}
		}

		/**
		 * 更新孩子结点
		 * @param delay
		 */
		private function updateChildren(delay:int):void
		{
			for each (var bg:ScrollBackground in children)
			{
				bg.update(delay);
			}
		}

		private var _children:Vector.<ScrollBackground>;

		/**
		 * 添加孩子背景
		 */
		public function addSubBg(child:ScrollBackground):void
		{
			children.push(child);
			addChild(child)
		}

		public function get children():Vector.<ScrollBackground>
		{
			if (!_children)
			{
				_children = new Vector.<ScrollBackground>;
			}
			return _children;
		}


		private const startAlpha:Number = 1;
		private const tweenTime:Number = 0;

		override public function showIn():void
		{
			this.visible = true;
			this.alpha = startAlpha;
			TweenLite.to(this, tweenTime, {alpha: 1, onComplete: onShowIned});
		}

		override public function showOut():void
		{
			TweenLite.to(this, tweenTime, {alpha: startAlpha, onComplete: onShowOuted});
		}

	}
}
