package cactus.common.tools.cache.single
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import cactus.common.manager.EnterFrameManager;
	
	/**
	 * 让动画缓存数据在MovieClip中显示(只支持影片剪辑的主时间轴动画，不支持嵌套动画)
	 * @author Pengx
	 * 
	 */
	public class MovieClipCache extends MovieClip
	{
		private var _bmp:BitmapCache;
		private var _bitmapDataMovieCache:BitmapDataMovieCache;
		private var _currentFrame:int = 1;
		//------为了在帧标签内循环播放------
		/**
		 * 循环播放的帧标签 
		 */
		private var _loopFrame:FrameLabel = null;
		/**
		 * 标签最后一帧位置字典 
		 */
		private var _lablesEndFrameDic:Dictionary;
		/**
		 * 
		 * @param bitmapDataMovieCache	位图缓存数据
		 * @param disableMouse			是否禁用鼠标
		 * 
		 */
		public function MovieClipCache(bitmapDataMovieCache:BitmapDataMovieCache,disableMouse:Boolean = true)
		{
			super();
			_bitmapDataMovieCache = bitmapDataMovieCache;
			_bmp = new BitmapCache(bitmapDataMovieCache.getBitmapDataCache(_currentFrame));//第一帧
			addChild(_bmp);
			this.mouseChildren = false;
			if(disableMouse)
			{
				this.mouseEnabled = false;
			}
			//构建标签末帧字典
			buildLablesEndFrameDic();
//			play();
		}
		
		/**
		 * 构建标签最后一帧位置字典 
		 * 
		 */
		private function buildLablesEndFrameDic():void
		{
			_lablesEndFrameDic = new Dictionary();
			var label:FrameLabel;
			for (var i:uint = 0; i < currentLabels.length; i++) 
			{
				label = currentLabels[i];
				if(i+1 < currentLabels.length)
				{
					_lablesEndFrameDic[label.name] = currentLabels[i+1].frame - 1;
				}
				else
				{
					_lablesEndFrameDic[label.name] = totalFrames;
				}
			}
			
		}
		
		private function startEnterFrame():void
		{
			EnterFrameManager.getInstance().registerEnterFrameFunction(onEnterFrame);			
		}
		
		private function stopEnterFrame():void
		{
			EnterFrameManager.getInstance().removeEnterFrameFunction(onEnterFrame);
		}
		
		private function onEnterFrame(delay:int):void
		{
			nextFrame();
			//循环标签播放,在标签的最后一帧回跳
			if(_loopFrame != null)
			{
				if(currentFrame >= _lablesEndFrameDic[_loopFrame.name])
				{
					jumpFrame(_loopFrame.frame);
				}
			}
		}
		
		/**
		 * 跳转显示到某一帧 
		 * @param frame
		 * 
		 */
		private function jumpFrame(frame:int):void
		{			
			_bmp.bitmapDataCache = _bitmapDataMovieCache.getBitmapDataCache(frame);
			_currentFrame = frame;
		}
		
		/**
		 * 查找标签 
		 * @param labelName
		 * @return 
		 * 
		 */
		private function findLabel(labelName:String):FrameLabel
		{
			for (var i:uint = 0; i < currentLabels.length; i++) 
			{
				var label:FrameLabel = currentLabels[i];
				if(label.name == labelName)
				{
					return label;
				}
			}
			return null;
		}
		//-------------------- 重写的方法和属性 --------------------
		
		override public function play():void
		{
			startEnterFrame();	
		}
		
		override public function stop():void
		{
			stopEnterFrame();
		}
		
		override public function gotoAndStop(frame:Object, scene:String=null):void
		{
			stop();
			_loopFrame = null;
			if(frame is int)
			{
				jumpFrame(int(frame));
			}
			else
			{
				var label:FrameLabel = findLabel(String(frame));
				if(label != null)
				{
					jumpFrame(label.frame);
				}
				else
				{
					throw new Error("没有找到标签");
				}
			}
		}		
		/**
		 * 修改成循环在帧标签内播放 
		 * @param frame
		 * @param scene
		 * 
		 */
		override public function gotoAndPlay(frame:Object, scene:String=null):void
		{
			if(frame is int)
			{
				jumpFrame(int(frame));
				_loopFrame = null;
			}
			else
			{
				var label:FrameLabel = findLabel(String(frame));
				if(label != null)
				{
					jumpFrame(label.frame);
					_loopFrame = label;
				}
				else
				{
					throw new Error("没有找到标签");
				}
			}
			play();
		}
		
		override public function nextFrame():void
		{
			if(currentFrame >= totalFrames)
			{
				jumpFrame(1);
			}
			else
			{
				jumpFrame(currentFrame + 1);
			}
		}
		
		override public function prevFrame():void
		{
			if(currentFrame <= 1)
			{
				jumpFrame(totalFrames);
			}
			else
			{
				jumpFrame(currentFrame - 1);
			}
		}
		
		override public function get currentFrame():int
		{
			return _currentFrame;
		}
		
		override public function get totalFrames():int
		{
			return _bitmapDataMovieCache.getMC().totalFrames;
		}
		
		override public function get currentLabel():String
		{
			var myLabel:String;
			for (var i:uint = 0; i < currentLabels.length; i++) 
			{
				var label:FrameLabel = currentLabels[i];
				if(label.frame < currentFrame)
				{
					myLabel = label.name;
				}
			}			
			return myLabel;
		}
		
		override public function get currentLabels():Array
		{
			return _bitmapDataMovieCache.getMC().currentLabels;
		}
	}
}