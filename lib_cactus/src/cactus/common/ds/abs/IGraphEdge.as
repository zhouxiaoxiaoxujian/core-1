package cactus.common.ds.abs
{
	public interface IGraphEdge
	{
		 function get cost():Number
		
		 function set cost(value:Number):void
		
		 function get to():uint
		
		 function set to(value:uint):void
		
		 function get from():uint
		
		 function set from(value:uint):void
	}
}