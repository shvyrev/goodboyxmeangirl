/**
* 
* Singleton pattern
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.singleton 
{	
	import flash.utils.getQualifiedSuperclassName;
	import flash.utils.getDefinitionByName;
	import flash.utils.Dictionary;
	
	public class Singleton
	{
		private static var instance:*;
		private static var instances:Dictionary = new Dictionary();
		private static var allowInstantiation:Boolean = false;
		
		public static function getInstance(classe:Class):* {
			if ( instances[classe] == undefined ){
				allowInstantiation = true;
				instances[classe] = new classe();
				////////////////////////the singleton extends another singleton ? yes, so lets keep only the super instance as a reference for both/////////////////////////////
				try { new getDefinitionByName(getQualifiedSuperclassName(classe))() }
				catch (e:Error) { if ( getQualifiedSuperclassName(classe) != 'Object') instances[getDefinitionByName(getQualifiedSuperclassName(classe))] = instances[classe]; }
				////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				allowInstantiation = false;
			}
			return instances[classe];
		}
		
		public static function assertSingle(classe:Class):void {
			if (!allowInstantiation) throw new Error(classe+" is a Singleton : Use "+classe+".getInstance() instead of new.");
		}
	}
}