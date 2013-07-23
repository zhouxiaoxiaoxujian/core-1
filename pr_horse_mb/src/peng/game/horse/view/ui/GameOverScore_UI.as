package peng.game.horse.view.ui
{
	import flash.text.TextField;
	
	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.PTextField;
	
	public class GameOverScore_UI extends PAutoView
	{
		
		/**
		 * 总距离
		 */
		public var txt_distance_PB:TextField;
		
		/**
		 * 总时间
		 */
		public var txt_time_PB:TextField;
		
		/**
		 * 总击毁数
		 */
		public var txt_destory_PB:TextField;
		
		/**
		 * 总得分
		 */
		public var txt_totalCount_PB:TextField;
		
		public var txt_gameover_score_PB:PTextField = new PTextField;
		public var txt_gameover_distance_PB:PTextField = new PTextField;
		public var txt_gameover_time_PB:PTextField = new PTextField;
		public var txt_gameover_bring_down_point_PB:PTextField = new PTextField;
		
		public function GameOverScore_UI($sourceName:String=null)
		{
			super($sourceName);
		}
	}
}