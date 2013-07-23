package peng.game.horse.prop
{
	import flash.display.BitmapData;
	
	import peng.common.Config;
	import cactus.common.Global;
	import cactus.common.frame.scheduler.Scheduler;
	import cactus.common.xx.goem.Vector2D;
	import peng.game.horse.core.FloatObject;
	import peng.game.horse.core.HorseBackground;
	import peng.game.horse.core.IHorseBackground;

	/**
	 * 道具工厂
	 * @author Peng
	 */
	public class GameFactory
	{
		public function GameFactory()
		{
		}

		/**
		 * 创建背景
		 * @return
		 *
		 */
		public static function createBackground(data:BitmapData = null, speedX:Number = 0, speedY:Number = 0, offsetX:Number = 0, offsetY:Number = 0):IHorseBackground
		{
			var bg:HorseBackground = new HorseBackground;
			bg.mouseChildren = false;
			bg.mouseEnabled = false;
			if (data)
			{
				bg.init(data);
				bg.setScrollSpeed(speedX, speedY);
				bg.setOffset(offsetX, offsetY);
			}
			return bg;
		}

		/**
		 * 创建苹果
		 * @return
		 */
		public static function createApple():IProp
		{
			var item:IProp;
			var vx:Number;

			// 以一定的概率出现
			var random:Number = Math.random();
			if (random < 0.8)
			{
				item = new CommonApple;
				vx = 0 - Math.random() * Global.mapToWidth(25) - 10;
			}
//			else if (random < 0.8)
//			{
//				item = new BigApple;
//			}
			else
			{
				item = new MultiApple;
				vx = 0 - Math.random() * Global.mapToWidth(25) - 2;
			}

			// 初始位置在屏幕右侧外
			var initX:Number = Global.screenW + item.radius;
			var initY:Number = Global.screenH * Math.random() - item.radius;
			item.initPosition(new Vector2D(initX, initY));

			// 随机速度
			item.velocity = new Vector2D(vx, 0);
			return item;
		}
		
		/**
		 * 创建敌人
		 * @return
		 */
		public static function createEnemy():IProp
		{
			var item:IProp;
			var random:Number

			var tick:uint = Scheduler.getIns().getTime();
			
			// 不同的飞行时间
			if (tick < 30000)
			{
				item = new CommonEnemy();
			}
			else if (tick < 60000)
			{
				random = Math.random();

				if (random < 0.8)
				{
					item = new CommonEnemy();
				}
				else
				{
					item = new MiddleEnemy();
				}
			}
			else
			{
				random = Math.random();

				if (random < 0.6)
				{
					item = new CommonEnemy();
				}
				else if (random < 0.8)
				{
					item = new MiddleEnemy();
				}
				else
				{
					item = new SeniorEnemy();
				}
			}


			// 初始位置在屏幕上方的右侧
			var initX:Number = Global.mapToScreenX(500) + Math.random() * Global.mapToWidth(150) + item.radius;
			var initY:Number = 0 - item.radius;
			item.initPosition(new Vector2D(initX, initY));

			// 随机速度
			item.showIn();
			return item;
		}


		/**
		 * 创建无敌道具
		 * @return
		 */
		public static function createZool():IProp
		{
			var item:IProp = new PropZool();

			// 初始位置在屏幕右侧外
			var initX:Number = Global.screenW + item.radius;
			var initY:Number = Global.screenH * Math.random() - item.radius;
			item.initPosition(new Vector2D(initX, initY));

			// 随机速度
			var vx:Number = 0 - Math.random() * Global.mapToWidth(10) - Global.mapToWidth(8);
			item.velocity = new Vector2D(vx, 0);

			return item;
		}

		/**
		 * 创建吸铁石道具
		 * @return
		 */
		public static function createMagnet():IProp
		{
			var item:IProp = new PropMagnet();

			// 初始位置在屏幕右侧外
			var initX:Number = Global.screenW + item.radius;
			var initY:Number = Global.screenH * Math.random() - item.radius;
			item.initPosition(new Vector2D(initX, initY));

			// 随机速度
			var vx:Number = 0 - Math.random() * Global.mapToWidth(10) - Global.mapToWidth(8);
			item.velocity = new Vector2D(vx, 0);

			return item;
		}

		/**
		 * 创建漂浮物
		 * @return
		 *
		 */
		public static function createFloatObject(linkage:String):FloatObject
		{
			var item:FloatObject = new FloatObject(linkage, FloatObject.DIR_RIGHT_TO_LEFT)
			item.mouseChildren = false;
			item.mouseEnabled = false;

			// 近大远小规则，越小的物体漂浮速度越慢
			var randomSizeRatio:Number = Math.random();
			randomSizeRatio = randomSizeRatio < 0.3 ? 0.3 : randomSizeRatio;
			item.scaleX = item.scaleY = randomSizeRatio;

			item.alpha = randomSizeRatio + 0.1;

			var randomVx:Number = 0 - randomSizeRatio * randomSizeRatio * Global.mapToWidth(12);
			item.velocity = new Vector2D(randomVx, 0);

			// 初识在屏幕外
			var px:Number = Global.screenW;
			var py:Number = Global.screenH * Math.random() - Global.mapToHeight(50);
			item.position = new Vector2D(px, py);
			return item;
		}

		/**
		 * 创建云层
		 * @param linkage
		 * @return
		 *
		 */
		public static function createCloudObject(linkage:String):FloatObject
		{
			var item:FloatObject = new FloatObject(linkage, FloatObject.DIR_RIGHT_TO_LEFT)
			item.mouseChildren = false;
			item.mouseEnabled = false;

			// 近大远小规则，越小的物体漂浮速度越慢
			var randomSizeRatio:Number = Math.random();
			randomSizeRatio = randomSizeRatio < 0.4 ? 0.4 : randomSizeRatio;
			item.scaleX = item.scaleY = randomSizeRatio;

			var randomVx:Number = 0 - randomSizeRatio * randomSizeRatio * Global.mapToWidth(16);
			item.velocity = new Vector2D(randomVx, 0);

			item.alpha = Math.random() + 0.3;
			// 初识在屏幕外
			var px:Number = Global.screenW;
			var py:Number = Global.screenH * Math.random();
			item.position = new Vector2D(px, py);
			return item;
		}

		/**
		 * 创建云条
		 * @param linkage
		 * @return
		 *
		 */
		public static function createCloudNoddle():FloatObject
		{
			var item:FloatObject = new FloatObject("CloudNoddle1", FloatObject.DIR_RIGHT_TO_LEFT)
			item.mouseChildren = false;
			item.mouseEnabled = false;

			// 近大远小规则，越小的物体漂浮速度越慢
			var randomSizeRatio:Number = Math.random();
			randomSizeRatio = randomSizeRatio < 0.4 ? 0.4 : randomSizeRatio;
			item.scaleX = item.scaleY = randomSizeRatio;

			item.alpha = randomSizeRatio;

			var randomVx:Number = 0 - randomSizeRatio * Global.mapToWidth(50);
			item.velocity = new Vector2D(randomVx, 0);

			// 初识在屏幕外
			var px:Number = Global.screenW;
			var py:Number = Global.screenH * Math.random();
			item.position = new Vector2D(px, py);
			return item;
		}

		private static function createCommonApple():IProp
		{
			return new CommonApple();
		}

		private static function createBigApple():IProp
		{
			return new BigApple();
		}

		private static function createMultiApple():IProp
		{
			return new MultiApple();
		}


	}
}
