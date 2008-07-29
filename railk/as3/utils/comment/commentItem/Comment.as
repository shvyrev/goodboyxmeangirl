/**
* 
* Comment item;
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.utils.comment.commentItem
{
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.utils.DynamicRegistration;
	import railk.as3.utils.objectList.*;
	
	
	public class  Comment extends DynamicRegistration
	{
		// ______________________________________________________________________________ VARIABLES INTERFACE
		private var component                   		:DynamicRegistration = new DynamicRegistration();
		private var itemList                   			:ObjectList = new ObjectList(
																	['emptyCom', component],
																	['name', component],
																	['mail',component],
																	['texte',component],
																	['date',component],
																	['website',component],
																	['note',component],
																	['answer',component],
																	['delete',component],
																	['edit',component] );
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	config
		 * @param	mode
		 */
		public function Comment( config:Class, mode:String ):void
		{
			itemList.getObjectByID('emptyCom').data = config.createEmptyCom().object;
			itemList.getObjectByID('emptyCom').data.extra = config.createEmptyCom().place;
			itemList.getObjectByID('name').data = config.createFormName().object;
			itemList.getObjectByID('name').data.extra = config.createFormName().place;
			itemList.getObjectByID('mail').data = config.createFormMail().object;
			itemList.getObjectByID('mail').data.extra = config.createFormMail().place;
			itemList.getObjectByID('texte').data = config.createFormTexte().object;
			itemList.getObjectByID('texte').data.extra = config.createFormTexte().place;
			itemList.getObjectByID('date').data = config.createFormDate().object;
			itemList.getObjectByID('date').data.extra = config.createFormDate().place;
			itemList.getObjectByID('website').data = config.createFormWebsite().object;
			itemList.getObjectByID('website').data.extra = config.createFormWebsite().place;
			itemList.getObjectByID('note').data = config.createFormNote().object;
			itemList.getObjectByID('note').data.extra = config.createFormNote().place;
			itemList.getObjectByID('answer').data = config.createFormAnswer().object;
			itemList.getObjectByID('answer').data.extra = config.createFormAnswer().place;
			itemList.getObjectByID('delete').data = config.createFormDelete().object;
			itemList.getObjectByID('delete').data.extra =config.createFormDelete().place;
			itemList.getObjectByID('edit').data = config.createFormEdit().object;
			itemList.getObjectByID('edit').data.extra = config.createFormEdit().place;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				 	    ADD COMPONENT
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
		// 																				  	    GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public override function set name( value:String ):void { itemList.getObjectByName('name').data.getChildByName( 'texte' ).appendText(''); itemList.getObjectByName('name').data.getChildByName( 'texte' ).text = value; }
		public function set mail( value:String ):void {  itemList.getObjectByName('mail').data.getChildByName( 'texte' ).appendText(''); itemList.getObjectByName('mail').data.getChildByName( 'texte' ).text = value;}
		public function set date( value:String ):void {  itemList.getObjectByName('date').data.getChildByName( 'texte' ).appendText(''); itemList.getObjectByName('date').data.getChildByName( 'texte' ).text = value;}
		public function set website( value:String ):void {  itemList.getObjectByName('website').data.getChildByName( 'texte' ).appendText(''); itemList.getObjectByName('website').data.getChildByName( 'texte' ).text = value;}
		public function set texte( value:String ):void {  itemList.getObjectByName('texte').data.getChildByName( 'texte' ).appendText(''); itemList.getObjectByName('texte').data.getChildByName( 'texte' ).text = value;}
		public function set note( value:String ):void {  itemList.getObjectByName('note').data.getChildByName( 'texte' ).appendText(''); itemList.getObjectByName('note').data.getChildByName( 'texte' ).text = value; }
		
		public function get websiteBT():DynamicRegistration { return itemList.getObjectByID('website').data; }
		public function get noteBT():DynamicRegistration { return itemList.getObjectByID('note').data; }
		public function get deleteBT():DynamicRegistration { return itemList.getObjectByID('delete').data; }
		public function get editBT():DynamicRegistration { return itemList.getObjectByID('edit').data; }
		public function get mailBT():DynamicRegistration { return itemList.getObjectByID('mail').data; }
		public function get answerBT():DynamicRegistration { return itemList.getObjectByID('answer').data; }
		
	}
	
}