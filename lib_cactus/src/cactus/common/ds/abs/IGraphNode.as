package cactus.common.ds.abs
{
	import cactus.common.ds.GraphNodeData;
	import cactus.common.xx.goem.Vector2D;

	public interface IGraphNode
	{
		function get id():uint

		function set id(value:uint):void

		function get data():GraphNodeData

		function set data(value:GraphNodeData):void

		function get position():Vector2D

		function set position(value:Vector2D):void

	}
}
