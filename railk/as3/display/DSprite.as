/**
* Sprite with dynamic registration point
* 
* @author Richard Rodney
* @version 0.2
*/

package railk.as3.display 
{
	public class DSprite extends RegistrationPoint 
	{
		private var _extra:Object={};
		public function DSprite( extra:Object = null ){
			super();
			this._extra = (extra)?extra:_extra;
		}
		
		public function get extra():Object { return this._extra; }
		public function set extra( value:Object ):void {
			for ( var prop:String in value) _extra[prop] = value[prop];
		}
	}
}