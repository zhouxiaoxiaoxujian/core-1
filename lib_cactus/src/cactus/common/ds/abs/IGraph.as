package cactus.common.ds.abs
{

	/**
	 * 图
	 * @author Peng
	 */
	public interface IGraph
	{

		/**
		 * 获得下一个空闲节点的id
		 * @return
		 */
		function getNextFreeNodeIndex():uint

		/**
		 * 获得节点
		 * @param id	节点id
		 * @return
		 */
		function getNode(id:uint):IGraphNode;

		/**
		 * 获得边
		 * @param fromId	起始id
		 * @param toId		结束id
		 * @return
		 */
		function getEdge(fromId:uint, toId:uint):IGraphEdge;

		/**
		 * 添加节点
		 * @param node
		 * @return
		 */
		function addNode(node:IGraphNode):uint;

		/**
		 * 删除节点
		 * @param node
		 */
		function removeNode(node:IGraphNode):void;

		/**
		 * 根据节点id删除节点
		 * @param id
		 */
		function removeNode2(id:uint):void

		/**
		 * 添加边
		 * @param edge
		 */
		function addEdge(edge:IGraphEdge):void;

		/**
		 * 删除边
		 * @param edge
		 */
		function removeEdge(edge:IGraphEdge):void;

		/**
		 * 根据节点id删除边
		 * @param from
		 * @param to
		 */
		function removeEdge2(from:uint, to:uint):void

		/**
		 * 节点的数目,包括所有active和inactive节点的数目
		 * @return
		 */
		function numNode():int;

		/**
		 * 边的数目
		 * @return
		 */
		function numEdge():int;

		/**
		 * 是否为有向图
		 * @return 	是有向图，则返回true
		 */
		function isDigraph():Boolean;

		/**
		 * 该图中是否为空
		 * @return 如果没有节点，则为空
		 */
		function isEmpty():Boolean;

		/**
		 * 是否存在指定id的结点
		 * @param id
		 * @return
		 */
		function hasNode(id:uint):Boolean;

		/**
		 * 是否有变，有向的判断
		 * @param from
		 * @param to
		 * @return
		 */
		function hasEdge(from:uint, to:uint):Boolean

		/**
		 * 初始化该边
		 * @param id
		 */
		function initEdge(id:uint):void
			
		/**
		 * 获得所有结点 
		 * @return 
		 */
		function getNodes():Vector.<IGraphNode>
		
		/**
		 * 获得所有边 
		 * @return 
		 */
		function getEdges():Vector.<Vector.<IGraphEdge>>
	}
}
