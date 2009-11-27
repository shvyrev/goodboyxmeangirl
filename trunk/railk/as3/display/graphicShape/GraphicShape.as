/**
* Display graphishapes
* 
* @author Richard Rodney
* @version 0.3
*/

package railk.as3.display.graphicShape {
	
	import flash.geom.ColorTransform;
	import flash.geom.Transform;
	import railk.as3.display.RegistrationPoint;
	
	public class GraphicShape extends RegistrationPoint 
	{	
		public var graphicsCopy:*;
		protected var copy:Boolean;
		protected var _type:String;
		
		
		public function GraphicShape(copy:Boolean=false) {
			super();
			this.copy = copy;
			if ( copy ) graphicsCopy = new GraphicCopy(graphics);
			else graphicsCopy = graphics;
		}
		
		public function execute(method:String,params:Array):void {
			this.graphicsCopy[method].apply(null, params);
		}
		
		override public function toString():String {
			return '[ GRAPHICSHAPE > ' + this.name.toUpperCase() + ', (type:' + this._type + ') ]';
		}
		
		public function get type():String { return _type; }
	}
}