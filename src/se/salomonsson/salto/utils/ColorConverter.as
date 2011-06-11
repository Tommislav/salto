package se.salomonsson.salto.utils
{
	
	/**
	 * Converts color values of the type Number, .
	 * Accepts "#ffffff", "ffffff" and "0xffffff"
	 * It can also extract ARGB-values
	 * @author Tommy Salomonsson
	 */
	public class ColorConverter 
	{
		
		/**
		 * Will convert a color value to a uint value.
		 * Accepts strings and numbers.
		 * Will convert strings or numbers with the following formats:
		 * "#ffffff", "ffffff", "0xffffff", "255", 255, 0x0000ff
		 * @param	rgb		A number or a String
		 * @return	uint value of the number
		 */
		public static function convert( rgb:* ):uint
		{
			var col:uint = convertColorString(rgb);
			
			if ( col <= 0xffffff )
			{
				return col;
			}
			else if ( col <= 0xffffffff )
			{
				trace( "## WARNING ## Color value is of type ARGB!" );
				return col;
			}
			else
			{
				trace( "## WARNING ## Color value is out of bounds!" );
			}
			
			return 0;
		}
		
		/**
		 * Will convert a color value (of the type ARGB) to a uint value.
		 * Accepts strings and numbers.
		 * Will convert strings with the following formats:
		 * "#ff000000", "ff000000", "0xff000000"
		 * @param	rgb		A number or a String
		 * @return	uint value of the number
		 */
		public static function convertARGB( argb:* ):uint
		{
			var col:uint = convertColorString(argb);
			
			if ( col <= 0xffffffff )
			{
				return col;
			}
			else
			{
				trace( "## WARNING ## Color value is out of bounds!" );
			}
			return 0;
		}
		
		
		
		private static function convertColorString( value:* ):uint
		{
			var col:uint;
			//trace( "Value ["+ value +"] is string? " + (isNaN( Number(value) )) + " " + (Number(value)) );
			
			if ( isNaN( Number(value) ) )
			{
				//trace("value is string");
				if ( value.indexOf("#") == 0 )
				{
					value = value.slice( 1 );
				}
				else if ( value.indexOf( "0x" ) == 0 )
				{
					value = value.slice( 2 );
				}
				
				//trace("isNaN [" + value + "]?? " +  ( isNaN( value ) ));
			}
			col = parseInt( "0x" + value );
			
			
			return col;
		}
		
		public function ColorConverter() 
		{
			
		}
		
	}
	
}