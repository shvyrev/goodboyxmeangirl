/**
* 
* What i Type is what i get ... humanized search/actions trigger system by typing everywhere on the surface.
* 
* TODO: test and make improment based on use
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.witywig
{
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	import flash.events.TextEvent;
	
	import railk.as3.text.Text;
	import railk.as3.utils.DynamicRegistration;
	
	public class  Witywig extends EventDispatcher
	{
		
		public static const CTRL:String = 17;
		public static const SPACE:String = 32;
		public static const SHIFT:String = 16;
		public static const TAB:String = 9;
		
		private static var reservedActions:Object;
		private static var activationKey:int;
		private static var activated:Boolean = false;
		private static var datas:Dictionary;
		private static var termsRelation:Dictionary;
		
		private static var textfield:Text;
		private static var underfield:Text;
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	   GESTION DES LISTENERS DE CLASS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function addEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false, p_priority:int=0, p_useWeakReference:Boolean=false):void {
      			if (disp == null) { disp = new EventDispatcher(); }
      			disp.addEventListener(p_type, p_listener, p_useCapture, p_priority, p_useWeakReference);
      	}
		
    	public static function removeEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false):void {
      			if (disp == null) { return; }
      			disp.removeEventListener(p_type, p_listener, p_useCapture);
      	}
		
    	public static function dispatchEvent(p_event:Event):void {
      			if (disp == null) { return; }
      			disp.dispatchEvent(p_event);
      	}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	   							 INIT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function init( stage:Stage, executeBox:*, activationKey:int=SPACE ):DynamicRegistration 
		{
			this.activationKey = activationKey;
			
			executeBox.alpha = 0;
			executeBox.visible = false;
			textfield = executeBox.getChildByName('text');
			underfield = executeBox.getChildByName('undertext');
			textfield.addEventListener( TextEvent.TEXT_INPUT, manageEvent, false, 0, true );
			stage.addEventListener( KeyboardEvent.KEY_DOWN, manageEvent, false, 0, true );
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				    EXECUTE AN ACTION
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function execute( method:String:, ...args ):* {
			var result:*;
			loop:for ( var a in reservedActions )
			{
				if ( method == a )
				{
					(reservedActions[a].action as Function).call(null, args)
					result = true;
					break loop;
				}
				else
				{
					result = parseExecute(args);
				}
			}
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 															ADD REGISTERED KEYWORD TO TRIGGER ACTIONS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function addAction( name:String, argsName:String, action:Function ):void {
			reservedActions[name] = { action:action, args:argsName };
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  MANAGE SEARCH TERMS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function add( content:*, terms:String ):void {
			parseTerms( terms, content );
			if ( datas[content] ) datas[content] += ','+terms;
			else datas[content] = terms;
		}
		
		public static function remove( content:* ):void {
			datas[content] = null;
		}
		
		public static function empty():void {
			for ( var d:* in datas)
			{
				datas[d] = null;
			}
		}
		
		private static function parseTerms( terms:String, content:* ):String {
			var a:Array = terms.split(',');
			for (var i:int = 0; i < a.length; i++) 
			{
				termsRelation[a[i]] = content;
			}
		}
		
		private static function parseExecute( terms:Array ):Array 
		{
			var result:Array;
			for (var i:int = 0; i < terms; i++) 
			{
				for (var t in termsRelation )
				{
					if ( t = terms[i] ) result.push( termsRelation[t] );
				}
			}
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  MANAGE SEARCH TERMS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function manageEvent( evt:* )
		{
			switch( evt.type )
			{
				case KeyboardEvent.KEY_DOWN :
					if ( evt.keyCode == activationKey )
					{
						if (activated) {
							activated = false;
							///////////////////////////////////////////////////////////////
							args = { info:"witywig activated"};
							eEvent = new WitywigEvent( WitywigEvent.ON_DESACTIVATION, args );
							dispatchEvent( eEvent );
							///////////////////////////////////////////////////////////////
						}
						else {
							activated = true;
							///////////////////////////////////////////////////////////////
							args = { info:"witywig activated"};
							eEvent = new WitywigEvent( WitywigEvent.ON_ACTIVATION, args );
							dispatchEvent( eEvent );
							///////////////////////////////////////////////////////////////
						}
						
					}
					break;
					
				case TextEvent.TEXT_INPUT :
					loop:for ( var a:String in reservedActions )
					{
						if ( a.search(evt.text) != -1 )
						{
							underfield.text = String(a) + '' + String(reservedActions[a].args);
						}
					}	
					break;
			}
		}
	}
}