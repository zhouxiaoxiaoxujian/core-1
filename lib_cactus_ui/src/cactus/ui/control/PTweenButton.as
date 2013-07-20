package cactus.ui.control
{

	import cactus.ui.bind.PAutoView;
	import cactus.ui.events.ViewEvent;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;

	/**
	 * Tween实现的动画按钮
	 * @author: Peng
	 */
	public class PTweenButton extends PAutoView implements IPGroupItem
	{
		// 主文本框
		public var txt_label_PB:TextField;

		// 按钮背景
		public var mmc_bg_PB:MovieClip;
		
		
		
		
		private var _enable:Boolean=true;

		private var _isNormal:Boolean;
		private var _isEnlarge:Boolean;
		private var _isSelect:Boolean;

		// 状态标记
		public function PTweenButton($sourceName:String=null)
		{
			super($sourceName);
		}

		// ====================================================
		// =================	public 	=======================
		// ====================================================

		override public function init():void
		{
			super.init();
			this.buttonMode=true;

			addEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverListener);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutListener);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			addEventListener(MouseEvent.CLICK, onMouseClick, false, int.MAX_VALUE);
		}

		override public function destory():void
		{
			super.destory();
			removeEventListener(MouseEvent.CLICK, onMouseClick);
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOutListener);
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOverListener);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
		}

		/**
		 *
		 * @param param0
		 */
		public function setText(param0:String):void
		{
			txt_label_PB.text=param0;

			updateButtonSize();
		}

		public function get isEnlarge():Boolean
		{
			return _isEnlarge;
		}

		public function set isEnlarge(value:Boolean):void
		{
			_isEnlarge=value;

			if (value == true)
			{
				_isNormal=false;
			}
		}

		public function get isNormal():Boolean
		{

			return _isNormal;
		}

		public function set isNormal(value:Boolean):void
		{
			_isNormal=value;

			if (value == true)
			{
				_isEnlarge=false;
			}
		}

		/**
		 * 选中状态
		 */
		public function set selected(value:Boolean):void
		{
			if (_isSelect == value)
				return;

			_isSelect=value;

			if (value == true)
			{
				selectTween();
			}
			else
			{
				deSelectTween();
			}
		}

		/**
		 * 选中状态
		 */
		public function get selected():Boolean
		{
			return _isSelect;
		}

		/**
		 * 是否启用
		 */
		public override function set enabled(value:Boolean):void
		{
			//			if ( _enable == value)
			//				return;

			_enable=value;

			if (value == true)
			{
				enableTween();
			}
			else
			{
				disableTween();
			}
		}

		/**
		 * 是否启用
		 */
		public override function get enabled():Boolean
		{
			return _enable;
		}

		// ===========================================================
		// =================   protected 	   =======================
		// ===========================================================

		protected function enlargeTween():void
		{
			TweenLite.to(this, .5, {scaleX: 1.1, scaleY: 1.1, ease: Back.easeOut});
		}

		protected function normalTween():void
		{
			TweenLite.to(this, .5, {scaleX: 1, scaleY: 1, ease: Back.easeOut});
		}

		protected function selectTween():void
		{
			TweenLite.to(this, 0, {scaleX: 1.1, scaleY: 1.1, ease: Back.easeOut});
		}

		protected function deSelectTween():void
		{
			TweenLite.to(this, 0, {scaleX: 1, scaleY: 1, ease: Back.easeOut});
		}

		protected function enableTween():void
		{
			TweenLite.to(this, 0, {scaleX: 1, scaleY: 1, ease: Back.easeOut});
			this.filters=null;
		}

		protected function disableTween():void
		{
			TweenLite.to(this, 0, {scaleX: 1, scaleY: 1, ease: Back.easeOut});
			this.filters=GRAY_FILTER;

		}

		protected function mouseDownListener(event:MouseEvent):void
		{
			if (selected || !_enable)
				return;

			normalTween();
			isNormal=true;
		}

		protected function mouseOutListener(event:MouseEvent):void
		{
			if (selected || !_enable)
				return;

			normalTween();
			isNormal=true;
		}

		protected function mouseOverListener(event:MouseEvent):void
		{
			if (selected || !_enable)
				return;

			if (!isEnlarge)
			{
				enlargeTween();
				isEnlarge=true;
			}
		}

		protected function mouseUpListener(event:MouseEvent):void
		{
			if (selected || !_enable)
				return;

			normalTween();
			isNormal=true;
		}

		protected function onMouseClick(event:MouseEvent):void
		{
			if (_enable == false)
			{
				event.stopImmediatePropagation();
				return;
			}
			dispatchEvent(new ViewEvent(ViewEvent.GROUP_ITEM_SELECT));
		}

		/**
		 * 灰度滤镜
		 * @default
		 */
		private const GRAY_FILTER:Array=[new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
		
		

		private function updateButtonSize():void
		{
//			var txtWidth:Number = txt_label_PB.textWidth;
//			
//			txt_label_PB.width = txtWidth + 30;
////			txt_label_PB.x = 0;
////			txt_label_PB.y = 0;
//			
//			mmc_bg_PB.width = txtWidth + 40;
////			mmc_bg_PB.x = 0;
////			mmc_bg_PB.y = 0;
//			
////			this.width = txtWidth + 40;
//			trace("txt_label_PB.textWidth",txt_label_PB.textWidth);
		}

	}
}
