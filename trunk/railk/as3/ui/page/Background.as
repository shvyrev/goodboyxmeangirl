/**
 * background
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.page
{	
	import flash.utils.getDefinitionByName;
	import railk.as3.ui.UILoader;
	
	public class Background 
	{
		public var id:String;
		public var component:*;
		
		public function Background(id:String, view:String, src:String, container:*) {
			this.id = id;
			var loader:UILoader = new UILoader(src, function():void {
				component=new (getDefinitionByName(view) as Class)() ;
				container.addChild( component );
			});
		}
	}
}