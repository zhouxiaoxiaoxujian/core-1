package peng.game.horse.model
{

	public class RankVO
	{
		private static var _data:Vector.<RankVO> = new Vector.<RankVO>;

		// 排名
		public var rank:int;

		// 分数
		public var score:int;

		public function RankVO()
		{
		}

		public static function getRankList():Vector.<RankVO>
		{
			return _data;
		}

		public static function addVO(vo:RankVO):void
		{
			_data.push(vo);
		}

		public static function clear():void
		{
			_data = new Vector.<RankVO>;
		}
	}
}