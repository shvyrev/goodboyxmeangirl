/**
* 
* Multiton pattern
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.multiton 
{	
	import flash.utils.getQualifiedSuperclassName;
	import flash.utils.getDefinitionByName;
	import flash.utils.Dictionary;
	
	public class Multiton
	{
		private static var instance:*;
		private static var instances:Dictionary = new Dictionary();
		private static var allowInstantiation:Boolean = false;
		
		public static function getInstance(id:String,classe:Class):* {
			if ( instances[[id,classe]] == undefined ){
				allowInstantiation = true;
				instances[[id,classe]] = new classe();
				////////////////////////the Multiton extends another Multiton ? yes, so lets keep only the super instance as a reference for both/////////////////////////////
				try { new getDefinitionByName(getQualifiedSuperclassName(classe))() }
				catch (e:Error) { if ( getQualifiedSuperclassName(classe) != 'Object') instances[[id,getDefinitionByName(getQualifiedSuperclassName(classe))]] = instances[[id,classe]]; }
				////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				allowInstantiation = false;
			}
			return instances[[id,classe]];
		}
		
		public static function assertSingle(classe:Class):void {
			if (!allowInstantiation) throw new Error(classe+" is a Multiton : Use "+classe+".getInstance() instead of new.");
		}
	}
}