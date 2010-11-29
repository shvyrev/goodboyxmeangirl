/**
 * UIPLUGIN
 * 
 * SWF CONTENANT UNE OU PLUSIEUR CLASSE
 * @author Richard Rodney
 * @version 0.1
 * 
 * context exmaple :
 * 
 * 	//begin
 * 		
 * 		plugin1.swf=truc.truc::truc,truc.truc::truc2,...,truc.truc::trucN;
 * 		plugin2.swf=truc.truc::truc,truc.truc::truc2,...,truc.truc::trucN;
 * 		plugin3.swf=truc.truc::truc,truc.truc::truc2,...,truc.truc::trucN;
 * 	
 *  //end
 * 
 */

package railk.as3.ui.plugin
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import railk.as3.utils.hasDefinition;
	import railk.as3.ui.loader.loadUI;
	
	public final class UIPlugin
	{
		private var hashMap:Dictionary = new Dictionary(true);
		
		public static function getInstance():UIPlugin{
			return Singleton.getInstance(UIPlugin);
		}
		
		/**
		 * YOU CANNOT INSTANTIATE DIRECTLY PLEASE USE getInstance() INSTEAD
		 */
		public function UIPlugin() { Singleton.assertSingle(UIPlugin); }
		
		/**
		 * SET THE PLUGINS CONTEXT
		 */
		public function init(context:String):void {
			var duples:Array = context.replace(/\r|\t|\n/g, '').split(';'), length:int=duples.length, duple:Array, classes:Array;
			for (var i:int = 0; i < length; ++i) {
				duple = duples[i].split('=');
				classes = duple[1].split(',');
				for (var j:int = 0; j < classes.length; j++) hashMap[classes[j]] = duple[0];
			}
		}
		
		/**
		 * GET THE CLASS	if not already loaded get the appropriate plugin from context
		 * 
		 * @param	name
		 * @return
		 */
		public function getClass(name:String):Class {
			if (hasDefinition(name)) return getDefinitionByName(name);
			else loadUI(hashMap[name]).complete(getClass,name).start();
		}		
	}
}