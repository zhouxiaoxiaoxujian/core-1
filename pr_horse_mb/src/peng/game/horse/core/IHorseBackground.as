package peng.game.horse.core
{
	import flash.display.BitmapData;
	
	import cactus.common.frame.interfaces.IAutoScrollView;
	import cactus.common.frame.interfaces.IDisposeAble;

	public interface IHorseBackground extends IDisposeAble,IAutoScrollView
	{

		function init($srouceBmd:BitmapData=null):void

		/**
		 * 指定漂浮物的素材关联列表 
		 * @param param0
		 * 
		 */	
		function setFloatList(linkageList:Array):void

		/**
		 * 指定云彩的素材关联列表 
		 * @param param0
		 * 
		 */	
		function setCouldList(linkageList:Array):void

		/**
		 * 指定云条的素材关联列表 
		 */
		function setCloudNoddleList(linkageList:Array):void
			
		function setScrollSpeed($speedX:int=0, $speedY:int=0):void
			
		/**
		 * 向屏幕拉伸 
		 * @param screenW
		 * @param screenH
		 */
		function mapToScreen(originalScreenW:Number,originalScreenH:Number,screenW:Number, screenH:Number):void
	}
}
