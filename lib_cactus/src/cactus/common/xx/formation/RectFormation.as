package cactus.common.xx.formation
{
	public class RectFormation extends BaseFormation
	{
		private var _col:int;
		private var _row:int;
		private var _hgap:Number;
		private var _vgap:Number;
		
		public function RectFormation(params:Object = null)
		{
			super(params);
		}
		
		
		override protected function loadItems(items:Array):void
		{
			var item:*;
			var currCol:int;
			var currRow:int;
			
			for (var i:int = 0; i < items.length; i++) 
			{
				item = items[i];
				
				currCol =  int(i / row)
				currRow = int(i / col)
				
			}
		}
		
		
		public function get vgap():Number
		{
			return _vgap;
		}
		
		public function set vgap(value:Number):void
		{
			_vgap = value;
		}
		
		public function get hgap():Number
		{
			return _hgap;
		}
		
		public function set hgap(value:Number):void
		{
			_hgap = value;
		}
		
		public function get row():int
		{
			return _row;
		}
		
		public function set row(value:int):void
		{
			_row = value;
		}
		
		public function get col():int
		{
			return _col;
		}
		
		public function set col(value:int):void
		{
			_col = value;
		}
		
	}
}