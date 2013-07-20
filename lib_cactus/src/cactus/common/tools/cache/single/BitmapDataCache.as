package cactus.common.tools.cache.single
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import cactus.common.frame.interfaces.IDisposeAble;
	
	/**
	 * 位图缓存数据
	 * @author Pengx
	 * 
	 */
	public class BitmapDataCache extends BitmapData implements IDisposeAble
	{
		/**
		 * 用于包装显示对象的父容器，用于绘制变形和旋转了的显示对象 
		 */
		private static var _checkParent:Sprite = new Sprite();
		//------- 要缓存的显示对象的父对象备份记录 Start--------
		private var _isRecord:Boolean = false;
		private var _parentRecord:DisplayObjectContainer;
		private var _xRecord:Number;
		private var _yRecord:Number;
		//------- 要缓存的显示对象的父对象备份记录 End--------
		private var _offsetX:Number;
		private var _offsetY:Number;
		
		private static const ratateChange:Number = Math.PI/180;
		
		/**
		 *  
		 * @param target	需要缓存的显示对象
		 * @param rotation  缓存角度
		 * @param stage		舞台
		 * 
		 */
		public function BitmapDataCache(target:DisplayObject,rotation:int = 0,stage:Stage = null)
		{
			var drawTarget:DisplayObject;			
			//如果对显示对象有变形或旋转，需要给外套一层，绘制外层对象
			if(rotation != 0)
			{
				_isRecord = true;
				if(target.parent != _checkParent)
				{
					_parentRecord = target.parent;
					_xRecord = target.x;
					_yRecord = target.y;
					target.x = target.y = 0;
					_checkParent.addChild(target);
				}
				target.rotation = rotation;
				drawTarget = _checkParent;
			}
			else
			{
				drawTarget = target;
			}
			
			var bounds:Rectangle = target.getBounds(drawTarget);
			 
			var offsetSpan:Number = Math.max(bounds.width,bounds.height)/4;
			super(bounds.width + 1,bounds.height + 1,true,0x00FFFFFF);
			var matrix:Matrix = drawTarget.transform.matrix;
//			matrix.rotate(rotation * ratateChange);
			matrix.tx = -bounds.x;
			matrix.ty = -bounds.y;
			var oldQuality:String;
			if(stage != null)
			{
				oldQuality = stage.quality;
				stage.quality = StageQuality.BEST;
			}

			this.draw(drawTarget,matrix);
			if(stage != null)
			{
				stage.quality = oldQuality;
			}
			_offsetX = bounds.x;
			_offsetY = bounds.y;
			//还原
			if(_isRecord)
			{
				target.x = _xRecord;
				target.y = _yRecord;
				if(_parentRecord != null)
				{
					_parentRecord.addChild(target);
					_parentRecord = null;
				}
				else
				{
					_checkParent.removeChild(target);
				}
			}
		}
		
		/**
		 * 加入Bitm/ap后的偏移量x 
		 * @return 
		 * 
		 */
		public function get offsetX():Number
		{
			return _offsetX;
		}
		
		/**
		 * 加入bitMap后的偏移量y 
		 * @return 
		 * 
		 */
		public function get offsetY():Number
		{
			return _offsetY;
		}
		
		/**
		 *  释放资源
		 * 
		 */
		public function destory():void
		{
			_parentRecord = null;
			this.dispose();
		}
	}
}