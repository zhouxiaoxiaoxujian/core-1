package cactus.ui.bind
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;

	import cactus.common.Global;
	import cactus.ui.PUIConfig;
	import cactus.ui.control.CTextField;
	import cactus.ui.control.PButton;
	import cactus.ui.control.PTextField;
	import cactus.ui.control.PTweenButton;
	import cactus.ui.events.BindEvent;

	/**
	 * 绑定规则
	 * _PB 为PUI组件标准后缀
	 * _ALTRB为适应全屏的标准模式,_A为自动寻找对齐方式，_LTRB分别对应left, top,right,bottom
	 * @author Peng
	 */
	public class PBinder
	{
		public function PBinder()
		{
		}

		/**
		 * 将view和res素材绑定
		 * @param view
		 * @param res
		 */
		public static function bind(view : PView, res : MovieClip) : void
		{
			bindView(view, res);
		}

		/**
		 * 绑定 视图
		 * @param view
		 * @param child
		 */
		private static function bindView(view : PView, resource : MovieClip) : void
		{
			//			var propertyNames:Array = PReflectUtil.getPropertyNames(view, PReflectUtil.VARIABLES, /(_PB)/);
			var properties : Array = PReflectUtil.getProperties(view, PReflectUtil.VARIABLES, /(_PB)/);

			// 数组里存放的是MTObj
			var len : int = properties.length
			for (var i : int = 0; i < len; i++)
			{
				var childname : String = properties[i].propertyName;
				var pbIndex : int = childname.indexOf(PUIConfig.PB);
				var childnameWithoutPostfix : String = childname.substring(0, pbIndex == -1 ? int.MAX_VALUE : pbIndex);

				// trace("childname",childname,childnameWithoutPostfix);

				// 如果不存在绑定
				if (!resource[childnameWithoutPostfix])
				{
					trace("资源中不存在绑定 ", childnameWithoutPostfix);
					continue;
				}

				// 在素材绑定之前，获得原始素材的长宽位置等信息，以便进行布局
				var resPosX : Number = resource[childnameWithoutPostfix].x;
				var resPosY : Number = resource[childnameWithoutPostfix].y;
				var resWidth : Number = resource[childnameWithoutPostfix].width;
				var resHeight : Number = resource[childnameWithoutPostfix].height;

				if (childname.indexOf(PUIConfig.PRIFIX_BUTTON) != -1)
				{
					PButtonBinder.bindView(view, resource, childname, childnameWithoutPostfix);
				}
				else if (childname.indexOf(PUIConfig.PRIFIX_TWEEN_BUTTON) != -1)
				{
					PTWeenButtonBinder.bindView(view, resource, childname, childnameWithoutPostfix);
				}
				else if (childname.indexOf(PUIConfig.PRIFIX_TEXTFIELD) != -1)
				{
					PTextFieldBinder.bindView(view, resource, childname, childnameWithoutPostfix);
				}
				// 其他只有一帧的类型
				else
				{
					PViewBinder.bindView(view, resource, childname, childnameWithoutPostfix);
				} // end if 绑定


				// 设置和素材坐标一致的位置
				view[childname].x = resPosX;
				view[childname].y = resPosY;

				layoutPosition(view, resource, childname, childnameWithoutPostfix, resPosX, resPosY, resWidth, resHeight, properties[i]);
			} // end for 

			// 将绑定好的素材添加到显示列表
			addResourceToView(view, resource, properties);
		}

		internal static const MASK_ALIGN_RIGHT : int = 1 << 6;
		internal static const MASK_ALIGN_CENTER : int = 1 << 5;
		internal static const MASK_ALIGN_LEFT : int = 1 << 4;
		internal static const MASK_L : int = 1 << 3
		internal static const MASK_T : int = 1 << 2
		internal static const MASK_R : int = 1 << 1;
		internal static const MASK_B : int = 1;
		internal static const MASK_ALL : int = 0;

		/**
		 * 自适应的布局
		 * @param view
		 * @param resource
		 * @param childname
		 * @param childnameWithoutPostfix
		 * @param resPosX
		 * @param resPosY
		 */
		private static function layoutPosition(view : PView, resource : MovieClip, childname : String, childnameWithoutPostfix : String, resPosX : Number, resPosY : Number, resWidth : Number, resHeight : Number, mt : MTObj =
			null) : void
		{
			// 被操作对象
			var item : DisplayObject = view[childname];
			var itemResource : DisplayObject = resource[childnameWithoutPostfix];

			// 自适应对齐的中心点
			// 早起的实现方式元件必须是左上角为注册点
			// 现在改进为无论注册点在哪里都可以
			var rect : Rectangle = itemResource.getRect(itemResource.parent);
//			trace(rect.x, rect.y, rect.width, rect.height);
//			trace(resPosX, resPosY, resWidth, resHeight);
			// 视觉中心点坐标
			var mx : Number = rect.x + rect.width / 2;
			var my : Number = rect.y + rect.height / 2;

			// 距离四方空白的百分比，即元件边框到四周的百分比
			var leftPercent : Number = (rect.x) / Global.originalScreenW;
			var rightPercent : Number = 1 - (rect.x + rect.width) / Global.originalScreenW;
			var topPercent : Number = rect.y / Global.originalScreenH;
			var bottomPercent : Number = 1 - (rect.y + rect.height) / Global.originalScreenH;

			var last_index : int = childname.lastIndexOf("_");
			var layout : int = 0;

			// 是否为自适应对齐
			var autoLayout : Boolean = (mt.ref.toLowerCase().indexOf("a") != -1);

			// 按照上下左右空白比例对齐
			if (mt.ref.toLowerCase().indexOf("l") != -1)
				layout = layout | MASK_L;
			if (mt.ref.toLowerCase().indexOf("t") != -1)
				layout = layout | MASK_T;
			if (mt.ref.toLowerCase().indexOf("r") != -1)
				layout = layout | MASK_R;
			if (mt.ref.toLowerCase().indexOf("b") != -1)
				layout = layout | MASK_B;

			// 横向绝对位置对齐
			if (mt.align == "left")
				layout = layout | MASK_ALIGN_LEFT;
			if (mt.align == "center")
				layout = layout | MASK_ALIGN_CENTER;
			if (mt.align == "right")
				layout = layout | MASK_ALIGN_RIGHT;

			if (autoLayout)
			{
				// 左上
				if (mx <= Global.originalScreenW / 2 && my <= Global.originalScreenH / 2)
				{
					layout = layout | MASK_L;
					layout = layout | MASK_T;
				}
				// 右上
				else if (mx >= Global.originalScreenW / 2 && my <= Global.originalScreenH / 2)
				{
					layout = layout | MASK_R;
					layout = layout | MASK_T;
				}
				// 左下
				else if (mx <= Global.originalScreenW / 2 && my >= Global.originalScreenH / 2)
				{
					layout = layout | MASK_L;
					layout = layout | MASK_B;
				}
				// 右下
				else if (mx >= Global.originalScreenW / 2 && my >= Global.originalScreenH / 2)
				{
					layout = layout | MASK_R;
					layout = layout | MASK_B;
				}
			}
			// trace("layoutString" , layoutString , "layout" , layout);

			if ((layout & MASK_L) == MASK_L)
				item.x = Global.screenW * leftPercent + (itemResource.x - rect.x);
			if ((layout & MASK_T) == MASK_T)
				item.y = Global.screenH * topPercent + (itemResource.y - rect.y);
			if ((layout & MASK_R) == MASK_R)
				item.x = Global.screenW - Global.screenW * rightPercent - (rect.width - (itemResource.x - rect.x));
			if ((layout & MASK_B) == MASK_B)
				item.y = Global.screenH - Global.screenH * bottomPercent - (rect.height - (itemResource.y - rect.y));

//			trace(childnameWithoutPostfix, leftPercent, rightPercent, topPercent, bottomPercent, item.x);

			if ((layout & MASK_ALIGN_LEFT) == MASK_ALIGN_LEFT)
				item.x = resPosX;
			if ((layout & MASK_ALIGN_CENTER) == MASK_ALIGN_CENTER)
				item.x = ((Global.screenW - resWidth) / 2) + (itemResource.x - rect.x); // ok
			if ((layout & MASK_ALIGN_RIGHT) == MASK_ALIGN_RIGHT)
				item.x += (Global.screenW - Global.originalScreenW);

			if (mt.scale)
			{
				var xScale : Number = Global.screenW / Global.originalScreenW;
				var yScale : Number = Global.screenH / Global.originalScreenH;

				item.scaleX = xScale;
				item.scaleY = yScale;

				item.x += (Global.originalScreenW - Global.screenW) / 2;
				item.y += (Global.originalScreenH - Global.screenH) / 2;
			}
		}

		/**
		 * 将孩子素材逐一添加到view对象
		 * @param view
		 * @param resource
		 * @param propertyNames
		 */
		private static function addResourceToView(view : PView, resource : MovieClip, properties : Array) : void
		{
			while (resource.numChildren > 0)
			{
				var instance : DisplayObject = resource.removeChildAt(0);

				// 注意 propertyNames是数组，而查找源为字符串
				var propertyIndex : int = -1;

				for (var j : int = 0; j < properties.length; j++)
				{
					if (properties[j].propertyName == (instance.name + PUIConfig.PB) || properties[j].propertyName == instance.
						name)
					{
						propertyIndex = j;
						break;
					}
				}

				if (propertyIndex != -1)
				{
					view.addChild(view[properties[propertyIndex].propertyName])
				}
				else
				{
					view.addChild(instance)
				}
			}

			// 保留x，y属性(对于弹窗而言)
//			var oldX:Number=view.x;
//			var oldY:Number=view.y;
//			var oldAlpha:Number = view.alpha;

//			//复制属性
//			view.transform=resource.transform // @Warning: 这一步导致view的x，y等属性归0,也会导致alpha的变化
			view.alpha = resource.alpha;
			view.cacheAsBitmap = resource.cacheAsBitmap;
			view.scaleX = resource.scaleX;
			view.scaleY = resource.scaleY;

			// 还原x，y属性
//			view.x=oldX;
//			view.y=oldY;
//			view.alpha = oldAlpha;
			view.dispatchEvent(new BindEvent(BindEvent.BIND_COMPLETE));
		}

	}
}

