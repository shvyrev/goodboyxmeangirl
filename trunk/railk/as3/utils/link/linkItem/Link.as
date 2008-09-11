/**
* 
* Link
* 
* @author Richard Rodney
* @version 0.1
*/


package railk.as3.utils.link.linkItem {
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.tween.process.*;
	
	// ____________________________________________________________________________________ IMPORT SWFADRESS
	import com.asual.swfaddress.SWFAddress;
	
	
	public class Link  
	{	
		//________________________________________________________________________________________ VARIABLES		
		private var _name                                       :String;
		private var _displayObject                              :*;
		private var _content                                    :Object;
		private var _onClick                                    :Function;
		private var _type                                       :String;
		
		//___________________________________________________________________________________ VARIABLES ETATS
		private var swfAdress                                   :Boolean;     
		private var active                                      :Boolean = false;
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	displayObject
		 * @param	displayObjectContent
		 * @param	onClick
		 * @param	swfAdressEnable
		 */
		public function Link(  name:String, displayObject:*, content:Object, type:String, onClick:Function = null, swfAdressEnable:Boolean = false ):void 
		{
			_name = name;
			_displayObject = displayObject;
			_content = content;
			_onClick = onClick;
			_type = type;
			
			//--swfadress ?
			swfAdress = swfAdressEnable;
				
			//--Container
			_displayObject.buttonMode = true;

			//--setup
			for ( var prop in content ) { 
				content[prop].objet.mouseEnabled = false; 
			}
			
			/////////////////////////////
			initListeners();
			/////////////////////////////
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				      GET OBJECT TYPE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function getType( object:* ):String {
			var result:String;
			if ( object is TextField ) { result = "text"; }
			else { result = "sprite"; }
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   GESTION LISTERNERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function initListeners():void {
			if ( _type == 'mouse')
			{
				_displayObject.addEventListener( MouseEvent.MOUSE_OVER, manageEvent, false, 0, true );
				_displayObject.addEventListener( MouseEvent.MOUSE_OUT, manageEvent, false, 0, true );
			}
			else if ( _type == 'roll')
			{
				_displayObject.addEventListener( MouseEvent.ROLL_OVER, manageEvent, false, 0, true );
				_displayObject.addEventListener( MouseEvent.ROLL_OUT, manageEvent, false, 0, true );
			}
			_displayObject.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
		}
		
		public function delListeners():void {
			if ( _type == 'mouse')
			{
				_displayObject.removeEventListener( MouseEvent.MOUSE_OVER, manageEvent );
				_displayObject.removeEventListener( MouseEvent.MOUSE_OUT, manageEvent );
			}
			else if ( _type == 'roll')
			{
				_displayObject.removeEventListener( MouseEvent.ROLL_OVER, manageEvent );
				_displayObject.removeEventListener( MouseEvent.ROLL_OUT, manageEvent );
			}
			_displayObject.removeEventListener( MouseEvent.CLICK, manageEvent );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function doAction():void { if ( _onClick != null ) { active = true; _onClick("do", _displayObject); } }
		
		public function undoAction():void { if( _onClick != null ){ active = false; _onClick("undo", _displayObject); } }
		
		public function isActive():Boolean { return active; }
		
		public function get name():String { return _name; }
		
		public function get object():*{ return _displayObject; }
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		 DISPOSE LINK
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose() { delListeners(); }
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:* ):void 
		{
			var prop:String;
			var type:String;
			switch( evt.type ) 
			{
				case MouseEvent.MOUSE_OVER :
				case MouseEvent.ROLL_OVER :
					if ( swfAdress ) { SWFAddress.setStatus(_name);}
					for ( prop in _content ) {
						type = getType( _content[prop].objet );
						if( _content[prop].colors != null ) {
							if ( type == "text" ) { Process.to( _content[prop].objet, .2, {text_color:_content[prop].colors.hover } ); }
							else if ( type == "sprite" ) { Process.to( _content[prop].objet, .2, { color:_content[prop].colors.hover} ); }
						}	
						if ( _content[prop].action != null ) { _content[prop].action("hover", _content[prop].objet); }
					}
					break;
					
				case MouseEvent.MOUSE_OUT :
				case MouseEvent.ROLL_OUT :
					if ( swfAdress ) { SWFAddress.resetStatus(); }
					for ( prop in _content ) {
						type = getType( _content[prop].objet );
						if( _content[prop].colors != null ) {
							if( type == "text" ){ Process.to( _content[prop].objet, .2, { text_color:_content[prop].colors.out } ); }
							else if ( type == "sprite" ) { Process.to( _content[prop].objet, .2, { color:_content[prop].colors.out } ); }
						}
						if ( _content[prop].action != null ) { _content[prop].action("out", _content[prop].objet); }
					}	
					break;
					
				case MouseEvent.CLICK :
					if ( swfAdress ) { SWFAddress.setValue(_name); }
					else {
						if (active) { active = false; if( _onClick != null ){ _onClick("undo", _displayObject); } }
						else{ active = true; if( _onClick != null ){ _onClick("do", _displayObject); } }
					}	
					for ( prop in _content ) {
						type = getType( _content[prop].objet );
						if( _content[prop].colors != null ) {
							if( type == "text" ){ Process.to( _content[prop].objet, .2, { text_color:_content[prop].colors.click } ); }
							else if ( type == "sprite" ) { Process.to( _content[prop].objet, .2, { color:_content[prop].colors.click } ); }
						}	
					}	
					break;
			}
		}
	}
}