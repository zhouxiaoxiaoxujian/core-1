/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.ds.utils
{
	import cactus.common.ds.GraphEdge;
	import cactus.common.ds.GraphNode;
	import cactus.common.ds.abs.IGraph;
	import cactus.common.ds.abs.IGraphEdge;
	import cactus.common.xx.goem.Vector2D;

	/**
	 * 图工具类
	 * @author Peng
	 */
	public class GraphHelper
	{
		public function GraphHelper()
		{
		}

		/**
		 * 创建全部连通的2D网格图，全部节点可通行
		 *
		 * 定义左上角为世界原点
		 * @param graph				需要创建网格的图
		 * @param xTileSize			x方向格子的像素数
		 * @param yTileSize			y方向格子的像素数
		 * @param xTileCount		x方向的格子数
		 * @param yTileCount		y方向的格子数
		 */
		public static function createGrid(graph : IGraph, tileWidth : int, tileHeight : int, xTileCount : int, yTileCount : int) : IGraph
		{
			// 创建2D网格
			for (var row : int = 0; row < yTileCount; row++)
			{
				for (var col : int = 0; col < xTileCount; col++)
				{
					graph.addNode(new GraphNode(graph.getNextFreeNodeIndex(), new Vector2D(row * tileHeight + tileWidth /
						2, col * tileWidth + tileHeight / 2)));
				}
			}

			// 初始化所有的边
			// @TBD 写法需要改变
			var index : int = 0;
			for (row = 0; row < yTileCount; ++row)
			{
				for (col = 0; col < xTileCount; ++col)
				{
					// 将所有边初始化
					index = row * xTileCount + col;
					graph.initEdge(index);
				}
			}

			// 创建连通的边
			for (row = 0; row < yTileCount; ++row)
			{
				for (col = 0; col < xTileCount; ++col)
				{
					add8NeighboursToGridNode(graph, row, col, xTileCount, yTileCount);
				}
			}

			return graph;
		}


		/**
		 * 根据笔刷更新图的地形
		 * 地形说明： 0 通路
		 * 			 1 障碍
		 * @param terrain
		 * @param id
		 */
		public static function updateGraphFromBrush(graph : IGraph, terrain : int, id : uint) : void
		{
			// 如果地形是阻塞，需要删除节点
			if (terrain == 1)
			{
				graph.removeNode2(id);
			}

			else
			{
//				//make the node active again if it is currently inactive
//				if (!m_pGraph->isNodePresent(CellIndex))
//				{
//					int y = CellIndex / m_iCellsY;
//					int x = CellIndex - (y*m_iCellsY);
//					
//					m_pGraph->AddNode(NavGraph::NodeType(CellIndex, Vector2D(x*m_dCellWidth + m_dCellWidth/2.0,
//						y*m_dCellHeight+m_dCellHeight/2.0)));
//					
//					GraphHelper_AddAllNeighboursToGridNode(*m_pGraph, y, x, m_iCellsX, m_iCellsY);
//				}
//				
//				//set the edge costs in the graph
//				WeightNavGraphNodeEdges(*m_pGraph, CellIndex, GetTerrainCost((brush_type)brush));                            
			}
		}


		/**
		 * 为图graph的当前节点 row col添加8个方向的邻居
		 * @param graph
		 * @param row
		 * @param col
		 * @param xTileCount	图的x方向宽度
		 * @param yTileCount	图的y方向宽度
		 */
		private static function add8NeighboursToGridNode(graph : IGraph, row : uint, col : uint, xTileCount : uint, yTileCount : uint) : void
		{
			// 当前结点的位置
			var posNode : Vector2D = graph.getNode(row * xTileCount + col).position;

			// 加入一条边
			var newEdge : IGraphEdge

			for (var i : int = -1; i < 2; ++i)
			{
				for (var j : int = -1; j < 2; ++j)
				{
					var nodeX : int = col + j;
					var nodeY : int = row + i;

					// 如果是当前节点本身，则跳过
					if ((i == 0) && (j == 0))
						continue;

					// 如果是个合法的邻居
					if (validNeighbour(nodeX, nodeY, xTileCount, yTileCount))
					{
						// 正在处理的当前节点的邻居
						var posNeighbour : Vector2D = graph.getNode(nodeY * xTileCount + nodeX).position;

						// @TBD 优化点，如果是为了处理路径代价，则可以使用不开方的数据
						var dist : Number = posNode.dist(posNeighbour);

						newEdge = new GraphEdge(row * xTileCount + col, nodeY * xTileCount + nodeX, dist);
						graph.addEdge(newEdge);

						// 如果是无向图，添加另一条边
						if (!graph.isDigraph())
						{
							newEdge = new GraphEdge(nodeY * xTileCount + nodeX, row * xTileCount + col, dist);
							graph.addEdge(newEdge);
						}
					}
				}
			}
		}


		/**
		 * x，y点是否为合法的邻居
		 * @param x
		 * @param y
		 * @param xTileCount
		 * @param yTileCount
		 * @return 如果合法返回true
		 */
		private static function validNeighbour(x : int, y : int, xTileCount : int, yTileCount : int) : Boolean
		{
			return !((x < 0) || (x >= xTileCount) || (y < 0) || (y >= yTileCount));
		}

	}
}
