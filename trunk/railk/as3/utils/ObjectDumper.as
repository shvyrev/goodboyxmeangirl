﻿/**
* Object Dumper for amf object parsing
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.utils {
	public class ObjectDumper {
		public static function dump( o:Object ):String {
			var result:String = '';
			for ( var name in o ) 
			{
				result += '[' + name +' => ';
				result += o[name];
				result += ' ]\n';
			}
			if ( !result ) result = '[ empty ]';
			return result;
		}
	}
}