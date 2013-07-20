package cactus.ui.control
{
	import flash.events.Event;
	import flash.text.TextField;
	
	import cactus.common.tools.Local;
	import cactus.ui.bind.PReflectUtil;
	
	/**
	 * 不能产品级使用
	 * 试验中。。。 
	 * @author Peng
	 */
	public class CTextField extends TextField
	{
		private var _originalText:String;
		private var _sourceField:TextField;
		
		public function CTextField($sourceField:TextField = null)
		{
			if ($sourceField)
			{
				sourceField = $sourceField;
				Local.addEventListener(Local.LANGUAGE_CHANGED, onLanguageChanged);
			}
			
			super();
		}
		
		public function destory():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addStageEvent);
			Local.removeEventListener(Local.LANGUAGE_CHANGED, onLanguageChanged);
		}
		
		public function set sourceField(value:TextField):void
		{
			_sourceField = value;
			
			initThis();
		}
		
		public function get sourceField():TextField
		{
			return _sourceField;
		}
		
		override public function set text(value:String):void
		{
			_originalText = value;
			
			super.text = value.replace(regex, replaceFn);
			
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
			// 反射全部属性
			var propertyNames:Array = PReflectUtil.getPropertyNames(_sourceField, PReflectUtil.WRITEONLY_ACCESSORS);
			for each (var property:String in propertyNames) 
			{
				trace("property",property);
				this[property] = _sourceField[property];
				
			}
			
			//			this.alwaysShowSelection = _sourceField.alwaysShowSelection;
			//			this.antiAliasType =  _sourceField.antiAliasType;
			//			this.autoSize =  _sourceField.autoSize;
			//			this.background =  _sourceField.background;
			//			this.backgroundColor =  _sourceField.backgroundColor;
			//			this.border =  _sourceField.border;
			//			this.borderColor =  _sourceField.borderColor;
			//			this.defaultTextFormat =  _sourceField.defaultTextFormat;
			//			
			//			this.width = _sourceField.width;
			//			this.height = _sourceField.height;
			//			this.filters = _sourceField.filters;
			//			this.name = _sourceField.name;
			this.setTextFormat(_sourceField.getTextFormat());
			
			
			
			
			
			
			
			
			
			this.addEventListener(Event.ADDED_TO_STAGE, addStageEvent)
			this.addEventListener(Event.REMOVED_FROM_STAGE, removeStageEvent);
		}
		
		protected function addStageEvent(e:Event):void
		{
			//			_sourceField.x = 0
			//			_sourceField.y = 0;
			//			addChild(_sourceField)
		}
		
		protected function removeStageEvent(evt:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removeStageEvent);
			destory();
		}
	}
}