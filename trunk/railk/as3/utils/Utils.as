/////////////////////////////////////////////////////////////////
//*************************************************************//
//*                     Package d'utilitaire                  *//
//*************************************************************//
/////////////////////////////////////////////////////////////////
package railk.as3.utils {
		
	import flash.display.Sprite;
	import flash.display.Bitmap;

	
	public class Utils extends Sprite {
		
		//création de nombre aléatoire compris entre deux nombres
		/**
		* 
		* @param	min
		* @param	max
		* @return
		*/
		static public function randRange(min:Number, max:Number):Number 
		{
			var randomNum:Number = Math.round(min+(Math.random() * (max - min)));
			return randomNum;
		}
		
		//détermine si un nombre est positif ou négatif
		/**
		* 
		* @param	n
		* @return
		*/
		static public function sign( n:Number ):Number {
			return n<0 ? -1 : 1 ;
		}
		
		//on approche la valeur actuel
		/**
		* 
		* @param	n
		* @param	floatCount
		* @return
		*/
		static public function floatRound(n:Number,floatCount:Number):Number{
			var r:Number = 1 ;
			var i:Number = -1 ;
			while (++i < floatCount) 
			{
				r *= 10 ;
			}
			return Math.round(n*r) / r  ;
		}
		
		
		//adapte la taille d'un objet
		/**
		 * 
		 * @param	target
		 * @param	type
		 * @param	taille
		 */
		static public function resizeObject( target:*, type:String, taille:Number ):void {
			if( type == "W" ){
				target.height = (target.height*taille)/target.width;
				target.width = taille;
			}
			else if( type =="H" ){
				target.width = (target.width*taille)/target.height;
				target.height = taille;
			}
		}
		
		/**
		 * 
		 * @return
		 */
		static public function date():String {
			//--
			var dayTab:Array = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"];
			var monthTab:Array = ["january", "february", "march", "april", "may", "june", "july" ,"august" ,"september", "october", "november", "december"];
			
			var myTime:Date = new Date();
			var timeStr =  String( dayTab[myTime.getDay()]+" "+zero(myTime.getDate())+"-"+monthTab[myTime.getMonth()]+"-"+myTime.fullYear+" "+zero(myTime.getHours()) +":"+ zero(myTime.getMinutes()) +":"+ zero(myTime.getSeconds()) );
			return timeStr;
		}
		
		
		//--put a zero before
		static private function zero( value:* ):String {
			var tmpStr:String;
			if ( value >= 0 && value <= 9 ) {
				tmpStr = "0" + value;
			}
			else {
				tmpStr = String(value);
			}
			return tmpStr
		}
		
		/**
		 * 
		 * @param	value
		 * @return
		 */
		static public function numberToTime( value:Number, displayHours:Boolean ):String 
		{
			var result:String;
			var minutes = Math.floor(value/ 60);
			
			if (displayHours) 
			{
				var hours = Math.floor(minutes / 60);
			}
			var seconds = Math.round(value - (minutes * 60));
			
			if (seconds < 10) 
			{
				seconds = "0" + seconds;
			}
			if (minutes < 10) 
			{
				minutes = "0" + minutes;
			}
			
			if (displayHours) 
			{
				if (hours < 10) 
				{
					hours = "0" + hours;
				}
			}
			
			result = hours + ":" + minutes + ":" + seconds;
			
			return result;
		}

		
	}	
}		