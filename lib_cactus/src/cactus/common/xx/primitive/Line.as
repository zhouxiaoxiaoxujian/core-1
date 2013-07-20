package cactus.common.xx.primitive
{
	import flash.geom.Point;
	
	import cactus.common.xx.goem.Vector2D;

	/**
	 * 
	 * @author Peng
	 */
	public class Line
	{
		// 一般式 Ax+By+C=0
		// 由两点得到一般式的公式  (y2-y1)*X + (x1-x2)*Y + x2y1 - x1y2 = 0 
		public var A:Number;
		public var B:Number;
		public var C:Number;
		
		// 向量参数形式
		// L(t)= pt1 + b * t
		public var pt1:Point;
		public var pt2:Point;
		public var p:Vector2D;		// p1 ->p2 方向的向量
		public var t:Number;
		
		/**
		 * 通过已知的两点计算平面直线
		 * @param $pt1
		 * @param $pt2
		 */
		public function Line($pt1:Point,$pt2:Point)
		{
			pt1 = $pt1;
			pt2 = $pt2;
			
			// 由两点得到一般式的公式
			A = pt2.y - pt1.y;
			B = pt1.x - pt2.x;
			C = pt2.x * pt1.y - pt1.x * pt2.y;
			
			// 参数表达式
			p  = new Vector2D(pt2.x - pt1.x,pt2.y - pt1.y);
		}
		
		
	}
}