
package cactus.ui.base
{


	/**
	 * 场景基类
	 * @author Pengx
	 * @version 1.0
	 * @created 03-八月-2010 14:19:08
	 */
	public class BaseScene extends BaseView
	{
		public function BaseScene()
		{
			super();
		}

		override protected function onShowOuted() : void
		{
			super.onShowOuted();
			// 正常情况下，SceneManager会自动将场景从容器中移除
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
		}

	} //end BaseScene

}
