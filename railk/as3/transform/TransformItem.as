/**
* 
* Tool for manipulating object in flash
* 
* @author Richard Rodney
*/

package railk.as3.transform {
	
	import railk.as3.utils.RegistrationPoint;
	import railk.as3.transform.utils.
	
	public class TransformItem extends RegistrationPoint
	{
		private var type:String;
		
		public function TransformItem( object:* )
		{
			
		}
		
		
		public function changeRegistration(x:Number, y:Number):void
		{
			super.setRegistration( x, y );
		}
	}
	
}