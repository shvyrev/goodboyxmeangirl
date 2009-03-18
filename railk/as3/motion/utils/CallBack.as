/**
 * 
 * Tween CallBack
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion.utils
{
	public class CallBack
	{
		public var position:Number;
		public var onCallBack:Function;
		public var onCallBackParams:Array;
		
		public function CallBack(position:Number=NaN,onCallBack:Function=null,onCallBackParams:Array=null) {
			this.position = position
			this.onCallBack = onCallBack;
			this.onCallBackParams = onCallBackParams;
		}
		
		public function apply():void {
			if(onCallBack!=null) onCallBack.apply(null,onCallBackParams)
		}
	}
}