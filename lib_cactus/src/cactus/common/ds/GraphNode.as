/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.ds
{
	import cactus.common.ds.abs.IGraphNode;
	import cactus.common.xx.goem.Vector2D;

	/**
	 * 图节点
	 * @author Peng
	 */
	public class GraphNode implements IGraphNode
	{
		private var _id:uint;
		private var _position:Vector2D;
		private var _data:GraphNodeData;

		public function GraphNode($id:uint,$position:Vector2D)
		{
			_id = $id;
			_position = $position;
		}

		public function get id():uint
		{
			return _id;
		}

		public function set id(value:uint):void
		{
			_id = value;
		}

		public function get data():GraphNodeData
		{
			return _data;
		}

		public function set data(value:GraphNodeData):void
		{
			_data = value;
		}
		
		public function get position():Vector2D
		{
			return _position;
		}
		
		public function set position(value:Vector2D):void
		{
			_position = value;
		}

	}
}
