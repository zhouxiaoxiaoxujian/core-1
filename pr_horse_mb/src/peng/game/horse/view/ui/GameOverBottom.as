package peng.game.horse.view.ui
{
	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.PTextField;
	
	public class GameOverBottom extends PAutoView
	{
		
//		 public var txt_gameover_tip_PB:PTextField = new PTextField;
		
		public function GameOverBottom($sourceName:String=null)
		{
			super($sourceName);
		}
		
		override public function init():void
		{
			super.init();
			
//			 txt_gameover_tip_PB.text = "{gameover_tip}";
		}
	}
}