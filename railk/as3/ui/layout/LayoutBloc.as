/**
 * Layout Manager bloc
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	import railk.as3.display.VSprite;
	import railk.as3.utils.objectList.ObjectList;
	
	public class LayoutBloc
	{
		private var bloc:VSprite;
		private var subBlocs:ObjectList;
		
		private var _name:String;
		private var _height:Number;
		private var _width:Number;
		private var _hasSubBlocs:Boolean = true;
		
		public var fixedHeight:Boolean = true;
		public var fixedWidth:Boolean = true;
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function LayoutBloc(parent:Object, name:String, width:Number, height:Number):void
		{
			subBlocs = new ObjectList();
			bloc = new VSprite(parent);
			bloc.name = name;
			bloc.width = width;
			bloc.height = height;
			bloc.changeRegistration(width * .5, height * .5);
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						ADD SUB BLOCS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function addSubBlocs( blocs:Array ):void
		{
			for (var i:int = 0; i < blocs; i++) 
			{
				subBlocs.add[blocs.name]
			}
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  ADD CONTENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function addContent( content:Object ):Boolean
		{
			var result:Boolean;
			if ( hasSubBlocs) result = false;
			else
			{
				bloc.addChild( content );
				result = true;
			}
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							   RESIZE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function resize():void
		{
			
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get name():String { return _name; }
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		public function get height():Number { return _height; }
		
		public function set height(value:Number):void 
		{
			_height = value;
		}
		
		public function get width():Number { return _width; }
		
		public function set width(value:Number):void 
		{
			_width = value;
		}
		
		public function get hasSubBlocs():Boolean { return _hasSubBlocs; }
		
	}
	
}