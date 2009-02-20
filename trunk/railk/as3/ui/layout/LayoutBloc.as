/**
 * Layout Manager bloc
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	import flash.events.Event;
	import railk.as3.display.VSprite;
	import railk.as3.data.list.DLinkedList;
	
	public class LayoutBloc
	{
		private var bloc:VSprite;
		private var subBlocs:DLinkedList;
		
		private var _name:String;
		private var _height:Number;
		private var _width:Number;
		private var _hasSubBlocs:Boolean = true;
		
		public var dynamicHeight:Boolean = true;
		public var dynamicWidth:Boolean = true;
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function LayoutBloc(parent:Object, name:String )
		{
			subBlocs = new DLinkedList();
			bloc = new VSprite(parent);
			bloc.addEventListener( Event.ENTER_FRAME, resize, false, 0, true);
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
		// 																					 SET REGISTRATION
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function setRegistration(x:Number, y:Number):void
		{
			bloc.changeRegistration(x, y);
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							   RESIZE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function resize(evt:Event):void
		{
			
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							   RESIZE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void
		{
			bloc.removeEventListener( Event.ENTER_FRAME, resize );
			bloc = null;
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