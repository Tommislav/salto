package unittests.se.isotop.video.startup.dummyModules 
{
	import se.isotop.video.startup.BaseStartupModule;
	
	/**
	 * ...
	 * @author Tommy Salomonsson
	 */
	public class NoNeedToStartModule extends BaseStartupModule
	{
		
		public function NoNeedToStartModule() 
		{
			super("NoNeedToStartModule");
			
		}
		
		override public function get wantsToStart():Boolean { return false; }
	}

}