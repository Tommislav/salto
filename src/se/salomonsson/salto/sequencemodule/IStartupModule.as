package se.salomonsson.salto.sequencemodule
{
	import org.osflash.signals.ISignal;
	import se.isotop.error.BummerEvent;
	
	/**
	 * Base interface for pluggable module in the IStartupSequence
	 * @author Tommy Salomonsson
	 */
	public interface IStartupModule 
	{
		function get wantsToStart():Boolean;
		function start():void;
		
		function get completeSignal():ISignal;
		function get statusSignal():ISignal;
		function get errorSignal():ISignal;
		
		function get status():Status;
		function get error():BummerEvent;
		
		function abort():void;
		function reset():void;
		function destroy():void;
		
		function debug():String;
	}
	
}