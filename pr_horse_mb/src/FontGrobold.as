package
{
	import flash.display.Sprite;
	import flash.text.Font;

	/**
	 * GroBold字体
	 * @author Peng
	 */
	public class FontGrobold extends Sprite
	{
		[Embed(source = "asset/GROBOLD.ttf", fontName = "grobold", mimeType = "application/x-font", embedAsCFF = "false")]
		public static const GRO_BOLD_FONT_EMBED:Class;

		public function FontGrobold()
		{
			Font.registerFont(GRO_BOLD_FONT_EMBED);
		}
	}
}
