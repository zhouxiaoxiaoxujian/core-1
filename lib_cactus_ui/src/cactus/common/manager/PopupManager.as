package cactus.common.manager
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import cactus.ui.base.BasePopupPanel;
	import cactus.ui.events.ViewEvent;

	/**
	 * 弹窗管理器
	 * @author Peng
	 */
	public class PopupManager
	{
		//单例引用
		private static var _instance:PopupManager;

		//-----基本弹窗
		//每个弹窗的子弹窗列表字典
		private var _childPanelListDic:Dictionary = new Dictionary(true);

		//-----顶层弹窗
		private var _currentTopPanel:BasePopupPanel;
		private var _topPanelQueue:Vector.<BasePopupPanel> = new Vector.<BasePopupPanel>();

		//-----遮挡
		private var _screenMask:Sprite;

		public function PopupManager(param:SingletonEnforcer)
		{

		}

		public function get currentTopPanel():BasePopupPanel
		{
			return _currentTopPanel;
		}

		/**
		 * 单例
		 * @return
		 *
		 */
		public static function getInstance():PopupManager
		{
			if (_instance == null)
			{
				_instance = new PopupManager(new SingletonEnforcer());
			}
			return _instance;
		}

		/**
		 * 弹出普通弹窗
		 *
		 * @param className    要为弹出窗口创建的对象的类。该类必须继承自 BasePopupPanel
		 * @param parent    父显示对象
		 * 如果有，把此弹窗加入父显示对象所在弹窗的子列表。
		 * (上层弹窗消失和上移等操作时都会影响到子弹窗的显示)
		 * 如果没有，直接在顶层弹出
		 * @param params    传递给面板的数据
		 * @param x    弹出面板的横坐标(默认居中)
		 * @param y    弹出面板的纵坐标(默认居中)
		 * @param popLayer 弹出的容器，默认出现在getCanvas的弹出层。
		 */
		public function showPanel(instance:*, parent:DisplayObjectContainer = null, params:Array = null, x:int = -99999, y:int = -99999,popLayer:DisplayObjectContainer=null):void
		{
			//-----构建面板-----
			var panel:BasePopupPanel;

			if (instance is BasePopupPanel)
				panel = instance;
			else if (instance is Class)
				panel = new instance() as BasePopupPanel;
			else
				throw new Error("PopupManager instance error");


			panel.setPrepareParams(params);
			if (x == -99999)
			{
				x = canvas.stage.stageWidth / 2;
			}
			if (y == -99999)
			{
				y = canvas.stage.stageHeight / 2;
			}
			panel.x = x;
			panel.y = y;

			//-----父窗口处理-----
			while (parent != null && !(parent is BasePopupPanel))
			{
				parent = parent.parent;
			}
			if (parent != null)
			{
				if (_childPanelListDic[parent] == null)
				{
					_childPanelListDic[parent] = new Vector.<BasePopupPanel>();
				}
				_childPanelListDic[parent].push(panel);
			}
			//-----弹出----

			__showPanel(panel,popLayer);
		}

		//显示普通弹窗
		// popLayer 弹出的层，默认为初始设置的canvas
		private function __showPanel(panel:BasePopupPanel,popLayer:DisplayObjectContainer=null):void
		{
			addMask(panel);
			
			if (!popLayer)
				canvas.addChild(panel);	
			else
				popLayer.addChild(panel);			
				
			
			panel.addEventListener(ViewEvent.SHOW_IN, __onPanelReady);
			panel.addEventListener(ViewEvent.SHOW_OUTED, __onPanelClose);
			panel.prepareReady();
		}

		//全部准备好了，弹出弹窗
		private function __onPanelReady(e:ViewEvent):void
		{
			e.currentTarget.removeEventListener(ViewEvent.SHOW_IN,__onPanelReady);
			e.currentTarget.showIn();
		}

		//当普通弹窗关闭时，关闭子弹窗
		private function __onPanelClose(e:ViewEvent):void
		{
			e.currentTarget.removeEventListener(ViewEvent.SHOW_OUTED,__onPanelClose);
			
			__hideChildPanel(BasePopupPanel(e.currentTarget));
			removeMask(BasePopupPanel(e.currentTarget));
			delete _childPanelListDic[e.currentTarget];
		}

		//隐藏窗口，ifHideMe：是否隐藏自己
		private function __hideChildPanel(panel:BasePopupPanel, ifHideMe:Boolean = false):void
		{
			var childList:Vector.<BasePopupPanel> = _childPanelListDic[panel];
			if (childList != null)
			{
				var len:int = childList.length;
				for (var i:int = 0; i < len; i++)
				{
					__hideChildPanel(childList[i], true);
				}
			}
			if (ifHideMe)
			{
				if (panel.parent != null)
				{
					panel.showOut();
				}
			}
		}

		/**
		 * 弹出顶层弹窗（队列弹出或单个显示）
		 * @param instance		要为弹出窗口创建的对象的类或者实例。该类必须继承自 BasePopupPanel
		 * @param params		传递给面板的数据
		 * @param ifShowNow		是否马上显示(否则加入弹窗队列等待显示)
		 */
		public function showTopPanel(instance:*, params:Array = null, ifShowNow:Boolean = false):void
		{
			var panel:BasePopupPanel;

			if (instance is BasePopupPanel)
				panel = instance;
			else if (instance is Class)
				panel = new instance() as BasePopupPanel;
			else
				throw new Error("PopupManager instance error");

			//-----构建面板-----
			panel.setPrepareParams(params);
			panel.x = canvas.stage.stageWidth / 2;
			panel.y = canvas.stage.stageHeight / 2;

			//-----加入队列-----
			if (ifShowNow)
			{
				//本窗口加入都列头
				_topPanelQueue.unshift(panel);
				if (_currentTopPanel != null)
				{
					_currentTopPanel.showOut();
				}
			}
			else
			{
				//本窗口加入队列尾
				_topPanelQueue.push(panel);
			}

			//-----如果当前没有弹窗，则弹出第一个弹窗-----			
			if (_currentTopPanel == null)
			{
				_currentTopPanel = _topPanelQueue.shift();
				__showTopPanel();
			}
		}

		/**
		 * 清除顶层弹窗队列
		 *
		 */
		public function clearTopPanelQueue():void
		{
			_topPanelQueue = new Vector.<BasePopupPanel>();
		}


		private var _canvas:DisplayObjectContainer;

		/**
		 * 获得画布(容器)
		 *
		 */
		public function get canvas():DisplayObjectContainer
		{
			return _canvas;
		}

		/**
		 * 设置画布(容器)
		 * @param canvas
		 */
		public function setCanvas(canvas:DisplayObjectContainer):void
		{
			//			if(_canvas != null)
			//			{
			//				throw new Error("不能重复设置画布（容器）!");
			//			}
			_canvas = canvas;
		}


		//显示顶层面板
		private function __showTopPanel():void
		{
			addMask(_currentTopPanel);
			canvas.addChild(_currentTopPanel);
			_currentTopPanel.addEventListener(ViewEvent.SHOW_IN, __onTopPanelReady);
			_currentTopPanel.addEventListener(ViewEvent.SHOW_OUTED, __onTopPanelClose);

			// prepareReady不能调用一次以上，否则造成位置等错误
			_currentTopPanel.prepareReady();
		}

		//全部准备好了，弹出弹窗
		private function __onTopPanelReady(e:ViewEvent):void
		{
			e.currentTarget.removeEventListener(ViewEvent.SHOW_IN,__onTopPanelReady);
			e.currentTarget.showIn();
		}

		//当顶层窗口关闭时
		private function __onTopPanelClose(e:ViewEvent):void
		{
			__hideChildPanel(BasePopupPanel(e.currentTarget));
			removeMask(BasePopupPanel(e.currentTarget));
			delete _childPanelListDic[e.currentTarget];
			_currentTopPanel.removeEventListener(ViewEvent.SHOW_OUTED, __onTopPanelClose);
			//弹出下一个
			if (_topPanelQueue.length > 0)
			{
				_currentTopPanel = _topPanelQueue.shift();
				__showTopPanel();
			}
			else
			{
				_currentTopPanel = null;
			}
		}

		private var _maskTable:Dictionary = new Dictionary();
		private function addMask(basePop:BasePopupPanel) : void
		{
			if ( basePop.hasMask())
			{
				_maskTable[basePop] = createMask();
				canvas.addChild(_maskTable[basePop]);	
			}
		}
		
		private function removeMask(basePop:BasePopupPanel) : void
		{
			if (basePop.hasMask() && canvas.contains(_maskTable[basePop]))
			{
				canvas.removeChild(_maskTable[basePop]);
				delete _maskTable[basePop]
			}
		}

		private function createMask():Sprite
		{
			var sp:Sprite = new Sprite();
			
			with (sp.graphics)
			{
				beginFill(0x000000, .5);
				drawRect(-100, -100, canvas.stage.stageWidth + 200, canvas.stage.stageHeight + 200);
				endFill();
			}
			return sp;
		}

	} //end PopupPanelManager
}

class SingletonEnforcer
{
}
;
