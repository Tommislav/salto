package se.salomonsson.salto.sequencemodule
{
	import de.polygonal.ds.Iterator;
	/**
	 * Detailed info about the startup process.
	 * Note that this is just a snapshot, and isn't updated as the modules progress! (should it?)
	 * @author Tommy Salomonsson
	 */
	public class StartupInfo
	{
		private var _completedModules:int;
		private var _totalNumberOfModules:int;
		private var _percent:Number;
		private var _visualDebug:String;
		private var _status:Status;
		
		public function StartupInfo( modules:Iterator ) 
		{
			analyze(modules);
		}
		
		private function analyze(modules:Iterator):void
		{
			_totalNumberOfModules = 0;
			_visualDebug = "[";
			_status = Status.RESET;
			modules.start();
			
			var detailedStatus:String = "";
			
			var error:Boolean = false;
			var susp:Boolean = false;
			var running:Boolean = false;
			
			while (modules.hasNext())
			{
				var m:IStartupModule = IStartupModule(modules.next());
				_totalNumberOfModules++;
				_completedModules += (countModuleAsCompleted(m)) ? 1 : 0;
				_visualDebug += getProgressChar( m.status );
				
				detailedStatus += "["+m.status+"] " + m + "\n";
				
				var mStat:Status = m.status;
				
				// status
				error = ( mStat == Status.ERROR || error );
				susp = ( mStat == Status.SUSPENDED || susp );
				running = ( mStat == Status.WORKING || running );
			}
			
			running = (running || _completedModules > 0);
			_percent = (_totalNumberOfModules == 0) ? 100 : (_completedModules / _totalNumberOfModules);
			
			if ( error )
				_status = Status.ERROR;
			else if ( susp )
				_status = Status.SUSPENDED;
			else if ( _totalNumberOfModules == _completedModules )
				_status = Status.COMPLETE;
			else if ( running )
				_status = Status.WORKING;
			else
				_status = Status.RESET;
			
			_visualDebug += "]" + prettyPercent() + " '" + status + "'";
			_visualDebug += "\n" + detailedStatus;
		}
		
		private function countModuleAsCompleted(m:IStartupModule):Boolean
		{
			return ( m.status == Status.COMPLETE || !m.wantsToStart );
		}
		
		public function get percentCompleted():Number
		{
			return _percent;
		}
		
		public function get status():Status
		{
			return _status;
		}
		
		public function get visualDebug():String
		{
			return _visualDebug; 
		}
		
		/**
		 * Returns the number of completed startup modules - not counting any modules currently working
		 */
		public function get progress():int	{	return _completedModules;	}
		
		/**
		 * Returns the number of total startup modules
		 */
		public function get total():int		{	return _totalNumberOfModules;		}
		
		
		
		/** 
		 * Returns a character to print as a debug progress bar depending on status, should look like => "[===---]50%" 
		 * or in case of suspended task "[===z--]50%"
		 * or in case of error task "[===E--]50%"
		 */
		private function getProgressChar( status:Status ):String
		{
			switch(status) {
				case Status.COMPLETE:
					return "=";
				case Status.SUSPENDED:
					return "z";
				case Status.ERROR:
					return "E";
				//case Status.WORKING:
					//return "*";
			}
			return "-";
		}
		
		// Returns percent as rounded percent that always consists of four charaters (the last is the "%")
		private function prettyPercent():String
		{
			var p:int = int( percentCompleted * 100 );
			var s:String = String(p) + "%";
			while (s.length < 4 )
				s = " " + s;
			
			return s;
		}
	}

}