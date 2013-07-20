/**
 * Copyright (c) 2010 Peng
 *
 *
 * @author    Peng
 * @version
 **/
package cactus.common.tools.cache
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * 位图缓存的Movieclip，分为两种模式
	 * 模式1		_isComplex == false		简单模式，只有一层动画，第二层子对象没有动画
	 * 模式2		_isComplex == true		复杂模式，第二层子对象有动画
	 * 
	 * 
	 * @EXT: 目前顶层，即1级图形依然绘制，一定程度上占用内存。为了适配StageMouseProxy 的 
	 * 	private function findBitmapItem(objects:Array,stage:Stage):AbstractImageTile
	 * @author Peng
	 *
	 * 
	 */
	public class BitmapMovieClip extends Sprite
	{
		// 持有的帧信息，表示四个方向上第一层信息
		private var _mainFrames:Vector.<BitmapFrameInfo>;

		// 第二层动画的帧信息，相当于一个二维数组
		private var _childrenFrames:Vector.<Vector.<BitmapFrameInfo>>;

		// 第二层子对象
		private var _childrenClip:Vector.<BitmapMovieClip>;

		// 位图缓存容器
		private var _bitmap:Bitmap;

		private var _subContainer:Sprite;

		// 是否为嵌套的复杂组件
		private var _isComplex:Boolean;

		// MovieClip 属性适配
		private var _currentFrame:int;
		private var _totalFrames:int;

		public function BitmapMovieClip(pMainFrame:Vector.<BitmapFrameInfo>,subFrames:Vector.<Vector.<BitmapFrameInfo>>=null):void
		{
			/*			trace("--- begin --- ");
			   trace("--> pMainFrame: " + pMainFrame);
			   if (subFrames)
			   {
			   for (var k:int=0;k < subFrames.length;k++)
			   {
			   trace("--> subFrames["+k+"]: " + subFrames[k]);
			   }
			 }*/

			_bitmap=new Bitmap();
			addChild(_bitmap);

			_subContainer=new Sprite;
			addChild(_subContainer);

			// 单层动画元件，即没有内嵌动画
			if (!subFrames || subFrames.length == 0)
			{
				// 设置数据并绘制
				initMainFrames(pMainFrame)
				_isComplex=false;
			}
			else
			{
				_isComplex=true;
				
				// 设置内部节点的动画
				initMainFrames(pMainFrame)
				_childrenFrames=subFrames;

				_childrenClip=new Vector.<BitmapMovieClip>(_childrenFrames.length,true);
				for (var i:int=0;i < _childrenFrames.length;i++)
				{
					var clip:BitmapMovieClip=new BitmapMovieClip(_childrenFrames[i]);
					_childrenClip[i]=(clip);
				}
			}

		}

		/**
		 * 原则上这个方法只被调用一次
		 * @param value
		 */
		public function initMainFrames(value:Vector.<BitmapFrameInfo>):void
		{
			_mainFrames=value;

			//for test ,置空顶层
			/*		if (_isComplex)
			 _mainFrames = new Vector.<BitmapFrameInfo>;*/
			// 

			_bitmap.bitmapData=null;

			_currentFrame=1;
			_totalFrames=_mainFrames.length;

			// 只有不是复杂动画，才绘制主时间轴
//			if (!_isComplex)
				draw(_currentFrame);

			_currentFrame+=1;
		}

		/**
		 * 默认的播放，无限循环的放
		 */
		public function play():void
		{
			//			_currentFrame=1;
			addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}

		/**
		 * 停止播放
		 */
		public function stop():void
		{
			removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
			//			_currentFrame=1;
		}

		public function gotoAndStop(frame:int):void
		{
			if (frame > _totalFrames)
			{
				frame=1;
			}

			_currentFrame=frame;
			draw(_currentFrame);

			if (_isComplex)
			{
				getChild(frame).play();
			}

		}

		public function nextFrame():void
		{
			if (_currentFrame > _totalFrames)
			{
				_currentFrame=1;
			}

			draw(_currentFrame);
			_currentFrame++;
		}

		/**
		 * 获得指定帧的子显示对象
		 * @param frame
		 * @return
		 */
		private function getChild(frame:int):BitmapMovieClip
		{
			// 顶层的Bitmap对象不能删除！
			while (_subContainer.numChildren > 0)
			{
				(_subContainer.getChildAt(0) as BitmapMovieClip).stop();
				_subContainer.removeChildAt(_subContainer.numChildren - 1);
			}

			var subClip:BitmapMovieClip=_childrenClip[frame - 1];
			_subContainer.addChild(subClip);
			return subClip;
		}

		/**
		 * 绘制到具体的帧数
		 * @param frame
		 */
		private function draw(frame:int):void
		{
			// 非复杂对象的绘制
			// 适配数组index
			if (mainFrames.length != 0/* && !_isComplex*/)
			{
				var info:BitmapFrameInfo=mainFrames[frame - 1];

				_bitmap.bitmapData=info.bitData;
				_bitmap.x=info.x;
				_bitmap.y=info.y;
			}
		}

		private function enterFrameHandler(evt:Event):void
		{
			nextFrame();
		}

		// ------ get and set -----
		public function getBitmap():Bitmap
		{
			return _bitmap;
		}
		
		// @WARNING: 在draw之后才会有值，否则是null
		public function getBitmapData():BitmapData
		{
			return _bitmap.bitmapData;
//			return mainFrames[currentFrame - 1].bitData;
		}
		
		public function get totalFrames():int
		{
			return _totalFrames;
		}

		public function set totalFrames(value:int):void
		{
			_totalFrames=value;
		}

		public function get currentFrame():int
		{
			return _currentFrame;
		}

		public function set currentFrame(value:int):void
		{
			_currentFrame=value;
		}

		public function get mainFrames():Vector.<BitmapFrameInfo>
		{
			return _mainFrames;
		}

		public function get smoothing():Boolean
		{
			return _bitmap.smoothing;
		}

		public function set smoothing(value:Boolean):void
		{
			_bitmap.smoothing=value;
		}

	}

}