// =============================================================
// =============================================================
// 					各种不同类型的绑定
// =============================================================
// =============================================================
import cactus.ui.bind.IPView;
import cactus.ui.bind.PView;
import cactus.ui.control.CTextField;
import cactus.ui.control.PButton;
import cactus.ui.control.PTextField;
import cactus.ui.control.PTweenButton;

import flash.display.MovieClip;

class PButtonBinder
{
	public static function bindView(view : PView, resource : MovieClip, childname : String, childnameWithoutPostfix : String) : void
	{
		// 没有实例化,默认实例化为PButton
		if (view[childname] == null)
		{
			view[childname] = new PButton(resource[childnameWithoutPostfix])
		}
		// 已经实例化
		else
		{
			view[childname].source = resource[childnameWithoutPostfix];
		}
	}
}

class PTWeenButtonBinder
{
	public static function bindView(view : PView, resource : MovieClip, childname : String, childnameWithoutPostfix : String) : void
	{
		view[childname] = new PTweenButton();
		view[childname].source = resource[childnameWithoutPostfix];
	}
}

class PTextFieldBinder
{
	public static function bindView(view : PView, resource : MovieClip, childname : String, childnameWithoutPostfix : String) : void
	{
		// 默认的TextField
		if (view[childname] == null)
		{
			view[childname] = resource[childnameWithoutPostfix];
			view[childname].selectable = false;
		}
		else
		{
			if (view[childname] is CTextField)
			{
				view[childname] = new CTextField(resource[childnameWithoutPostfix]);
			}
			else if (view[childname] is PTextField)
			{
				view[childname].sourceField = resource[childnameWithoutPostfix];
			}
			else
			{
				IPView(view[childname]).source = (resource[childnameWithoutPostfix]);
			}
		}
	}
}

