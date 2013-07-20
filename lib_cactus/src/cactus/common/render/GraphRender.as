/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.render
{
	import flash.display.Graphics;
	import flash.geom.Point;

	import cactus.common.ds.abs.IGraph;
	import cactus.common.ds.abs.IGraphEdge;
	import cactus.common.ds.abs.IGraphNode;
	import cactus.common.xx.goem.Vector2D;

	/**
	 * 图渲染
	 * @author Peng
	 */
	public class GraphRender extends BaseRender
	{
		/**
		 * 图
		 * @default
		 */
		private var _graph : IGraph;
		/**
		 * 图节点半径
		 * @default
		 */
		private var _graphNodeRadius : Number;


		public function GraphRender($graph : IGraph, $graphNodeRadius : Number = 5)
		{
			_graph = $graph;
			_graphNodeRadius = $graphNodeRadius;
		}

		/**
		 * 渲染
		 * @param isStatic	true，代表只渲染一次
		 */
		override public function draw() : void
		{
			if (_willRender)
			{
				// 渲染节点
				var g : Graphics = paper.graphics;
				g.beginFill(0x000000, 0.6);

				for each (var node : IGraphNode in _graph.getNodes())
				{
					if (node)
					{
						g.drawCircle(node.position.x, node.position.y, _graphNodeRadius);
					}
				}
				g.endFill();


				// 渲染边
				g.lineStyle(1, 0x000000);
				var tmpPos : Vector2D;

				for each (var edgeVec : Vector.<IGraphEdge> in _graph.getEdges())
				{
					for each (var edge : IGraphEdge in edgeVec)
					{
						tmpPos = _graph.getNode(edge.from).position;
						g.moveTo(tmpPos.x, tmpPos.y);
//						trace("from", edge.from, tmpPos.x, tmpPos.y);

						tmpPos = _graph.getNode(edge.to).position;
						g.lineTo(tmpPos.x, tmpPos.y);
//						trace("to", edge.to, tmpPos.x, tmpPos.y);
					}
				}

				// 只渲染一次
				if (_isStatic)
				{
					_willRender = false;
				}
			}
		}
	}
}
