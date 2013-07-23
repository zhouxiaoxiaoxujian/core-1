package peng.game.horse.manager
{
	import flash.display.DisplayObject;
	
	import cactus.common.frame.interfaces.IAutoScrollView;
	import cactus.common.manager.CanvasManager;
	import cactus.common.manager.SoundManager;
	import peng.game.horse.HSoundFlag;
	import peng.game.horse.core.HorseBackground;
	import cactus.ui.events.ViewEvent;

	/**
	 * 滚动背景管理器
	 * 支持in，out效果的背景管理
	 * @author Peng
	 */
	public class PBackgroundManager extends CanvasManager
	{

		//单例引用
		private static var _instance:PBackgroundManager;

		//当前场景
		private var _currentBackground:IAutoScrollView;

		private var _bgList:Vector.<IAutoScrollView>;

		public function PBackgroundManager($p:SingletonEnforcer)
		{
			
		}

		/**
		 * 单例
		 * @return
		 *
		 */
		public static function getInstance():PBackgroundManager
		{
			if (_instance == null)
			{
				_instance=new PBackgroundManager(new SingletonEnforcer());
			}
			return _instance;
		}

		/**
		 *
		 */
		public function destory():void
		{
			for each (var item:IAutoScrollView in _bgList)
			{
				(item as HorseBackground).destory();
			}
			_bgList = new Vector.<IAutoScrollView>;
		}

		public function init():void
		{
			_bgList=new Vector.<IAutoScrollView>;
		}

		
		/**
		 * 更新
		 * @param delay
		 */
		public function update(delay:int):void
		{
			if (_currentBackground)
			{
				_currentBackground.update(delay);
			}
		}
		
		/**
		 * 当前背景引用
		 * @return
		 *
		 */
		public function get currentBackground():IAutoScrollView
		{
			return _currentBackground;
		}

		/**
		 * 背景列表
		 * @return
		 */
		public function get bgList():Vector.<IAutoScrollView>
		{
			return _bgList;
		}

		/**
		 * 添加背景
		 * @param bg
		 */
		public function addBackground(bg:IAutoScrollView):void
		{
			_bgList.push(bg);
		}

		/**
		 * 是否为空 
		 * @return 
		 */
		public function isEmpty():Boolean
		{
			return _bgList.length <= 0;
		}

		/**
		 * 切换场景
		 *
		 * @param index    	切换到第index号背景
		 */
		public function changeBackgroundByIndex(index:int):void
		{
			var prevBackground:IAutoScrollView;
			if (_currentBackground != null)
			{
				prevBackground=_currentBackground;
			}
			_currentBackground=bgList[index];

			//退出前一场景
			if (prevBackground != null)
			{
				prevBackground.addEventListener(ViewEvent.SHOW_OUTED, onSceneOuted);
				prevBackground.showOut();

				var preIndex:int=bgList.indexOf(prevBackground);
				// 上楼状态
				if (index > preIndex)
				{
					SoundManager.getInstance().playSound(HSoundFlag.SChangeLevel);
				}
			}
			else
			{
				showCurrentBackground();
			}
		}

		/**
		 * 前一个视图已经退出
		 * @param e
		 */
		private function onSceneOuted(e:ViewEvent):void
		{
			var bg:DisplayObject=DisplayObject(e.target);
			bg.removeEventListener(ViewEvent.SHOW_OUTED, onSceneOuted);

			if (_canvas.contains(bg))
			{
				_canvas.removeChild(bg);
			}

			showCurrentBackground();
		}

		/**
		 * 当前背景呈现完毕
		 * @param e
		 */
		private function showCurrentBackground():void
		{
			_canvas.addChild(_currentBackground as DisplayObject);
			_currentBackground.showIn();
		}
	}
}

class SingletonEnforcer
{
}
;
