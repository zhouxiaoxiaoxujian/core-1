package cactus.ui.control
{
	import cactus.ui.base.BasePopupPanel;
	import cactus.ui.control.*;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * 普通弹窗
	 * @author Peng
	 */
	public class PCommonAlert_POP extends BasePopupPanel
	{

		public const BUTTON_FLAG_OK:int = 1;
		public const BUTTON_FLAG_YES_AND_NO:int = 1 << 1;

		public var btn_ok_PB:PButton;
		public var btn_no_PB:PButton;
		public var btn_yes_PB:PButton;
		public var txt_title_PB:TextField;

		/** 标题*/
		protected var title:String;
		/** 按钮类型*/
		protected var buttonFlag:int;
		/** 回调方法数组*/
		protected var callbackFunctions:Array;
		/** 按钮标签数组*/
		protected var buttonLabels:Array;


		protected var _okCallback:Function;
		protected var _yesCallback:Function;
		protected var _noCallback:Function;

		protected var _okLabel:String;
		protected var _yesLabel:String;
		protected var _noLabel:String;

		public function PCommonAlert_POP()
		{
			super("PCommonAlert_POP");
		}

		override public function init():void
		{
			super.init();
			btn_ok_PB.addEventListener(MouseEvent.CLICK, btn_okClick);
			btn_no_PB.addEventListener(MouseEvent.CLICK, btn_noClick);
			btn_yes_PB.addEventListener(MouseEvent.CLICK, btn_yesClick);

			title = _params[0];
			buttonFlag = _params[1];
			callbackFunctions = _params[2];
			buttonLabels = _params[3];

			txt_title_PB.text = title;

			if (buttonFlag == BUTTON_FLAG_OK)
			{
				btn_ok_PB.visible = true;
				btn_no_PB.visible = btn_yes_PB.visible = false;
			}
			else if (buttonFlag == BUTTON_FLAG_YES_AND_NO)
			{
				btn_ok_PB.visible = false;
				btn_no_PB.visible = btn_yes_PB.visible = true;
			}
			else
			{
				trace("错误的buttonFlag", buttonFlag);
			}

			if (callbackFunctions.length == 1)
			{
				_okCallback = _yesCallback = callbackFunctions[0];
			}
			else if (callbackFunctions.length == 2)
			{
				_okCallback = _yesCallback = callbackFunctions[0];
				_noCallback = callbackFunctions[1];
			}
			else
			{
				trace("没有按钮回调");
			}

			if (buttonLabels.length == 1)
			{
				btn_ok_PB.setLabel(buttonLabels[0].toString());
				btn_yes_PB.setLabel(buttonLabels[0].toString());
			}
			else if (buttonLabels.length == 2)
			{
				btn_ok_PB.setLabel(buttonLabels[0].toString());
				btn_yes_PB.setLabel(buttonLabels[0].toString());
				btn_no_PB.setLabel(buttonLabels[1].toString());
			}
			else
			{
				trace("没有按钮标签");
			}
		}

		override public function destory():void
		{
			super.destory();
			btn_ok_PB.removeEventListener(MouseEvent.CLICK, btn_okClick);
			btn_no_PB.removeEventListener(MouseEvent.CLICK, btn_noClick);
			btn_yes_PB.removeEventListener(MouseEvent.CLICK, btn_yesClick);
		}

		override public function fireDataChange():void
		{
			super.fireDataChange();
		}

		private function btn_okClick(evt:MouseEvent):void
		{
			if (_okCallback != null)
			{
				_okCallback();
			}
			close();
		}

		private function btn_noClick(evt:MouseEvent):void
		{
			if (_noCallback != null)
			{
				_noCallback();
			}
			close();
		}

		private function btn_yesClick(evt:MouseEvent):void
		{
			if (_yesCallback != null)
			{
				_yesCallback();
			}
			close();
		}
		
		override public function showIn() : void
		{
			super.drawInnerMask(0xFFFFFF,0);
			this.visible = true;
			this.scaleX = 0.8;
			this.scaleY = 0.8;
			this.alpha = 0;
			TweenLite.to(this , 0.75 , {scaleX: 1 , scaleY: 1 , alpha: 1 , ease: Elastic.easeOut , easeParams: [0.5 , 0.6] , onComplete: onShowIned});
			
		}
		
		override public function showOut() : void
		{
			TweenLite.to(this , .5 , {scaleX: 0.8 , scaleY: 0.8 , alpha: 0 , onComplete: onShowOuted});
		}
	}
}
