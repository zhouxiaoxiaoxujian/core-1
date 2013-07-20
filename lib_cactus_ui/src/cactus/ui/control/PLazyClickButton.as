package cactus.ui.control
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * 点击一次之后变成不可用，即enable=false
	 * 过一定的时间后，再使enable=true 
	 * @author supperhpxd
	 */
	public class PLazyClickButton extends PButton
	{
		/**
		 * 延迟的时间
		 * @default 
		 */
		private var _lazyTime:Number;
		
		public function PLazyClickButton(mc:MovieClip=null,$lazyTime:Number=500)
		{
			super(mc);
			_lazyTime = $lazyTime;
		}
		
		/**
		 * 当本按钮按下，优先级最高的点击事件 
		 * @param event
		 */
		override protected function onThisFirstClick(event : MouseEvent) : void
		{
			super.onThisFirstClick(event);
			
//			this.enabled = false;
//			var timeout:uint = setTimeout( function():void
//			{
//				// 这里千万不要用this
//				enabled = true;
//				clearTimeout(timeout);
//			},_lazyTime);
		}
	}
}