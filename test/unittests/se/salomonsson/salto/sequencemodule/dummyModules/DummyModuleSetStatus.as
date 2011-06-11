package unittests.se.isotop.video.startup.dummyModules 
{
	import se.isotop.error.BummerEvent;
	import se.isotop.video.startup.Status;
	import org.osflash.signals.ISignal;
	import se.isotop.video.startup.IStartupModule;
	/**
	 * Set status yourself using "setStatus"
	 * @author Tommy Salomonsson
	 */
	public class DummyModuleSetStatus implements IStartupModule
	{
		private var _status:Status = Status.RESET;
		
		public function DummyModuleSetStatus( status:Status=null ) 
		{
			if (status != null)
				setStatus(status);
		}
		
		public function setStatus( status:Status ):void
		{
			_status = status;
		}
		
		/* INTERFACE se.isotop.video.startup.IStartupModule */
		
		public function get wantsToStart():Boolean { return (_status != Status.COMPLETE); }
		
		public function start():void
		{
			
		}
		
		public function get completeSignal():ISignal
		{
			return null;
		}
		
		public function get statusSignal():ISignal
		{
			return null;
		}
		
		public function get status():Status
		{
			return _status;
		}
		
		public function abort():void
		{
			
		}
		
		public function reset():void
		{
			
		}
		
		public function destroy():void
		{
			
		}
		
		public function debug():String
		{
			return "";
		}
		
		public function get errorSignal():ISignal
		{
			return null;
		}
		
		public function get error():BummerEvent
		{
			return null;
		}
		
	}

}