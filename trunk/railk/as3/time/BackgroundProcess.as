/**
 * © 2009 - James McNess
 * http://www.codeandvisual.com
 *
 * edited by Richard Rodney.
 * 
 */

package railk.as3.time 
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class BackgroundProcess
	{
		private var ticker:Shape = new Shape();
		private var idleLength:Number;
		private var functions:Array = [];
		
		/**
		 * CONSTRUCTEUR
		 * 
		 * @param	cpuRatio
		 * @param	frameRate
		 */
		public function BackgroundProcess(cpuRatio:Number,frameRate:Number){
			idleLength = 1000/frameRate*cpuRatio;
			ticker.addEventListener(Event.ENTER_FRAME, loop);
		}

		private function loop(evt:Event){
			var startTime:Number = getTimer(), i = functions.length;
			while(getTimer()-startTime<idleLength&&functions.length>0) while( --i > -1 ) functions[i].apply();
		}
		
		/**
		 * MANAGE PROCESS
		 */
		public function addFunction(f:Function){ if (functions.indexOf(f) == -1) functions[functions.length] = f; }
		public function removeFunction(f:Function){ functions.splice(functions.indexOf(f),1) }
		public function removeAllFunctions(){ functions = []; }
		
		/**
		 * DISPOSE
		 */
		public function destroy(){
			removeAllFunctions();
			ticker.removeEventListener(Event.ENTER_FRAME, loop);
		}
	}
}