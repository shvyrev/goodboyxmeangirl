/**
 * foil serializer/deserializer
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.data.foil
{
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.display.LoaderInfo;
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	import railk.as3.eval.core.CompiledExpression;
	import railk.as3.eval.core.Parser;
	import railk.as3.eval.core.Scanner;
	
	public class FoilFunction
	{
		private var _data:Function;
		
		public function FoilFunction( data:String )
		{
			//var expression:String = data.replace(/function\(/, '');
			//trace( expression );
			var expression: String = "sin( x / ( 4 / 2 * 2 - 2 + 2 * x / x ) ) * 100";
			var scanner: Scanner = new Scanner( expression );
			var parser: Parser = new Parser( scanner );
			var compiled: CompiledExpression = parser.parse();
			var bytes: ByteArray = compiled.compile();
			var loader: Loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, manageEvent );
			loader.loadBytes( bytes, new LoaderContext( false, new ApplicationDomain( ApplicationDomain.currentDomain ) ) );
			_data = new Function();
		}
		
		private function manageEvent( evt:Event ):void
		{
			var info: LoaderInfo = ( evt.target as LoaderInfo );
			var klass: Class = ( info.applicationDomain.getDefinition( "CompiledExpression" ) as Class );
			
			var cp: Object = new klass();
			cp.x = 10;
			cp.sin = Math.sin;				
			
			trace( "compiled", cp.execute());
		}
		
		public function get data():Function { return _data; }
	}
	
}