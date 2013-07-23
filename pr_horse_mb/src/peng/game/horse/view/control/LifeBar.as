package peng.game.horse.view.control
{
	import cactus.ui.bind.PAutoView;
	
	/**
	 * 生命条 
	 */
	public class LifeBar extends PAutoView
	{
		public var maxLife:int = 3;
		private var _currLife:int;
		
		public var item0_PB:LifeIcon = new LifeIcon();
		public var item1_PB:LifeIcon = new LifeIcon();
		public var item2_PB:LifeIcon = new LifeIcon();
		
		private var items:Array = new Array;
		
		public function LifeBar($sourceName:String=null)
		{
			super($sourceName);
		}

		override public function init():void
		{
			items.push( item0_PB);
			items.push( item1_PB);
			items.push( item2_PB);
			
//			for each (var item:LifeIcon in items)
//			{
//				item.add();
//			}
			
		}
		
		public function addLife():void
		{
			currLife++;
		}
		
		public function reduceLife():void
		{
			currLife--;
		}
		
		override public function fireDataChange():void
		{
			
		}
		
		public function get currLife():int
		{
			return _currLife;
		}

		public function set currLife(value:int):void
		{
			
			value = Math.min( maxLife,value);
			value = Math.max(0,value);
				var item:LifeIcon ;
				
//				item = items[value-1];
				
				// 判断是加血还是减血
				// 加血
				if ( value - currLife >0)
				{
					item = items[ maxLife - value];
					item.add();
				}
				else if ( value - currLife < 0)
				{
//					item = items[(maxLife-1) - value];
					item = items[value];
					
					item.remove();
				}
				
				_currLife = value;

		}

	}
}