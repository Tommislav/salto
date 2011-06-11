package unittests.se.isotop.video.startup.dummyModules 
{
	import org.osflash.signals.Signal;
	import org.osflash.signals.ISignal;
	import se.isotop.video.startup.BaseStartupModule;
	import se.isotop.video.startup.IStartupModule;
	
	/**
	 * ...
	 * @author Tommy Salomonsson
	 */
	public class SyncCompleteModule extends BaseStartupModule
	{
		public var resetSignal:Signal = new Signal();
		
		public function SyncCompleteModule() 
		{
			super("Debug-SyncCompleteModule");
		}
		
		override public function reset():void 
		{
			resetSignal.dispatch();
			super.reset();
		}
		
		override public function start():void
		{
			onCompleted();
		}
	}
}