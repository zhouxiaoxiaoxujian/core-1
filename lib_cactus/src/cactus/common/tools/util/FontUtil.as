package cactus.common.tools.util
{
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 *
	 * @author Peng
	 */
	public class FontUtil
	{
		public function FontUtil()
		{
		}

		/**
		 * 
		 * @param txt 		指定的textField
		 * @param fontName	字体名
		 */
		public static function setFont(txt:TextField, fontName:String):void
		{
			var format:TextFormat = txt.getTextFormat();
			format.font = fontName;
			
			txt.embedFonts = true;
//			txt.autoSize=TextFieldAutoSize.LEFT;		
//			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.defaultTextFormat = format;
			txt.setTextFormat(format);
			
		}


	}
}
