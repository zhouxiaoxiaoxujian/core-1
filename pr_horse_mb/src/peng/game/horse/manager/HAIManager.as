package peng.game.horse.manager
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import cactus.common.manager.EnterFrameManager;
	import peng.game.horse.core.Player;
	import peng.game.horse.prop.GameFactory;
	import peng.game.horse.prop.IProp;
	import peng.game.horse.view.scene.GamePlayScene;
	import peng.game.horse.view.ui.GamePlayView_UI;
	import cactus.ui.bind.PView;
	
	public class HAIManager
	{
		private static var _instance:HAIManager = new HAIManager;
		
		/**
		 * 游戏主场景
		 */
		private var _gameScene:GamePlayScene;
		
		/**
		 * 玩家
		 */
		private var _player:Player;
		
		/**
		 * 主页面UI
		 */
		private var _ui:GamePlayView_UI;
		
		/**
		 * 游戏碰撞世界
		 */
		private var _world:Sprite;
		
		/**
		 * 道具列表
		 */
		private var _propsList:Vector.<IProp>;
		
		public function HAIManager()
		{
		}
		
		
		
		public static function getIns():HAIManager
		{
			return _instance;
		}
		
		public function destory():void
		{
			_propsList = new Vector.<IProp>;
		}
		
		public function init($gameScene:GamePlayScene):void
		{
			_gameScene = $gameScene;
			_player = _gameScene.player;
			_ui = _gameScene.uiLayer;
			_world = _gameScene.worldLayer;
			
			// 初始化数据
			_propsList = new Vector.<IProp>;
			
			EnemyDecider.reset();
			PropDecider.reset();
			UserEquipDecider.reset();
		}
		
		/**
		 * 道具管理器的主更新
		 * @param delay
		 */
		public function update(delay:int):void
		{
			// 更新玩家
			if (_player)
			{
				_player.update(delay);
			}
			
			// 更新道具
			var prop:IProp;
			for each (prop in _propsList)
			{
				// 检查是否碰撞
				if (checkCollision(_player, prop))
				{
					prop.collide(_player);
				}
				else
				{
					prop.update(delay);
				}
			}
			
			// 更新苹果
			PropDecider.decide();
			
			// 更新敌人
			EnemyDecider.decide();
			
			// 更新玩家装备的道具
			UserEquipDecider.decide();
		}
		
		public function get player():Player
		{
			return _player;
		}
		
		/**
		 * 碰撞检测
		 * @param player
		 * @param prop
		 * @return
		 */
		private function checkCollision(player:Player, prop:IProp):Boolean
		{
			var x1:Number = player.x;
			var y1:Number = player.y;
			
			var x2:Number = prop.x;
			var y2:Number = prop.y;
			
			return (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2) < (player.radius + prop.radius) * (player.radius + prop.radius);
		}
		
		/**
		 * 从世界中移除一个道具
		 * @param item
		 */
		public function removeProp(item:IProp):void
		{
			removePropFromList(item);
			removePropFromDisplay(item);
		}
		
		/**
		 * 从List中删除
		 * @param item
		 */
		public function removePropFromList(item:IProp):void
		{
			var index:int = _propsList.indexOf(item);
			if (index != -1)
			{
				_propsList.splice(index, 1);
			}
		}
		
		/**
		 * 从显示列表移除
		 * @param item
		 */
		public function removePropFromDisplay(item:IProp):void
		{
			_world.removeChild(DisplayObject(item));
		}
		
		/**
		 * 加入到道具列表
		 * @param item
		 */
		private function addItemToWorld(item:IProp):void
		{
			_world.addChild(item as DisplayObject);
			_propsList.push(item);
		}
		
		/**
		 * 加入一组到道具列表 
		 */
		private function addItemsToWorld(items:Array):void
		{
			for each (var item:IProp in items) 
			{
				addItemToWorld(item);
			}
		}
		
		/**
		 * 加入一个普通苹果
		 */
		public function addApple():void
		{
			addItemToWorld(GameFactory.createApple());
		}
		
		/**
		 * 加入敌人
		 *
		 */
		public function addEnemy():void
		{
			addItemToWorld(GameFactory.createEnemy());
		}
		
		/**
		 * 加入无敌道具
		 */
		public function addZool():void
		{
			addItemToWorld(GameFactory.createZool());
		}
		
		/**
		 * 加入吸铁石道具
		 */
		public function addMagnet():void
		{
			addItemToWorld(GameFactory.createMagnet());
		}
	}
}
import peng.common.Config;
import cactus.common.frame.scheduler.Scheduler;
import cactus.common.tools.Hook;
import peng.game.horse.enumerate.Enum;
import peng.game.horse.manager.HAIManager;
import peng.game.horse.manager.HStatManager;
import peng.game.horse.model.HorseModel;

