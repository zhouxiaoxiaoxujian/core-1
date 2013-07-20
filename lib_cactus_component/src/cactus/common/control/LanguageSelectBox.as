package cactus.common.control
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	import cactus.common.tools.Local;

	/**
	 * 语言选择框
	 * @author Peng
	 */
	public class LanguageSelectBox extends MovieClip
	{
		public static const DIR_UP:String = "up";
		public static const DIR_DOWN:String = "down";

		private var _dir:String;

		/**
		 * 弹出框
		 * @default
		 */
		private var popup:MovieClip;

		/**
		 * 语言选择的按钮组
		 * @default
		 */
		private var btnArray:Array;

		private var _oldHeight:Number;

		public function LanguageSelectBox()
		{
			super();

			_oldHeight = this.height;
			Local.init();

			addEventListener(MouseEvent.ROLL_OVER, mouseOver, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, mouseOut, false, 0, true);

			// 语言选择框的弹出菜单
			popup = new LanguagePopup;
			popup.visible = false;
			addChild(popup);

			// 为popup里的每一个按钮添加点击监听
			btnArray = new Array(popup.l_zh_CN, popup.l_en);

			// 为每一个语言按钮添加监听
			for (var i:int = 0; i < btnArray.length; i++)
			{
				var btn:MovieClip = MovieClip(btnArray[i]);
				if (btn)
				{
					var lang:Language = Local.getLanguageByBtnName(btn.name);

					btn.addEventListener(MouseEvent.CLICK, itemClicked, true, 0, true);
					btn.flag.mouseEnabled = false;
					btn.flag.gotoAndStop(lang.resFrame);
				}
				else
				{
					trace("多语言选择框中不存在语言按钮" + btnArray[i]);
				}
			}

			dir = DIR_UP;

			// 默认的语言
			this["currFlag"].gotoAndStop(Local.currentLanguageObj.resFrame);
		}

		public function destory():void
		{

		}

		private function itemClicked(e:MouseEvent):void
		{
			var languageSelectBoxButtonName:String = e.currentTarget.name;

			Local.changeLanguage(languageSelectBoxButtonName);
			popup.visible = false;

			this["currFlag"].gotoAndStop(Local.currentLanguageObj.resFrame);
		}

		public function get dir():String
		{
			return _dir;
		}

		public function set dir(value:String):void
		{
			_dir = value;

			if (value == DIR_DOWN)
			{
				popup.y = Math.floor(_oldHeight);
			}
			else
			{
				popup.y = -Math.floor(popup.height) + 1;
			}
		}

		private function mouseOver(e:MouseEvent):void
		{
			popup.visible = true;
		}

		private function mouseOut(e:MouseEvent):void
		{
			popup.visible = false;
		}
	}
}
