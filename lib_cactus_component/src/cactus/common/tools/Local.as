package cactus.common.tools
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	
	import cactus.common.control.Language;

	/**
	 * 语言改变时
	 */
	[Event(name = "languageChanged", type = "flash.events.Event")]
	public class Local
	{
		public static const EN_US:String = "en";
		public static const ZH_TW:String = "zh-TW";
		public static const ZH_CN:String = "zh-CN";

		private static var eventDispatcher:EventDispatcher;

		private static var _dictionary:Dictionary = new Dictionary();
		private static var _currLanguage:String = Capabilities.language;
		private static var _currentLanguageObj:Language;

		// 多语言配置
		private static var _languages:Dictionary = new Dictionary;
		private static var _languagesAndButton:Dictionary = new Dictionary;

		public static const LANGUAGE_CHANGED:String = "languageChanged";


		public function Local()
		{
			super();
		}

		/**
		 * 初始化语言设置
		 * 在使用通用 LanguageSelectBox之前必须初始化
		 * 
		 * 有可能初始化了多次
		 */
		public static function init():void
		{
			_languages = new Dictionary;
			
			var lang1:Language = new Language();
			lang1.name = "zh-CN";
			lang1.resFrame = 5;
			lang1.fontName = "";
			lang1.userEmbed = false;
			_languages[lang1.name] = lang1;

			var lang2:Language = new Language();
			lang2.name = "zh-TW";
			lang2.resFrame = 0;
			lang2.fontName = "";
			lang2.userEmbed = false;
			_languages[lang2.name] = lang2;

			var lang3:Language = new Language();
			lang3.name = "en";
			lang3.resFrame = 21;
			lang3.fontName = "";
			lang3.userEmbed = false;
			_languages[lang3.name] = lang3;

			// 匹配语言名 和 国际化按钮的实例名
			_languagesAndButton["l_zh_CN"] = "zh-CN";
			_languagesAndButton["l_zh_TW"] = "zh-TW";
			_languagesAndButton["l_en"] = "en";


			// 默认语言
			_currentLanguageObj = _languages[_currLanguage];
		}


		//-----------------------------------------------------------------------------
		// Event Dispatcher API
		//-----------------------------------------------------------------------------

		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			if (!eventDispatcher)
				eventDispatcher = new EventDispatcher();
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			if (!eventDispatcher)
				eventDispatcher = new EventDispatcher();
			eventDispatcher.removeEventListener(type, listener, useCapture);
		}

		public static function dispatchEvent(event:Event):void
		{
			if (!eventDispatcher)
				eventDispatcher = new EventDispatcher();
			eventDispatcher.dispatchEvent(event);
		}



		/**
		 * 一次性加载多语言文件
		 * @param xml
		 */
		public static function parseXML(xml:XML):void
		{
			init();

//			if (xml)
//			{
//				var lang:XML;
//				for each (lang in xml..lang.(@name == _currLanguage)..text)
//				{
//					setString(String(lang.@label), lang.toString());
//				}
//			}


			if (xml)
			{
				var lang:XML;
				for each (var langObj:Language in _languages)
				{
					for each (lang in xml..lang.(@name == langObj.name)..text)
					{
						setStringByLang(langObj.name, String(lang.@label), lang.toString());
					}
				}
			}
		}

		/**
		 * 为某种语言设定特殊字体
		 * @param langName
		 * @param fontName
		 */
		public static function setFont(langName:String, fontName:String):void
		{
			(_languages[langName] as Language).fontName = fontName;
		}

		/**
		 * 根据按钮选择框的名称获得语言信息
		 * @return
		 */
		public static function getLanguageByBtnName(languageSelectBoxButtonName:String):Language
		{
			return getLanguageByName(_languagesAndButton[languageSelectBoxButtonName]);
		}

		public static function getLanguageByName(name:String):Language
		{
			return _languages[name] as Language;
		}

		public static function changeLanguage(languageSelectBoxButtonName:String):void
		{
			var newLanguage:Language = getLanguageByBtnName(languageSelectBoxButtonName);
			if (!newLanguage)
			{
				trace("找不到语言配置", newLanguage);
				return;
			}
			else
			{
				currentLanguageObj = newLanguage;
			}

//			TextFieldFit.embedFonts = currentLanguage.embedFonts;
//			TextFieldFit.forceFont = currentLanguage.forceFont;

			trace("切换到语言", currentLanguageObj.name);
			dispatchEvent(new Event(LANGUAGE_CHANGED));
		}

		public static function get currentLanguageObj():Language
		{
			return _currentLanguageObj;
		}

		public static function set currentLanguageObj(value:Language):void
		{
			_currentLanguageObj = value;
			currLanguage = value.name;
		}

		/**
		 *根据key获取语言包
		 * @param key
		 * @return
		 *
		 */
		public static function getString(key:String):String
		{
			return getStringByLang(key);
		}

		/**
		 * 根据语言包设置语言
		 * @param key
		 * @param language
		 * @param value
		 *
		 */
		public static function setString(key:String, value:String):void
		{
			_dictionary[currLanguage] = _dictionary[currLanguage] || new Dictionary();
			_dictionary[currLanguage][key] = value;
		}

		/**
		 * 根据语言包设置语言
		 * @param name		语言名
		 * @param param1	key
		 * @param param2	value
		 */
		public static function setStringByLang(langName:String, key:String, value:String):void
		{
			_dictionary[langName] = _dictionary[langName] || new Dictionary();
			_dictionary[langName][key] = value;
		}

		/**
		 *根据语言包返回语言
		 * @param name
		 * @param language
		 * @return
		 *
		 */
		public static function getStringByLang(key:String):String
		{
			var word:String = _dictionary[currLanguage][key] || key;
			return convertKeyWord(word, "#n#", "\n");
		}


		public static function convertKeyWord(word:String, key:String, convertTo:String):String
		{
			var myPattern:RegExp = new RegExp(key, "g");
			return word.replace(myPattern, convertTo);
		}

		public static function get currLanguage():String
		{
			return _currLanguage;
		}

		public static function set currLanguage(value:String):void
		{
			_currLanguage = value;
		}


	}
}