/**
 * tick为已经飞行的距离
 * 飞行距离越远敌人越多
 * 【todo】楼层越高敌人越少，鼓励玩家向高层飞
 * @author Peng
 */
class EnemyDecider
{
	private static var clock:uint = 0;
	
	// 下一个敌人出现的时间点
	private static var endTime:int;
	// 下一个敌人出现的随机时间
	private static var randomNextEnemyTime:int;
	// 等待下一个敌人出现
	private static var bDecideNextEnemy:Boolean = true;
	
	public function EnemyDecider()
	{
	}
	
	public static function reset():void
	{
		clock = 0;
	}
	
	/**
	 * 是否可以投放敌人
	 * @param tick
	 * @return
	 */
	public static function decide():void
	{
		var time:uint = Scheduler.getIns().getClock().getEnumClock(Enum.GAMEING_TIME);
		
		//		HAIManager.getIns().addEnemy();
		//		return;
		
		// 测试 结束
		
		
		// 最先一段时间没有敌人
		if (time < 6000 / Config.DEBUG_AI_ENEMY_ADD_THREDHOLD)
		{
			return;
		}
		
		// 随机一段时间，出一个敌人
		// 比如3-5秒钟出现一个敌人
		if (bDecideNextEnemy)
		{
			bDecideNextEnemy = false;
			
			randomNextEnemyTime = Math.random() * getRandomInterval() + getNextEnemyMinInterval();
			endTime = time + randomNextEnemyTime;
		}
		else
		{
			if (time > endTime)
			{
				HAIManager.getIns().addEnemy();
				bDecideNextEnemy = true;
			}
		}
		
	}
	
	private static function getRandomInterval():int
	{
		return 2000;
	}
	
	private static function getNextEnemyMinInterval():int
	{
		return 3000;
	}
}

/**
 * @author Peng
 */
class PropDecider
{
	private static var appleClock:uint = 0;
	private static var zoolClock:uint = 0;
	
	/**
	 * 苹果出现阀值，1为没有区别
	 * @default
	 */
	private static const appleThreshold:int = 10;
	
	public function PropDecider()
	{
	}
	
	/**
	 * 是否可以投放道具
	 * @param tick
	 * @return
	 */
	public static function decide():void
	{
		// 30 为 1秒
		// 500 为  16 秒
		// 1000 为 33 秒
		appleClock++;
		zoolClock++;
		//		HAIManager.getIns().addApple();
		//		return;
		var time:uint = Scheduler.getIns().getClock().getEnumClock(Enum.GAMEING_TIME);
		
		// 最开始一段时间各个层出现苹果的几率没有区别
		if (time < 25000 / Config.DEBUG_AI_ENEMY_ADD_THREDHOLD)
		{
			if (appleClock == 20)
			{
				HAIManager.getIns().addApple();
				appleClock = 0;
			}
		}
		else
		{
			// 苹果的数量与楼层数成反比，楼层越高苹果越少
			if (appleClock % (10 + HStatManager.getIns().currLevel * appleThreshold) == 0)
			{
				HAIManager.getIns().addApple();
				appleClock = 0;
			}
		}
		// 飞行越远无敌道具越少
		// 150 为基数
		if (zoolClock % (int(HStatManager.getIns().currDistance / 3) + 150) == 0)
		{
			HAIManager.getIns().addZool();
			zoolClock = 0;
		}
		
	}
	
	public static function reset():void
	{
		appleClock = 0;
		zoolClock = 0;
	}
}




/**
 * @author Peng
 */
class UserEquipDecider
{
	
	private static var magnetClock:uint = 0;
	
	public function UserEquipDecider()
	{
	}
	
	/**
	 * 是否可以投放道具
	 * @param tick
	 * @return
	 */
	public static function decide():void
	{
		magnetClock++;
		
		//		// 间隔一定的时间出现道具
		//		if (HorseModel.getIns().hasMagnet && magnetClock % Hook.getNumber("magnetIntervalFrame") == 0)
		//		{
		//			HAIManager.getIns().addMagnet();
		//			magnetClock = 0;
		//		}
		//
		//		if (HorseModel.getIns().hasRocket)
		//		{
		//		}
	}
	
	public static function reset():void
	{
	}
}