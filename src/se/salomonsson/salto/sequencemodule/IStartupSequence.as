package se.salomonsson.salto.sequencemodule
{
	import org.osflash.signals.ISignal;
	import se.isotop.error.BummerEvent;
	
	/**
	 * Interface for StartupSequence for a video player
	 * @author Tommy Salomonsson
	 */
	public interface IStartupSequence 
	{
		function start( obj:*=null ):void;
		function abort():void;
		function reset():void;
		
		function get status():Status;
		function get info():StartupInfo;
		function get complete():Boolean;
		function get error():BummerEvent;
		
		function get statusSignal():ISignal;
		function get completeSignal():ISignal;
		function get errorSignal():ISignal;
		
		function destroy():void;
	}
	
}