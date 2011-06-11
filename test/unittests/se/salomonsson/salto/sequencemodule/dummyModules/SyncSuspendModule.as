package unittests.se.isotop.video.startup.dummyModules 
{
	import se.isotop.video.startup.BaseStartupModule;
	/**
	 * Puts the module into a suspended state
	 * @author Tommy Salomonsson
	 */
	public class SyncSuspendModule extends BaseStartupModule
	{
		public var autoSuspend:Boolean = true;
		
		
		
		public function SyncSuspendModule() 
		{
			super("dummy-SyncSuspendModule");
		}
		
		override public function start():void 
		{
			if (autoSuspend)
				onSuspended();
			else
				onCompleted();
		}
	}
}