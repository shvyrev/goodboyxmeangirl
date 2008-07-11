/**
* Resize mangaer item
* 
* @author Richard Rodney
* @version 0.1
* 
*/

package railk.as3.utils.resize.resizeItem
{
		
	public class ResizeItem extends Object
	{
		
		//____________________________________________________________________________________ VARIABLES ITEM
		private var _name                                     :String;
		private var _displayObject                            :*;
		private var _group                                    :String;
		private var _action                                   :Function;
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function ResizeItem( name:String, displayObject:*, group:String, action:Function ):void {
			_name = name;
			_displayObject = displayObject;
			_group = group;
			_action = action;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get name():String { return _name; }
		
		public function get content():* { return _displayObject; }
		
		
		public function get group():String { return _group; }
		
		public function set group( value:String ):void {
			_group = value;
		}
		
		public function get action():Function { return _action; }
		
		public function set action( value:Function ):void {
			_action = value;
		}
	}
	
}