class PViewBinder
{
	public static function bindView(view : PView, resource : MovieClip, childname : String, childnameWithoutPostfix : String) : void
	{
		if (view[childname] is IPView)
		{
			IPView(view[childname]).source = (resource[childnameWithoutPostfix]);
		}
		else
		{
			view[childname] = resource[childnameWithoutPostfix];
		}
	}
}


// ==============================================
// 保留的一些代码
// ==============================================

//if (auto && mx <= Global.originalScreenW / 2 && my <= Global.originalScreenH / 2)
//{
//	item.x = Global.screenW * leftPercent;
//	item.y = Global.screenH * topPercent;
//}
//	// 右上
//else if (auto && mx >= Global.originalScreenW / 2 && my <= Global.originalScreenH / 2)
//{
//	item.x = Global.screenW - (rightPercent * Global.screenW + item.width);
//	item.y = Global.screenH * topPercent;
//}
//	// 左下
//else if (auto && mx <= Global.originalScreenW / 2 && my >= Global.originalScreenH / 2)
//{
//	item.x = Global.screenW * leftPercent;
//	item.y = Global.screenH - (bottomPercent * Global.screenH + item.height);
//}
//	// 右下
//else if (auto && mx >= Global.originalScreenW / 2 && my >= Global.originalScreenH / 2)
//{
//	item.x = Global.screenW - (rightPercent * Global.screenW + item.width);
//	item.y = Global.screenH - (bottomPercent * Global.screenH + item.height);
//}
