
package cactus.ui.base
{
	import cactus.ui.bind.PView;
	import cactus.ui.events.ViewEvent;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Elastic;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * 弹窗基类
	 * @author Pengx
	 * @version 1.0
	 * @created 03-八月-2010 14:19:08
	 */
	public class BasePopupPanel extends PView
	{
		protected var _makerLayer:Sprite;

		public function BasePopupPanel($source:*=null)
		{
			super($source);
		}

		
		/**
		 * 本弹窗是否具有黑色Mask
		 */
		public function hasMask():Boolean
		{
			return true;
		}
		
		override public function showIn():void
		{
			// 默认不要绘制innerMask,因为幕布是属于弹窗管理器的
			this.visible = true;
			this.scaleX = 0.9;
			this.scaleY = 0.9;
			this.alpha = 0.2;
			//			//			TweenLite.to(this, .5, {scaleX: 1, scaleY: 1, alpha: 1, /*ease: Elastic.easeOut, easeParams: [0.5, 0.6], */onComplete: onShowIned});
			TweenLite.to(this, .25, { scaleX: 1, scaleY: 1, alpha: 1, ease:Circ.easeIn,onComplete: onShowIned });
			//			onShowIned();
		}

		override public function showOut():void
		{
			//			onShowOuted();
			TweenLite.to(this, .25, { scaleX: 0.9, scaleY: 0.9, alpha: 0.2, ease:Circ.easeIn,onComplete: onShowOuted });
		}

		/**
		 * 不建议使用！
		 * 遮罩不应该被绘制于弹窗内部，而是在PopUpManager中
		 * PMenu组件可以考虑使用
		 */
		protected function drawInnerMask($color:uint=0x000000, $alpha:Number=0.6):void
		{
			if (!_makerLayer)
			{
				_makerLayer = new Sprite;
				_makerLayer.mouseEnabled = true;
				_makerLayer.mouseChildren = false;
				_makerLayer.cacheAsBitmap = true;
				addChildAt(_makerLayer, 0);

				var g:Graphics=_makerLayer.graphics;
				g.beginFill($color, $alpha);
				// 我靠，差点被害死
				g.drawRect(-400, -400, 800, 800);
				g.endFill();
			}
		}

		override protected function onAllReady():void
		{
			super.onAllReady();
			this.addEventListener(Event.CLOSE, closeThis);
		}

		public function close():void
		{
			this.dispatchEvent(new Event(Event.CLOSE));
		}

		protected function closeThis(event:Event):void
		{
			showOut();
			this.graphics.clear();
		}

		override public function destory():void
		{
			if (_makerLayer)
				_makerLayer.graphics.clear();
			this.removeEventListener(Event.CLOSE, closeThis);
			super.destory();
		}

		override protected function onShowOuted():void
		{
			super.onShowOuted();

			// 特效结束，从父节点删除
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
		}

	} //end BasePopupPanel

}