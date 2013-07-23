package peng.game.horse.prop
{
	import cactus.common.Global;
	import cactus.common.frame.interfaces.IVehicle;
	import cactus.common.manager.ComboManager;
	import cactus.common.manager.SoundManager;
	import cactus.common.tools.Hook;
	import cactus.common.tools.util.MathUtil;
	import cactus.common.xx.goem.Vector2D;
	import cactus.ui.events.ViewEvent;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import peng.common.Config;
	import peng.game.horse.HSoundFlag;
	import peng.game.horse.core.Player;
	import peng.game.horse.enumerate.EnumCombo;
	import peng.game.horse.event.HorseEvent;
	import peng.game.horse.manager.HStatManager;
	import peng.game.horse.model.HorseModel;

	/**
	 * 普通的敌人
	 * @author Peng
	 */
	public class Enemy extends BaseProp
	{
		// 定义敌人种类
		public static var TYPE_COMMON:int = 0;
		public static var TYPE_MIDDLE:int = 1;
		public static var TYPE_SENIOR:int = 2;


		/**
		 *
		 */
		protected var _body:MovieClip;

		/**
		 * Y轴的振动幅度
		 */
		private var _springRangeY:Number;

		public function Enemy(pRadius:Number = 10)
		{
			super(pRadius);
		}

		override public function init():void
		{
			_springRangeY = MathUtil.random(Global.mapToWidth(15), Global.mapToHeight(60));
			maxSpeed = 40;
		}

		override public function destory():void
		{
			_body.stop();
			super.destory();
		}

		public function getEnemyType():int
		{
			throw new Error("no impl");
		}

		override public function get body():MovieClip
		{
			return _body;
		}

		override public function update(delay:int):void
		{
			super.update(delay);
		}

		override public function showIn():void
		{
			// 移动到屏幕中的垂直点位
			var toPoint:Point = new Point(this.x, Global.screenH * Math.random());

//			trace("showin",this.x,this.y,toPoint.x,toPoint.y);
			// 加入缓动效果
			TweenLite.to(this, 1.5, {x: toPoint.x, y: toPoint.y, ease: Back.easeOut, onComplete: super.showIn()});
		}

		override protected function onShowIned(event:ViewEvent):void
		{
//			trace("onShowIned",this.x,this.y);
			// 敌人的初始速度
			this.velocity = new Vector2D(Global.mapToWidth(-15) - (Math.random() * 5), 0);
		}

		override public function collide($player:IVehicle):void
		{
			var player:Player = $player as Player;

			// 无敌状态
			if (HStatManager.getIns().zooling)
			{
				HStatManager.getIns().currDestory++;
				beDestory();
				return;
			}

			// 非无敌状态
			// 没有盾牌
			// 这段下落时间内，应该是点击起飞无效的
			if (!HorseModel.getIns().hasArmor)
			{
				player.collideWithEnemy();

				Config.bPlayerCanNotFly = true;
				var timeoutId:uint = setTimeout(function():void
				{
					Config.bPlayerCanNotFly = false;
					clearTimeout(timeoutId);
				}, Hook.getInt("player_frozeen_after_collide_enemy"));
			}

			// 清空加分的Combo
			ComboManager.getIns().resetCombo(EnumCombo.ADD_BOUNS);
			ComboManager.getIns().resetCombo(EnumCombo.EAT_APPLE)
			
			showOut();

			SoundManager.getInstance().playSound(HSoundFlag.SCollideHen);
		}

		/**
		 * 被击落
		 */
		private function beDestory():void
		{
			dispatchEvent(new HorseEvent(HorseEvent.SHOW_BE_DESTORY, [new Point(this.x, this.y), getEnemyType()]));

			super.showOut();
		}

	}
}
