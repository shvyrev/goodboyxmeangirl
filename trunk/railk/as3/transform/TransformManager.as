/**
* 
* Tool for manipulating object in flash
* 
* @author Richard Rodney
*/

package railk.as3.transform
{
	import flash.display.Stage;
	import railk.as3.utils.RegistrationPoint;
	import railk.as3.utils.Clone;
	
	public class TransformManager
	{
		public static function init( stage:Stage ):void
		{
			
		}
		
		public static function enable( object:* ):void 
		{
			
		}
		
		public static function remove():void 
		{
			
		}
		
		 public static function acuteAngle(anglr:Number) : Number
        {
            if (angle != angle % Math.PI)
            {
                angle = angle % (Math.PI * 2);
                if (angle < -Math.PI)
                {
                    return Math.PI + angle % Math.PI;
                }
                if (angle > Math.PI)
                {
                    return -Math.PI + angle % Math.PI;
                }
            }
            return angle;
        }
	}
}