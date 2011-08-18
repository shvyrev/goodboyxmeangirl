/**
 * Block
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.page
{	
	import railk.as3.pattern.mvc.core.View;
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.observer.Notification;
	import railk.as3.ui.layout.ILayout;
	import railk.as3.ui.div.Div;
	import railk.as3.ui.loader.*;
	
	public class Block extends View implements IBlock,IView,INotifier
	{
		protected var _prev:IBlock;
		protected var _next:IBlock;
		protected var _visible:Boolean;
		protected var _anchor:String;
		protected var _id:String;
		
		protected var layout:ILayout;
		protected var align:String;
		protected var onTop:Boolean;
		protected var css:String;
		protected var loader:UILoader;
		
		public function Block( MID:String, id:String, layout:ILayout, align:String, onTop:Boolean, visible:Boolean ) {
			super(MID, id);
			this.id = id;
			this.layout = layout;
			this.align = align;
			this.onTop = onTop;
			this.visible = visible;
			this.component = new Div(id,'none',align);
		}
		
		/**
		 * NOTIFICATION HANDLER
		 * 
		 * @param	evt
		 */
		override public function handleNotification(evt:Notification):void {
			switch(evt.note) {
				case 'zoom': zoom(); break;
				case 'dezoom': dezoom(); break;
				case 'adapt': adapt(); break;
				default : break;
			}
		}
		
		/**
		 * 	SHOW/HIDE/UPDATE
		 */
		override public function show():void {
			(facade.container as PageStruct).addBlock(component, onTop);
			Plugins.getInstance().initMonitor(_id,layout.views.concat(), enablePage);
			setupViews(layout.views);
		}
		
		override public function hide():void {
			loader.stop();
			for (var i:int = 0; i < component.numChildren; i++) component.removeChildAt(i);
			(facade.container as PageStruct).delBlock(component);
			component = new Div(id,'none',align);
		}
		
		protected function enablePage():void { 
			if (anchor) castAnchor(anchor); 
		}
		
		public function update():void { }
		
		/**
		 * ZOOM/DEZOOM
		 */
		public function zoom():void {}
		public function dezoom():void {}
		public function adapt():void {}
		public function castAnchor(anchor:String):void {}
		
		/**
		 * 	UTILITIES
		 */		
		protected function setupViews(views:Array):void {
			for (var i:int = 0; i < views.length; i++) views[i].setup(_id,facade,component,data,true);
		}
		
		/**
		 * 	GETTER/SETTERS
		 */	
		public function get prev():IBlock { return _prev; }
		public function set prev(value:IBlock):void { _prev = value; }
		public function get next():IBlock { return _next; }
		public function set next(value:IBlock):void { _next = value; }
		public function get anchor():String { return _anchor; }
		public function set anchor(value:String):void { _anchor = value; }
		public function get visible():Boolean { return _visible; }
		public function set visible(value:Boolean):void { _visible = value; }
		public function get id():String { return _id; }
		public function set id(value:String):void { _id = value; }

	}
}