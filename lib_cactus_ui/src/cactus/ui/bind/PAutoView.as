package cactus.ui.bind
{
	import flash.events.Event;

	public class PAutoView extends PView
	{
		public function PAutoView($sourceName:* = null)
		{
			super($sourceName);

			// 只有非嵌套组件才可以去准备
			if ($sourceName)
			{
				addEventListener(Event.ADDED_TO_STAGE, onViewAddToStage, false, int.MIN_VALUE);
			}
		}

		protected function onViewAddToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onViewAddToStage);
			prepareReady();
		}
	}
}