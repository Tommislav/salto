package se.salomonsson.salto.dim
{
	import org.osflash.signals.Signal;
	/**
	 * Keeps track of dimension, dispatches resize through Signal.
	 * x, y, width and height are bindable.
	 * @author Tommy Salomonsson
	 */
	public class Dimension extends BindableModel implements IDimension
	{
		private var _onResized:Signal = new Signal(IDimension);
		private var _dispatchLocked:Boolean = false;
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _width:Number = 0;
		private var _height:Number = 0;
		
		private var _bottom:Number;
		private var _right:Number;
		
		public function Dimension( x:Number=0, y:Number=0, width:Number=0, height:Number=0 ) 
		{
			this.resize( x, y, width, height );
		}
		
		/* INTERFACE se.isotop.models.IDimension */
		
		public function resize( x:Number = NaN, y:Number = NaN, width:Number = NaN, height:Number = NaN ):void
		{
			_dispatchLocked = true;
			var dirty:Boolean = false;
			
			if ( !isNaN(x) )
			{
				if ( _x != x )
				{
					this.x = x;
					dirty = true;
				}
			}
			
			if ( !isNaN(y) )
			{
				if ( _y != y )
				{
					this.y = y;
					dirty = true;
				}
			}
			
			if ( !isNaN(width) )
			{
				if ( _width != width )
				{
					this.width = width;
					dirty = true;
				}
			}
			
			if ( !isNaN(height) )
			{
				if ( _height != height )
				{
					this.height = height;
					dirty = true;
				}
			}
			
			_dispatchLocked = false;
			
			if ( dirty )
				internalResize();
		}
		
		public function get onResized():Signal
		{
			return _onResized;
		}
		
		public function get x():Number	{		return _x;		}
		public function set x(value:Number):void
		{
			if ( value != x )
			{
				_x = value;
				updateProperty( "x", x );
				internalResize();
			}
		}
		
		public function get y():Number	{		return _y;		}
		public function set y(value:Number):void
		{
			if ( value != y )
			{
				_y = value;
				updateProperty( "y", y );
				internalResize();
			}
		}
		
		public function get width():Number	{	return _width;		}
		public function set width(value:Number):void
		{
			if ( value != _width )
			{
				_width = value;
				updateProperty( "width", width );
				internalResize();
			}
		}
		
		public function get height():Number	{	return _height;		}
		public function set height(value:Number):void
		{
			if ( value != _height )
			{
				_height = value;
				updateProperty( "height", height );
				internalResize();
			}
		}
		
		public function get bottom():Number
		{
			return _y + _height;
		}
		
		public function get right():Number
		{
			return _x + _width;
		}
		
		public function equals(dim:IDimension):Boolean
		{
			if ( dim == null )
				return false;
			
			return( dim.x == this.x && dim.y == this.y && dim.width == this.width && dim.height == this.height );
		}
		
		public function clone():IDimension
		{
			return new Dimension( this.x, this.y, this.width, this.height );
		}
		
		
		private function internalResize():void
		{
			if ( !_dispatchLocked )
			{
				_onResized.dispatch( this );
			}
		}
		
		override public function toString():String
		{
			return "Dimension: [x=" + this.x + ", y=" + this.y + ", width=" + this.width + ", height=" + this.height + "]";
		}
	}
}