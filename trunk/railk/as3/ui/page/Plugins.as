/**
 * PLUGIN => SWF CONTENANT UNE OU PLUSIEUR CLASSE
 * 
 * @author Richard Rodney
 * @version 0.1
 * 
 * context example :
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

package railk.as3.ui.page
{
	import flash.utils.Dictionary;
	import railk.as3.pattern.singleton.Singleton;
	
	public final class Plugins
	{
		private var hashMap:Dictionary = new Dictionary(true);
		private var monitorData:Array;
		private var monitorComplete:Function;
		
		public static function getInstance():Plugins{
			return Singleton.getInstance(Plugins);
		}
		
		/**
		 * YOU CANNOT INSTANTIATE DIRECTLY PLEASE USE getInstance() INSTEAD
		 */
		public function Plugins() { Singleton.assertSingle(Plugins); }
		
		/**
		 * SET THE PLUGINS CONTEXT
		 */
		public function init(context:String):void {
			if (!context || context == '') return;
			var duples:Array = context.replace(/\r|\t|\n/g, '').split(';'), length:int=duples.length, duple:Array, classes:Array;
			for (var i:int = 0; i < length; ++i) {
				duple = duples[i].split('=');
				classes = duple[1].split(',');
				for (var j:int = 0; j < classes.length; j++) hashMap[classes[j]] = new Plugin(classes[j], duple[0], monitor);
			}
		}
		
		public function initMonitor(data:Array, f:Function):void {
			monitorData = data;
			monitorComplete = f;
		}
		
		/**
		 * GET THE CLASS
		 * 
		 * @param	name
		 */
		public function getClass(name:String, complete:Function, ...params):void {
			if (hashMap[name] == undefined) {
				complete.apply(null, params);
				monitor(name);
			} else {
				if (hashMap[name].state == Plugin.NO) hashMap[name].load(complete,params);
				else if (hashMap[name].state == Plugin.PROGRESS) hashMap[name].addAction(complete,params);
				else if (hashMap[name].state == Plugin.COMPLETE) {
					params[params.length] = hashMap[name].classe; 
					complete.apply(null, params);
					monitor(name);
				}
			}
		}
		
		private function monitor(name:String):void {
			var i:int=monitorData.length;
			while ( --i > -1 ) {
				if (monitorData[i].view == name) {
					monitorData.splice(i, 1);
					break;
				}
			}
			if (monitorData.length == 0) monitorComplete.apply();
		}
	}
}

import flash.utils.getDefinitionByName;
import railk.as3.ui.loader.loadUI;
import railk.as3.TopLevel;
internal class Plugin
{
	public static const NO:String = 'UIPlugin_NO';
	public static const PROGRESS:String = 'UIPlugin_PROGRESS';
	public static const COMPLETE:String = 'UIPlugin_COMPLETE';
	
	public var name:String;
	public var file:String;
	public var state:String = NO;
	public var classe:Class = null;
	public var monitor:Function;
	public var actions:Array = [];
	public var params:Array = [];
	
	public function Plugin(name:String,file:String,monitor:Function) {
		this.name = name;
		this.file = TopLevel.local+"plugins/"+file;
		this.monitor = monitor;
	}
	
	public function load(f:Function, p:Array):void {
		state = PROGRESS;
		addAction(f,p);
		loadUI(file).complete(onComplete).start();
	}
	
	private function onComplete():void {
		classe = getDefinitionByName(name) as Class;
		state = COMPLETE;
		var i:int=actions.length;
		while( --i > -1 ) {
			params[i][params[i].length] = classe;
			actions[i].apply(null, params[i]);
		}
		monitor.apply(null, [name]);
	}
	
	public function addAction(f:Function, p:Array):void { 
		actions[actions.length] = f; 
		params[params.length] = p;
	}
}