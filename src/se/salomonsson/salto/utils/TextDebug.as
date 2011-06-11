package se.salomonsson.salto.utils
{
	import flash.text.Font;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * Will find out what is wrong with a textfield that does not show anything, something that is so common
	 * it acctually needs its own testing-class!!!
	 * @author Tommy Salomonsson
	 */
	public class TextDebug 
	{
		
		private static var _errorCount:int;
		private static var _msg:String;
		private static var _log:Logger;
		
		/**
		 * Todo: find out stylename dynamically
		 * @param	tf
		 * @param	styleName
		 */
		public static function debugTextfield( tf:TextField, styleName:String ):void
		{
			if ( _log == null )
			{
				var temp:TextDebug = new TextDebug();
			}
			
			_msg = "";
			
			_errorCount = 0;
			
			var sheet:StyleSheet = tf.styleSheet;
			var format:TextFormat = tf.getTextFormat();
			var embedded:Boolean = tf.embedFonts;
			var str:String = tf.htmlText;
			var htmlClass:Boolean = ( str.indexOf("<span") >= 0 && str.indexOf(styleName) >= 0 );
			var hasText:Boolean = (str.length > 0);
			var font:String = format.font;
			
			var style:Object;
			
			try
			{
				style = sheet.getStyle("." + styleName);
			}
			catch ( e:Error )
			{
				
			}
			
			//msg += checkNonNull( str, "Check valid text: \"" + str.slice(0, 20) + "\"" );
			//msg += checkNonNull( sheet, "StyleSheet exists" );
			//msg += checkNonNull( styleName, "StyleName" )
			//msg += checkNonNull( style, "Style " + styleName + " exists in loaded stylesheet" );
			//msg += checkBoolean( embedded, "Font is embedded: " + embedded );
			//msg += checkStyleSheet( sheet, styleName, embedded, str );
			
			
			log( "StyleSheet= " + sheet );
			log( "Format 	= " + format );
			log( "Embedded 	= " + embedded );
			log( "Text 		= " + str.slice( 0, 100 ) );
			log( "htmlClass = " + htmlClass );
			log( "hasText = " + hasText );
			log( "styleName = " + styleName );
			log( "width/height = " + tf.width + "/" + tf.height );
			
			if ( style != null )
			{
				log( "style = " + style );
				log( "style font = " + style.fontFamily );
				log( "style color = " + style.color );
			}
			else if ( format != null )
			{
				for (var name:String in format) 
				{
					log( "tf: " + name + " = " + format[name] );
				}
			}
			
			log( "font = " + font );
			log( "color =  #" + uint(format.color).toString(16) );
			
			// Check if font exists in font module
			var loadedFonts:Array = Font.enumerateFonts( !embedded );
			log("Number of loaded fonts (embedded: " + embedded + ") = " + loadedFonts.length );
			for (var i:int = 0; i < loadedFonts.length; i++) 
			{
				var f:Font = loadedFonts[i];
				log( "Loaded fonts: " + f.fontName + " ("+f.fontStyle+", " + f.fontType + ")" );
			}
			
			_log.debug( "\n ***** DEBUG TEXTFIELD ****** \n" + _msg + "\n **********************\n\n" );
		}
		
		
		private static function log( str:String ):void
		{
			_msg += " ** " + str + " **\n";
		}
		
		
		private static function checkNonNull( obj:*, description:String ):String
		{
			if ( obj != null && obj != "null" && obj != "" )
			{
				return format( true, "checkNonNull", description );
			}
			return format( false, "checkNonNull", description );
		}
		
		private static function checkBoolean( obj:*, description:String, preferValue:int=-1 ):String
		{
			if ( obj is Boolean )
			{
				if ( preferValue > -1 )
				{
					if ( (obj && preferValue == 1) || (!obj && preferValue == 0) )
						return format( true, "checkBoolean=" + preferValue, description );
					
					return format( false, "checkBoolean=" + preferValue, description );
				}
				return format( true, "checkBoolean", description );
			}
			return format( false, "checkBoolean", description );
		}
		
		private static function containsString( obj:*, checkFor:String, description:String ):String
		{
			if ( obj is String )
			{
				if ( String( obj ).indexOf( checkFor ) >= 0 )
				{
					format( true, description, "containsString " + checkFor );
				}
				else
				{
					format( false, description, "containsString " + checkFor );
				}
			}
			return "";
		}
		
		private static function checkStyleSheet( sheet:StyleSheet, styleName:String, embeddedFonts:Boolean, text:String ):String
		{
			var msg:String = "";
			if ( embeddedFonts )
			{
				
				msg += containsString( text, styleName, "Check for style tag in string" );
				
				var obj:Object = sheet.getStyle( styleName );
				//msg += checkNonNull( obj, "Check style " +styleName + " exists on stylesheet" );
				
				msg += "    Stylesheet properties: \n";
				for (var name1:String in sheet) 
				{
					msg += "          " + name1 + " : " + sheet[name1].toString() + "\n";
				}
				
				//msg += "    fontFamily: " + obj.fontFamily;
				
				//try
				//{
					//msg += "    Stylesheet styles: \n";
					//var count:int = 0;
					//for (var name:String in obj) 
					//{
						//msg += "          " + name + " : " + obj[name] + "\n";
						//count ++;
					//}
				//}	
				//catch ( e:Error )
				//{
					//msg += "[ERROR] " + e.message + "\n";
				//}
				//finally
				//{
					//if ( count == 0 )
					//{
						//msg += format( false, "checkStylesheet", "Could not find any properties on stylesheet" );
					//}
					//else
					//{
						//msg += format( true, "checkStylesheet", "Found " + count + " styles on stylesheet" );
					//}
					//return msg;
				//}
				
				
			}
			return msg;
		}
		
		
		private static function format( passed:Boolean, type:String, description:String ):String
		{
			var msg:String = passed ? "TEST PASSED:      " : "*** TEST FAILED ****   ";
			msg += description + "  [test: " + type + "]\n";
			if ( !passed )
				_errorCount ++;
			return msg;
		}
		
		public function TextDebug() 
		{
			if ( _log == null )
			{
				_log = LoggerFactory.getLogger( this );
			}
		}
		
	}
	
}