package cactus.ui.control
{
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.text.Font;
	import flash.text.FontStyle;
	import flash.text.TextField;

	import cactus.common.tools.Local;
	import cactus.ui.bind.IPView;
	import cactus.ui.bind.PAutoView;

	/**
	 * 多语言文本框
	 * @author Peng
	 */
	public class PTextField extends PAutoView
	{
		private var _originalText:String;
		private var _sourceField:TextField;

		public function PTextField()
		{
			super();

			Local.addEventListener(Local.LANGUAGE_CHANGED, onLanguageChanged);
		}

		override public function destory():void
		{
			super.destory();
			this.removeEventListener(Event.ADDED_TO_STAGE, addStageEvent);
			Local.removeEventListener(Local.LANGUAGE_CHANGED, onLanguageChanged);
		}

		public function get sourceField():TextField
		{
			return _sourceField;
		}

		public function set sourceField(value:TextField):void
		{
			_sourceField = value;

			initThis();
		}

		public function set text(value:String):void
		{
			_originalText = value;

			sourceField.text = value.replace(regex, replaceFn);

			updateProperty();
		}

		// 正则替换符,文字的key
		protected var regex:RegExp = /{([^{}]*)}/g

		// 替换文字
		protected function replaceFn():String
		{
			var str:String = Local.getString(arguments[1]);
			if (!str || str == "")
			{
				return "{" + arguments[1] + "}";
			}
			else
			{
				return str;
			}
		}

		protected function onLanguageChanged(event:Event):void
		{
			text = _originalText;
		}

		protected function updateProperty():void
		{
//			trace("-------------------------------")
//			trace("sourceField.name", sourceField.name);
//			trace("sourceField.embedFonts", sourceField.embedFonts);
//			trace("sourceField.getTextFormat().font", sourceField.getTextFormat().font);
//			trace("TextField.isFontCompatible", TextField.isFontCompatible("GROBOLD", FontStyle.REGULAR));

//			for each (var f:Font in Font.enumerateFonts(true))
//			{
//				trace(f.fontName, f.fontStyle);
//			}
		}

		protected function initThis():void 
		{
			this.name = _sourceField.name;
			this.addEventListener(Event.ADDED_TO_STAGE, addStageEvent)
//			this.addEventListener(Event.REMOVED_FROM_STAGE, removeStageEvent)
		}

		protected function addStageEvent(e:Event):void
		{
			_sourceField.x = 0;
			_sourceField.y = 0;
			_sourceField.selectable = false;
			addChild(_sourceField);
		}

	/*		protected function removeStageEvent(evt:Event):void
			{
				this.removeEventListener(Event.REMOVED_FROM_STAGE, removeStageEvent);
				destory();
			}*/

	}
}
