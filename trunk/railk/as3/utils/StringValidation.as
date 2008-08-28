/**
* 
* String validation for email/url/name etc
* 
* @author Richard rodney
*/


package railk.as3.utils {


    public class StringValidation {

		// ��������������������������������������������������������������������������������������������������
		// 																						 		  URL
		// ��������������������������������������������������������������������������������������������������
        static public final function validateUrl( url:String ):Boolean {
            var reg:RegExp = /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/;
            return reg.test( url );
        }

		// ��������������������������������������������������������������������������������������������������
		// 																						 		 NAME
		// ��������������������������������������������������������������������������������������������������
        static public final function validateName( name:String ):Boolean {
            var reg:RegExp = /^([a-zA-z??????0-9\s-_]{3,})$/;
            return reg.test( name );
        }

		// ��������������������������������������������������������������������������������������������������
		// 																						 		EMAIL
		// ��������������������������������������������������������������������������������������������������
        static public final function validateEmail( email:String):Boolean {
            var reg:RegExp = /\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*([,;]\s*\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)*/;
            return reg.test( email );
        }
    }
}
