package cactus.ui.control.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * 流水布局
	 * @author Peng
	 */
	public class FlowLayout extends BaseLayout implements ILayout
	{
		private var _top:int;
		private var _left:int;
		private var _hgap:int;
		private var _vgap:int;

		public function FlowLayout($target:DisplayObjectContainer=null, $top:int=5, $left:int=5, $hgap:int=5, $vgap:int=5)
		{
			target=$target;
			setProperties($top, $left, $hgap, $vgap);
		}

		/**
		 * 设置属性
		 * @param $top
		 * @param $left
		 * @param $hgap
		 * @param $vgap
		 */
		public function setProperties($top:int, $left:int, $hgap:int, $vgap:int):void
		{
			_top=$top;
			_left=$left;
			_hgap=$hgap;
			_vgap=$vgap;
		}

		override protected function doLayout():void
		{
			// 是否为新的一行
			var isNewLine:Boolean=true;
			// 当前基础高度
			var currBaseHeight:int=_top;
			// 一行中的最高值
			var maxLineHeight:int = 0;
			
			var len:int=target.numChildren;

			var child:DisplayObject;
			var lastChild:DisplayObject;
			for (var i:int=0; i < len; i++)
			{
				if (i > 0)
					lastChild=target.getChildAt(i - 1);
				child=target.getChildAt(i);

				// 需要换行
				if (lastChild && (lastChild.x + lastChild.width + _hgap + child.width > target.width))
				{
					currBaseHeight += (maxLineHeight+_vgap);
					isNewLine=true;
					maxLineHeight = 0;
				}

				// 新行的第一个元素
				if (isNewLine)
				{
					child.x=_left;
					child.y= currBaseHeight;
					maxLineHeight = Math.max(child.height,maxLineHeight); 
					isNewLine=false;
//					continue
				}
				else
				{
					child.x= lastChild.x + lastChild.width + _hgap;
					child.y = currBaseHeight;
				}

			}
		}
	}
}
