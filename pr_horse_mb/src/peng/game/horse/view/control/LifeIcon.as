package peng.game.horse.view.control
{
	import cactus.ui.bind.PAutoView;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	
	public class LifeIcon extends PAutoView
	{
		
		/**
		 * 是否为点亮状态
		 */ 
		private var _isLighten:Boolean = true;
		
		public function LifeIcon($sourceName:String=null)
		{
			super($sourceName);
		}
		
		public function get isLighten():Boolean
		{
			return _isLighten;
		}

		public function set isLighten(value:Boolean):void
		{
			_isLighten = value;
		}

		/**
		 * 点亮 
		 */ 
		public function add():void
		{
			this.alpha = 0;
			var toX:int=this.x;
			var toY:int=this.y;
			
			this.y -= 50;
			
			TweenLite.to(this, 1, {y: toY,alpha:1,ease: Elastic.easeOut, easeParams: [0.2, 0.6]});
		}
		
		/**
		 * 熄灭
		 */
		public function remove():void
		{
			this.alpha = 1;
			var toX:int=this.x;
			var toY:int=this.y;
//			
			this.y += 50;
			
			TweenLite.to(this, 1, {y: toX,alpha:0,ease: Elastic.easeOut, easeParams: [0.2, 0.6]});
		}
	}
}