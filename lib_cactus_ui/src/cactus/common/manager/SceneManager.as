
package cactus.common.manager
{
	import cactus.ui.base.BaseScene;
	import cactus.ui.base.BaseView;
	import cactus.ui.events.ViewEvent;

	/**
	 * 场景管理器
	 * @author Pengx
	 * @version 1.0
	 * @created 03-八月-2010 14:19:09
	 */
	public class SceneManager extends CanvasManager
	{
		//单例引用
		private static var _instance:SceneManager;
		
		//当前场景
		private var _currentScene:BaseScene;
		
		
		public function SceneManager(param:SingletonEnforcer){
			
		}
		
		/**
		 * 当前场景引用 
		 * @return 
		 * 
		 */
		public function get currentScene():BaseScene
		{
			return _currentScene; 
		}
		
		/**
		 * 单例 
		 * @return 
		 * 
		 */
		public static function getInstance():SceneManager
		{
			if(_instance==null)
			{
				_instance = new SceneManager(new SingletonEnforcer());			
			}
			return _instance;
		}	   
		
		/**
		 * 切换场景
		 * 
		 * @param className    	要为场景创建的对象的类。该类必须继承自 BaseScene
		 * @param params    	传递给面板的数据
		 */
		public function changeScene(className:Class, params:Array = null):BaseScene
		{
			var prevScene:BaseScene;
			if(_currentScene != null)
			{
				prevScene = _currentScene;
			}
			_currentScene = new className() as BaseScene;
			_currentScene.setPrepareParams(params);
			//退出前一场景
			if(prevScene != null)
			{
				prevScene.addEventListener(ViewEvent.SHOW_OUTED,onSceneOuted);
				prevScene.showOut();
			}
			else
			{
				_currentScene.addEventListener(ViewEvent.ALL_READY,onSceneReady);
				_currentScene.prepareReady();
			}
			
			return _currentScene;
		}	
		
		private function onSceneOuted(e:ViewEvent):void
		{
			var v:BaseView = BaseView(e.target);
			v.removeEventListener(ViewEvent.SHOW_OUTED,onSceneOuted);
			if(_canvas.contains(v))
			{
				_canvas.removeChild(v);
			}
			_currentScene.addEventListener(ViewEvent.ALL_READY,onSceneReady);
			_currentScene.prepareReady();
		}
		
		private function onSceneReady(e:ViewEvent):void
		{			
			_currentScene.removeEventListener(ViewEvent.ALL_READY,onSceneReady);
			_canvas.addChild(_currentScene);
			_currentScene.showIn();
		}
		
	}//end SceneManager
}
class SingletonEnforcer{};