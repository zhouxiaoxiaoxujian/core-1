package cactus.common.xx.formation
{
	import cactus.common.xx.formation.formula.BaseFormula;

	/**
	 * 应用数学公式的阵型
	 * @author Peng
	 */
	public class MathFormation extends BaseFormation
	{
		private var _formula:BaseFormula;

		public function MathFormation($formula:BaseFormula)
		{
			super();

			_formula = $formula;
		}

		override protected function loadItems(items:Array):void
		{
			var item:*;
			for each (item in items)
			{
				_formula.process(item);
			}
		}
	}
}