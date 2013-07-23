package peng.game.horse
{
	import flash.display.DisplayObjectContainer;
	
	import cactus.common.Global;
	import peng.game.horse.core.AutoDisposeMovieClip;
	import peng.game.horse.core.Player;

	public class CommonMotion
	{
		private static var _instance:CommonMotion = new CommonMotion;

		private var _container:DisplayObjectContainer;

		public function CommonMotion()
		{
		}

		public static function getIns():CommonMotion
		{
			return _instance;
		}

		
		/**
		 * 加分动画的combo
		 * @param countTime 	combo的次数
		 * @param extraScore	额外得到的分数
		 * @param x
		 * @param y  
		 */
		public function playComboScore(countTime:int,	extraScore:int,	 x:Number = 0, y:Number = 0):void
		{
			var mc:AutoDisposeMovieClip = new AutoDisposeMovieClip("MotionCombo");
			mc.mouseEnabled = false;
			mc.mouseChildren = false;
			mc.x = x;
			mc.y = y;
			mc.body["mc_content"]["txt_count1"].text =  String(countTime);
			mc.body["mc_content"]["txt_count2"].text =  "+ "+String(extraScore);
			
			_container.addChild(mc);  
			
		}
		
		
		/**
		 * 加分动画
		 * @param count
		 * @param x
		 * @param y  
		 */
		public function addScore(count:int, x:Number = 0, y:Number = 0):void
		{
			var mc:AutoDisposeMovieClip = new AutoDisposeMovieClip("MotionAddScore");
			mc.mouseEnabled = false;
			mc.mouseChildren = false;
			mc.x = x;
			mc.y = y;
			mc.body["mc_content"]["txt_count"].text = "+" + String(count);

			_container.addChild(mc);  
			
		}

		/**
		 * 减去苹果的动画
		 * @param count
		 * @param x
		 * @param y
		 */
		public function plusApple(count:int, x:Number = 0, y:Number = 0):void
		{
			var mc:AutoDisposeMovieClip = new AutoDisposeMovieClip("MotionPlusApple");
			mc.mouseEnabled = false;
			mc.mouseChildren = false; 
			mc.x = x;
			mc.y = y;
			mc.body["mc_content"]["txt_count"].text = "-" + String(count);

			_container.addChild(mc);
		}

		/**
		 * 吃掉苹果的动画
		 * @param x
		 * @param y
		 */
		public function eatApple(x:Number = 0, y:Number = 0):void
		{
			var mc:AutoDisposeMovieClip = new AutoDisposeMovieClip("PropAppleFall");
			mc.mouseEnabled = false;
			mc.mouseChildren = false;
			mc.x = x;
			mc.y = y;

			_container.addChild(mc);
		}

		/**
		 * 普通敌人坠落
		 * @param x
		 * @param y 
		 */
		public function commonEnemyFall(x:Number = 0, y:Number = 0):void
		{
			var mc:AutoDisposeMovieClip = new AutoDisposeMovieClip("CommonEnemyFall");
			mc.mouseEnabled = false;
			mc.mouseChildren = false;
			mc.x = x;
			mc.y = y;

			_container.addChild(mc);
		}

		public function middleEnemyFall(x:Number = 0, y:Number = 0):void
		{
			var mc:AutoDisposeMovieClip = new AutoDisposeMovieClip("MiddleEnemyFall");
			mc.mouseEnabled = false;
			mc.mouseChildren = false;
			mc.x = x;
			mc.y = y;
			
			_container.addChild(mc);
		}
		
		public function seniorEnemyFall(x:Number = 0, y:Number = 0):void
		{
			var mc:AutoDisposeMovieClip = new AutoDisposeMovieClip("SeniorEnemyFall");
			mc.mouseEnabled = false;
			mc.mouseChildren = false;
			mc.x = x;
			mc.y = y;
			
			_container.addChild(mc);
		}

		public function get container():DisplayObjectContainer
		{
			return _container;
		}

		public function set container(value:DisplayObjectContainer):void
		{
			_container = value;
		}
	}
}
