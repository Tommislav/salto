package se.salomonsson.salto.ioc
{
	import flash.utils.getQualifiedClassName;
	/**
	 * Inversion Of Control Conatiner - inspired by Robotlegs
	 * @author Tommislav
	 */
	public class IocContainer 
	{
		private var _classes:Object;
		private var _instances:Object;
		
		public function IocContainer() 
		{
			_classes = new Object();
			_instances = new Object();
		}
		
		public function registerClass( classReference:Class, toInstantiate:Class ):void
		{
			var name:String = getQualifiedClassName( classReference );
			registerClassFromString( name, toInstantiate );
		}
		
		public function registerClassFromString( classRef:String, toInstantiate:Class ):void
		{
			_classes[classRef] = toInstantiate;
		}
		
		
		public function registerInstance( classReference:Class, inst:* ):void
		{
			var name:String = getQualifiedClassName( classReference );
			_instances[ name ] = inst;
		}
		
		public function registerInstanceFromString( classRef:String, inst:* ):void
		{
			_instances[ classRef ] = inst;
		}
		
		public function resolve( classReference:Class ):*
		{
			var name:String = getQualifiedClassName( classReference );
			if ( _instances[name] != null )
				return _instances[name];
				
			if ( _classes[name] != null )
				return new _classes[name]();
			
			throw new Error("Could not resolve ioc instance '" + name + "'");
			return null;
		}
		
		public function contains( classReference:Class ):Boolean
		{
			return containsFromString( getQualifiedClassName( classReference ) );
		}
		
		public function containsFromString( classRefAsString:String ):Boolean
		{
			return (_instances[classRefAsString] != null || _classes[classRefAsString] != null)
		}
		
		public function destroy():void
		{
			_classes = new Object();
			_instances = new Object();
		}
	}

}