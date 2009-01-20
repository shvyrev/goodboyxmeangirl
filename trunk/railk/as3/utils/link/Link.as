/**
* 
* Link
* 
* @author Richard Rodney
* @version 0.1
*/


package railk.as3.utils.link {
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.tween.process.*;
	import railk.as3.utils.Singleton;
	
	// ___________________________________________________________________________________ IMPORT SWFADDRESS
	import com.asual.swfaddress.SWFAddress;
	
	
	public class Link  
	{	
		//_________________________________________________________________________________________ INSTANCE
		private static var inst:Link;

		//________________________________________________________________________________________ VARIABLES		
		private var _name                                       :String;
		private var _displayObject                              :Object;
		private var _content                                    :Object;
		private var _actions                                    :Function;
		private var _colors                                     :Object;
		private var _type                                       :String;
		private var _parent                                     :String;
		private var _dummy                                      :Boolean;
		private var _data                                       :*;
		
		//___________________________________________________________________________________ VARIABLES ETATS
		private var swfAddress                                  :Boolean;     
		private var active                                      :Boolean = false;
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 GET INSTANCE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function getInstance():Link 
		{
			return Singleton.getInstance(Link);
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	SINGLETON
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function Link() { Singleton.assertSingle(Link); }
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	   CREATE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @param	displayObject
		 * @param	type
		 * @param	colors
		 * @param	actions
		 * @param	swfAddressEnable
		 * @param	parent
		 * @param	dummy
		 */
		public function create( name:String, displayObject:Object = null, type:String = 'mouse', actions:Function = null, colors:Object = null, swfAddressEnable:Boolean = false, parent:String = 'root', dummy:Boolean = false, data:*=null ):Link
		{
			_content = new Object();
			_name = name;
			_displayObject = ( dummy ) ?  new Sprite() : displayObject;
			_actions = actions;
			_colors = colors;
			_type = type;
			_parent = parent;
			_dummy = dummy;
			_data = data;
			
			//--swfaddress ?
			swfAddress = swfAddressEnable;

			/////////////////////////////
			_displayObject.buttonMode = true;
			initListeners();
			/////////////////////////////
			
			return this;
		}
		
		public function addContent( name:String, displayObject:Object = null, actions:Function = null, colors:Object = null, inside:Boolean = false, data:*=null):void 
		{
			if ( inside ) displayObject.mouseEnabled = false;
			_content[name] = { object:displayObject, type:getType(displayObject), colors:colors, actions:actions, data:data };
			
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				      GET OBJECT TYPE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function getType( object:* ):String 
		{
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
		// 																				  			TO STRING
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function toString():String 
		{
			return '[ LINK > ' + this._name + ', ( parent:' + this._parent + ' ) ]';
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function deepLinkAction(root:Boolean=false, data:*=null):void
		{
			if ( swfAddress )
			{
				if (data != null) _data  = data;
				if(root) SWFAddress.setValue('/');
				else SWFAddress.setValue(_name);
			}
		}
		
		public function doAction():void 
		{ 
			var prop:String;
			if ( _actions != null ) 
			{ 
				active = true; 
				_actions("do", _displayObject, (_data is Function)? _data.call() : _data);
				for ( prop in _content ) {
					if ( _content[prop].actions != null ) _content[prop].actions("do", _content[prop].object, (_content[prop].data is Function)? _content[prop].data.call() : _content[prop].data );
				}
			} 
		}
		
		public function undoAction():void 
		{
			var prop:String;
			if ( _actions != null )
			{ 
				active = false; 
				_actions("undo", _displayObject, (_data is Function)? _data.call() : _data);
				for ( prop in _content ) {
					if ( _content[prop].actions != null ) _content[prop].actions("undo", _content[prop].object, (_content[prop].data is Function)? _content[prop].data.call() : _content[prop].data );
				}
			} 
		}
		
		public function isActive():Boolean { return active; }
		
		public function change():void { active = (active)?false:true; }
		
		public function isSwfAddress():Boolean { return swfAddress; }
		
		public function isDummy():Boolean { return _dummy; }
		
		public function get name():String { return _name; }
		
		public function get object():*{ return _displayObject; }
		
		public function get mouseChildren():Boolean { return _displayObject.mouseChildren; }
		
		public function set mouseChildren(value:Boolean):void { _displayObject.mouseChildren = value; }
		
		
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
			var type:String = getType( _displayObject );
			switch( evt.type ) 
			{
				case MouseEvent.MOUSE_OVER :
				case MouseEvent.ROLL_OVER :
					if ( swfAddress ) SWFAddress.setStatus(_name);
					if ( _colors ) {
						if ( type == 'text') Process.to( _displayObject, .2, {text_color:_colors.hover } );
						else if( type == 'sprite') Process.to( _displayObject, .2, { color:_colors.hover} );
					}
					if ( _actions != null ) _actions( 'hover', _displayObject, (_data is Function)? _data.call() : _data );
					//--content
					for ( prop in _content ) {
						if( _content[prop].colors != null ) {
							if ( _content[prop].type == "text" ) Process.to( _content[prop].object, .2, {text_color:_content[prop].colors.hover } );
							else if ( _content[prop].type == "sprite" ) Process.to( _content[prop].object, .2, { color:_content[prop].colors.hover} );
						}	
						if ( _content[prop].actions != null ) _content[prop].actions("hover", _content[prop].object, (_content[prop].data is Function)? _content[prop].data.call() : _content[prop].data );
					}
					break;
					
				case MouseEvent.MOUSE_OUT :
				case MouseEvent.ROLL_OUT :
					if ( swfAddress ) SWFAddress.resetStatus();
					if ( _colors ) {
						if ( type == 'text') Process.to( _displayObject, .2, {text_color:_colors.out } );
						else if( type == 'sprite') Process.to( _displayObject, .2, { color:_colors.out} );
					}
					if ( _actions != null ) _actions( 'out', _displayObject, (_data is Function)? _data.call() : _data );
					//--content
					for ( prop in _content ) {
						if( _content[prop].colors != null ) {
							if( _content[prop].type == "text" ) Process.to( _content[prop].object, .2, { text_color:_content[prop].colors.out } );
							else if ( _content[prop].type == "sprite" ) Process.to( _content[prop].object, .2, { color:_content[prop].colors.out } );
						}
						if ( _content[prop].actions != null ) _content[prop].actions("out", _content[prop].object, (_content[prop].data is Function)? _content[prop].data.call() : _content[prop].data );
					}	
					break;
					
				case MouseEvent.CLICK :
					if ( swfAddress ) SWFAddress.setValue(_name);
					else {
						if (active) { active = false; if( _actions != null ){ _actions("undo", _displayObject, (_data is Function)? _data.call() : _data ); } }
						else{ active = true; if( _actions != null ){ _actions("do", _displayObject, (_data is Function)? _data.call() : _data); } }
					}
					if ( _colors ) {
						if ( type == 'text') Process.to( _displayObject, .2, {text_color:_colors.click } );
						else if( type == 'sprite') Process.to( _displayObject, .2, { color:_colors.click} );
					}
					//--content
					for ( prop in _content ) {
						if( _content[prop].colors != null ) {
							if( _content[prop].type == "text" ) Process.to( _content[prop].object, .2, { text_color:_content[prop].colors.click } );
							else if ( _content[prop].type == "sprite" ) Process.to( _content[prop].object, .2, { color:_content[prop].colors.click } );
						}
						if ( _content[prop].actions != null  ) 
						{ 
							if( !isActive() ) _content[prop].actions("do", _content[prop].object, (_content[prop].data is Function)? _content[prop].data.call() : _content[prop].data );
							else _content[prop].actions("undo", _content[prop].object, (_content[prop].data is Function)? _content[prop].data.call() : _content[prop].data  );
						}
					}	
					break;
			}
		}
	}
}