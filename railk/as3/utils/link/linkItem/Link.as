/**
* 
* Link
* 
* @author Richard Rodney
* @version 0.1
*/


package railk.as3.utils.link.linkItem {
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.display.GraphicShape;
	import railk.as3.utils.DynamicRegistration;
	
	// ______________________________________________________________________________________ IMPORT TWEENER
	import caurina.transitions.Tweener;
	
	// ____________________________________________________________________________________ IMPORT SWFADRESS
	import com.asual.swfaddress.SWFAddress;
	
	
	
	public class Link extends Sprite  {
		
		//________________________________________________________________________________________ VARIABLES
		private var linkContainer                              :DynamicRegistration;
		private var nom                                        :String;
		private var obj                                        :*;
		private var content                                    :Object;
		private var action                                     :Function;
		
		//___________________________________________________________________________________ VARIABLES ETATS
		private var swfAdress                                  :Boolean;     
		private var active                                     :Boolean = false;;
		
		
		
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
		public function Link(  name:String, displayObject:*, displayObjectContent:Object,  onClick:Function=null, swfAdressEnable:Boolean=false ):void {
			
			//--vars
			nom = name;
			obj = displayObject;
			content = displayObjectContent;
			action = onClick;
			
			//--swfadress ?
			swfAdress = swfAdressEnable;
				
			//--Container
			linkContainer = new DynamicRegistration();
			addChild( linkContainer );
			linkContainer.addChild( obj );
			linkContainer.buttonMode = true;

			
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
			linkContainer.addEventListener( MouseEvent.MOUSE_OVER, manageEvent, false, 0, true );
			linkContainer.addEventListener( MouseEvent.MOUSE_OUT, manageEvent, false, 0, true );
			linkContainer.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
		}
		
		public function delListeners():void {
			linkContainer.removeEventListener( MouseEvent.MOUSE_OVER, manageEvent );
			linkContainer.removeEventListener( MouseEvent.MOUSE_OUT, manageEvent );
			linkContainer.removeEventListener( MouseEvent.CLICK, manageEvent );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function doAction():void {
			if ( action != null ) { active = true; action("do", obj); }
		}
		
		public function undoAction():void {
			if( action != null ){ active = false; action("undo", obj); }
		}
		
		public function isActive():Boolean {
			return active;
		}
		
		public override function get name():String {
			return nom;
		}
		
		public function get object():*{
			return obj;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		      DESTROY
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose() {
			delListeners();
			linkContainer = null;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:* ):void {
			
			var prop:String;
			var type:String;
			
			switch( evt.type ) {
				case MouseEvent.MOUSE_OVER :
					
					//--swfadress
					if ( swfAdress ) {
						SWFAddress.setStatus(nom);
					}
					
					for ( prop in content ) {
						type = getType( content[prop].objet );
						if( content[prop].colors != null ) {
							if ( type == "text" ) {
								Tweener.addTween( content[prop].objet, { _text_color:content[prop].colors.hover, time:.2, transition:"linear" } );
							}
							else if ( type == "sprite" ) {
								Tweener.addTween( content[prop].objet, { _color:content[prop].colors.hover, time:.2, transition:"linear" } );	
							}
						}	
						
						if ( content[prop].action != null ) {
							content[prop].action("hover", content[prop].objet);
						}
					}
					break;
					
				case MouseEvent.MOUSE_OUT :
				
					//--swfadress
					if ( swfAdress ) {
						SWFAddress.resetStatus();
					}
				
					for ( prop in content ) {
						type = getType( content[prop].objet );
						if( content[prop].colors != null ) {
							if( type == "text" ){
								Tweener.addTween( content[prop].objet, { _text_color:content[prop].colors.out, time:.2, transition:"linear" } );
							}
							else if ( type == "sprite" ) {
								Tweener.addTween( content[prop].objet, { _color:content[prop].colors.out, time:.2, transition:"linear" } );	
							}
						}
						
						if ( content[prop].action != null ) {
							content[prop].action("out", content[prop].objet);
						}
					}	
					break;
					
				case MouseEvent.CLICK :
					
					//--swfadress && Action && State
					if ( swfAdress ) {
						SWFAddress.setValue(nom);
					}
					else {
						if (active) { active = false; if( action != null ){ action("undo", obj); } }
						else{ active = true; if( action != null ){ action("do", obj); } }
					}	
				
					for ( prop in content ) {
						type = getType( content[prop].objet );
						if( content[prop].colors != null ) {
							if( type == "text" ){
								Tweener.addTween( content[prop].objet, { _text_color:content[prop].colors.click, time:.2, transition:"linear" } );
							}
							else if ( type == "sprite" ) {
								Tweener.addTween( content[prop].objet, { _color:content[prop].colors.click, time:.2, transition:"linear" } );	
							}
						}	
					}	
					break;
			}
		}
		
		
	}
}