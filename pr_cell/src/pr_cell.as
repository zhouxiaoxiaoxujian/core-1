package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	import cactus.common.AndroidGameWorld;
	import cactus.common.Engine;
	import cactus.common.tools.util.Debugger;

	public class pr_cell extends Engine
	{
		public function pr_cell()
		{
			// 支持 autoOrient
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			super(gameStart, AndroidGameWorld);
		}


		private function gameStart() : void
		{
			Debugger.debug("游戏启动");
		}
	}
}
