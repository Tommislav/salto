package se.salomonsson.salto.dim
{
	import flash.geom.Rectangle;
	import org.osflash.signals.Signal;
	
	/**
	 * Like a rectangle, but x, y, widht and height are bindable.
	 * Uses Robert Penners Signal to dispatch onResized.
	 * @author Tommy Salomonsson
	 */
	public interface IDimension extends IBindableModel
	{
		function get onResized():Signal;
		
		function resize( x:Number = NaN, y:Number = NaN, width:Number = NaN, height:Number = NaN ):void;
		
		function get x():Number;
		function set x( value:Number ):void;
		
		function get y():Number;
		function set y( value:Number ):void;
		
		function get width():Number;
		function set width( value:Number ):void;
		
		function get height():Number;
		function set height( value:Number ):void;
		
		function get bottom():Number;
		function get right():Number;
		
		function equals( dim:IDimension ):Boolean;
		function clone():IDimension;
		function toString():String;
	}
	
}