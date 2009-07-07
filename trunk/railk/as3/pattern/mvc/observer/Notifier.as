/**
* 
* Notifier
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.observer
{
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.core.AbstractFacade;
	
	public class Notifier implements INotifier
	{
		protected var facade:IFacade = AbstractFacade.getInstance();
		public function sendNotification( note:String, info:String, data:*=null ):void {
			facade.sendNotification(note,info,data );
		}
	}
}	