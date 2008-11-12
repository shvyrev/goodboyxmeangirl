/**
* 
* Form for comments
* 
* @author Richard Rodney
* @version 0.1
*/


package railk.as3.utils.comment.commentItem 
{
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.display.DSprite;
	import railk.as3.utils.RegistrationPoint;
	import railk.as3.utils.objectList.*;
	
	public class  Form extends RegistrationPoint
	{
		// ______________________________________________________________________________ VARIABLES INTERFACE
		private var component                   		:DSprite = new DSprite();
		private var itemList                   			:ObjectList = new ObjectList(
																	['name',component],
																	['mail',component],
																	['texte',component],
																	['website',component],
																	['reset',component],
																	['send',component],
																	['view', component]);
		
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————														
		public function Form( config:Class ):void {
			itemList.getObjectByID('name').data = config.createFormName().object;
			itemList.getObjectByID('name').data.extra = config.createFormName().place;
			itemList.getObjectByID('mail').data = config.createFormMail().object;
			itemList.getObjectByID('mail').data.extra = config.createFormMail().place;
			itemList.getObjectByID('texte').data = config.createFormTexte().object;
			itemList.getObjectByID('texte').data.extra = config.createFormTexte().place;
			itemList.getObjectByID('website').data = config.createFormWebsite().object;
			itemList.getObjectByID('website').data.extra = config.createFormWebsite().place;
			itemList.getObjectByID('reset').data = config.createFormReset().object;
			itemList.getObjectByID('reset').data.extra = config.createFormReset().place;
			itemList.getObjectByID('send').data = config.createFormSend().object;
			itemList.getObjectByID('send').data.extra = config.createFormSend().place;
			itemList.getObjectByID('view').data = config.createFormView().object;
			itemList.getObjectByID('view').data.extra = config.createFormView().place;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  	    ADD COMPONENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function addComponent( name:String, object:*, insert:String, group:String='', action:Function=null )
		{
			//--vars
			var insertMode = insert.split(':')[0];
			var insertPoint = insert.split(':')[1];
			item.name = name;
			
			//--add
			for ( var i:int=0; i < itemList.length; i++ ){
				var node:ObjectNode = itemList.iterate(i);
				if( insertPoint == node.data.name ){
					if ( insertMode == 'before') itemList.insertBefore( node, name, object, group, action );
					else if ( insertMode == 'after') itemList.insertAfter( node, name, object, group, action  );
					break;
				}
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		CREATE LAYOUT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function createLayout():void {
			for ( var i:int=0; i < itemList.length; i++ )
			{
				var node:ObjectNode = itemList.iterate(i);
				if ( node.data.extra.x != undefined ) node.data.x =  node.data.extra.x;
				else if ( node.data.extra.x2 != undefined ) node.data.x =  node.data.extra.x2;
				if ( node.data.extra.y != undefined ) node.data.y =  node.data.extra.y;
				else if ( node.data.extra.y2 != undefined ) node.data.y2 =  node.data.extra.y2;
				if ( node.data.extra.alpha != undefined ) node.data.alpha =  node.data.extra.alpha;
				
				node.data.name = node.name;
				this.addChild( node.data );
			}
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		    FUCNTIONS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function reset():void {
			itemList.getObjectByName('name').data.getChildByName( 'texte' ).appendText('');
			itemList.getObjectByName('mail').data.getChildByName( 'texte' ).appendText('');
			itemList.getObjectByName('website').data.getChildByName( 'texte' ).appendText('');
			itemList.getObjectByName('texte').data.getChildByName( 'texte' ).appendText('');
		}
		
		public function view():void {
			
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		       SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function get name():String { return itemList.getObjectByName('name').data.getChildByName( 'texte' ).text; }
		public function set name( value:String ):void{ return itemList.getObjectByName('name').data.getChildByName( 'texte' ).appendText(''); itemList.getObjectByName('name').data.getChildByName( 'texte' ).text=value; }
		
		public function get mail():String { return itemList.getObjectByName('mail').data.getChildByName( 'texte' ).text; }
		public function set mail( value:String ):void { return itemList.getObjectByName('mail').data.getChildByName( 'texte' ).appendText(''); itemList.getObjectByName('mail').data.getChildByName( 'texte' ).text=value; }
		
		public function get website():String { return itemList.getObjectByName('website').data.getChildByName( 'texte' ).text; }
		public function set website( value:String ):void { return itemList.getObjectByName('website').data.getChildByName( 'texte' ).appendText(''); itemList.getObjectByName('website').data.getChildByName( 'texte' ).text=value; }
		
		public function get texte():String { return itemList.getObjectByName('texte').data.getChildByName( 'texte' ).text; }
		public function set texte( value:String ):void { return itemList.getObjectByName('texte').data.getChildByName( 'texte' ).appendText(''); itemList.getObjectByName('texte').data.getChildByName( 'texte' ).text=value; }
		
		public function get resetBT():DSprite { return itemList.getObjectByName('reset').data }
		public function get sendBT():DSprite { return itemList.getObjectByName('send').data }
		public function get viewBT():DSprite { return itemList.getObjectByName('view').data }
	}
	
}