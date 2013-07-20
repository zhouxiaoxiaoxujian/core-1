package cactus.common.ds
{
	import flash.utils.ByteArray;

	import cactus.common.ds.abs.IGraph;
	import cactus.common.ds.abs.IGraphEdge;
	import cactus.common.ds.abs.IGraphNode;
	import cactus.common.tools.util.ArrayUtils;
	import cactus.common.tools.util.CloneUtil;
	import cactus.common.tools.util.Debugger;

	/**
	 * 稀疏图
	 * @author Peng
	 */
	public class SparseGraph implements IGraph
	{
		/**
		 * 存放所有结点
		 * 下标为节点id，值为节点
		 * 如 nodes[1] = aNode
		 * @default
		 */
		protected var _nodes:Vector.<IGraphNode>;

		/**
		 * 存放所有边
		 * 下标为起始节点，值为所有的结束节点
		 * 如 edge[1] = [0,2,3]
		 * @default
		 */
		protected var _edges:Vector.<Vector.<IGraphEdge>>;

		/**
		 * 是否为有向图
		 * @default
		 */
		protected var _bDigraph:Boolean;


		/**
		 * 下一个将要添加节点的index,id
		 * @default
		 */
		private var _nextFreeNodeIndex:int = 0;

		/**
		 * 是否为有向图？默认不是
		 * @param $bDigraph
		 */
		public function SparseGraph($bDigraph:Boolean = false)
		{
			_bDigraph = $bDigraph;
			init();
		}

		/**
		 * 初始化操作
		 */
		public function init():void
		{
			_nodes = new Vector.<IGraphNode>;
			_edges = new Vector.<Vector.<IGraphEdge>>;
		}

		/**
		 * 全局剔除无用的边
		 * 遍历所有的边，如果边的两个结点都是无效的，则删除该边
		 */
		public function cullInvalidEdges():void
		{
			for each (var edgeList:Vector.<IGraphEdge> in _edges)
			{
				for each (var edge:IGraphEdge in edgeList)
				{
					if (_nodes[edge.to] == undefined || _nodes[edge.from] == undefined)
					{
						ArrayUtils.removeFromArray(edgeList, edge);
					}
				}
			}
		}

		// ============= Impl ====================
		public function getNodes():Vector.<IGraphNode>
		{
			return _nodes;
		}

		public function getEdges():Vector.<Vector.<IGraphEdge>>
		{
			return _edges;
		}


		public function getNextFreeNodeIndex():uint
		{
			return _nextFreeNodeIndex;
		}

		public function getNode(id:uint):IGraphNode
		{
			return _nodes[id];
		}

		public function getEdge(from:uint, to:uint):IGraphEdge
		{
			var currEdge:IGraphEdge;
			var fromNodeVector:Vector.<IGraphEdge> = _edges[from];
			for each (currEdge in fromNodeVector)
			{
				if (currEdge.to == to)
				{
					return currEdge;
				}
			}
			return null;
		}

		public function addNode(node:IGraphNode):uint
		{
			_nodes[node.id] = node;
			return _nextFreeNodeIndex++;
		}

		public function removeNode(node:IGraphNode):void
		{
			// 删除节点
			delete _nodes[node.id];

			// 删除相关的边
			var currEdgeVec:Vector.<IGraphEdge>;
			var currEdge:IGraphEdge;

			// 如果是无向图
			if (!isDigraph())
			{
				// 遍历所有的边，删除含有该节点的边
				for each (currEdgeVec in _edges)
				{
					for each (currEdge in currEdgeVec)
					{
						if (currEdge.to == node.id)
						{
							ArrayUtils.removeFromArray(currEdgeVec, currEdge);
							break;
						}
					}
				}

				// 最后，删掉这个结点起始的所有边
				_edges[node.id] = new Vector.<IGraphEdge>;
			}
			// 有向图
			else
			{
				// @TBD
				// 我还是不明白为什么有向图和无向图删除边的方式是不一样的？？？
				cullInvalidEdges();
			}
		}

		/**
		 * 根据节点id删除节点
		 * @param id
		 */
		public function removeNode2(id:uint):void
		{
			removeNode(getNode(id));
		}

		public function addEdge(edge:IGraphEdge):void
		{
			// 存在节点才能加边
			if (hasNode(edge.from) && hasNode(edge.to))
			{
				if (!hasEdge(edge.from, edge.to))
				{
					_edges[edge.from].push(edge);
				}

				// 如果是无向图，则反方向也添加边
				if (!isDigraph())
				{
					if (!hasEdge(edge.to, edge.from))
					{
						// 反方向的cost如果是上坡，下坡的关系，则需要修改
						var newEdge:IGraphEdge = new GraphEdge(edge.to, edge.from, edge.cost);

						newEdge.to = edge.from;
						newEdge.from = edge.to;

						_edges[edge.to].push(newEdge);
					}
				}
			}
			else
			{
				Debugger.error("不存在节点", edge.from, edge.to, "无法添加边");
			}
		}

		public function removeEdge(edge:IGraphEdge):void
		{
			removeEdge2(edge.from, edge.to);
		}

		public function removeEdge2(from:uint, to:uint):void
		{
			var currEdge:IGraphEdge;
			// 删除边
			var fromNodeVector:Vector.<IGraphEdge> = _edges[from];
			for each (currEdge in fromNodeVector)
			{
				if (currEdge.to == to)
				{
					// 删除
					ArrayUtils.removeFromArray(fromNodeVector, currEdge);
					break;
				}
			}

			// 如果是无向图，删除反方向
			if (!isDigraph())
			{
				var toNodeVector:Vector.<IGraphEdge> = _edges[to];
				for each (currEdge in toNodeVector)
				{
					if (currEdge.to == from)
					{
						// 删除
						ArrayUtils.removeFromArray(toNodeVector, currEdge);
						break;
					}
				}
			}
		}

		public function numNode():int
		{
			return _nodes.length;
		}

		public function numEdge():int
		{
			var ret:int = 0;

			for each (var edgeList:Vector.<IGraphEdge> in _edges)
			{
				ret += edgeList.length;
			}
			return ret;
		}

		public function isDigraph():Boolean
		{
			return _bDigraph;
		}

		public function isEmpty():Boolean
		{
			return _nodes.length == 0;
		}

		public function hasNode(id:uint):Boolean
		{
			if (_nodes[id] == undefined || _nodes[id] == null)
				return false;
			return true;
		}

		public function hasEdge(from:uint, to:uint):Boolean
		{
			var fromEdgeDestinations:Vector.<IGraphEdge> = _edges[from];
			for each (var destination:IGraphEdge in fromEdgeDestinations)
			{
				if (destination.to == to)
					return true;
			}

			return false;
		}

		public function initEdge(id:uint):void
		{
			_edges[id] = new Vector.<IGraphEdge>;
		}
	}
}
