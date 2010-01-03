/**
 * UIloader
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.loader
{	
	public function loadUI(url:String, noCache:Boolean=true):UILoader { return new UILoader(url, noCache); }
}