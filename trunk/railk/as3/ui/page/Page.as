/**
 * Page
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.page
{
	import flash.utils.getDefinitionByName;
	import railk.as3.pattern.mvc.core.View;
	import railk.as3.pattern.mvc.interfaces.*
	import railk.as3.pattern.mvc.observer.Notification;
	import railk.as3.ui.div.Div;
	import railk.as3.ui.layout.Layout;
	import railk.as3.ui.loader.*;
	import railk.as3.ui.view.UIView;
	
	public class Page extends View implements IPage,IView,INotifier
	{
		private var _firstChild:IPage;
		private var _lastChild:IPage;
		private var _next:IPage;
		private var _prev:IPage;
		
		private var _id:String;
		private var _title:String;
		private var _parent:IPage;
		private var _anchor:String;
		private var _transition:ITransition;
		
		protected var align:String;
		protected var layout:Layout;
		protected var src:String;
		protected var loaded:Boolean;
		protected var reload:Boolean;
		protected var transitionName:String;
		protected var loadingView:IPageLoading;
		protected var length:Number=0;
		protected var loader:UILoader;
		
		public function Page( MID:String, id:String, parent:IPage, title:String, loading:String, layout:Layout, align:String, src:String, transitionName:String) {
			super(MID,id);
			_id = id;
			_parent = parent;
			_title = title;
			this.layout = layout;
			this.align = (align)?align:'TL';
			this.loadingView = new (getDefinitionByName(loading))() as IPageLoading;
			this.src = src;
			this.transitionName = transitionName;
			this.component = new PageDiv(id,'none',this.align);
			data = '<h1>'+title+'</h1>\n';
		}
		
		/**
		 * ADD A PAGE CHILD (SUB PAGE)
		 * @param	child
		 */
		public function addChild( child:IPage ):void {
			if (!firstChild) firstChild = lastChild = child;
			else {
				lastChild.next = child;
				child.prev = lastChild;
				lastChild = child;
			}
			length++;
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
				default : break;
			}
		}
		
		/**
		 * SHOW/HIDE
		 */
		override public function show():void {
			(facade.container as PageStruct).addDiv(component);
			component.addChild( loadingView );
			var progress:Function = function(p:Number):void { loadingView.percent = p; };
			var complete:Function = function():void { component.removeChild( loadingView ); setupViews(layout.views); loaded = true; };
			if (!loaded && !reload) loader = loadUI(src).complete(complete).progress(((loadingView)?progress:null),((loadingView)?UILoader.PERCENT:null)).start();
			else complete.apply();
		}
		
		override public function hide():void {
			loader.stop();
			var i:int=0, views:Array = layout.views;
			(component as PageDiv).unbind();
			try { for (i = 0; i < views.length; ++i) views[i].div.unbind(); }
			catch (e:Error) { /*throw e;*/}
			while(component.numChildren) component.removeChildAt(0);
			try { (facade.container as PageStruct).removeChild(component); }
			catch (e:ArgumentError){ /*throw e;*/ }
			component = new PageDiv(id,'none',align);
		}
		
		/**
		 * ZOOM/DEZOOM/ADAPT/ANCHOR
		 */
		public function zoom():void {}
		public function dezoom():void {}
		public function adapt():void { }
		public function castAnchor(anchor:String):void {}
		
		/**
		 * PLAY/STOP
		 */
		public function stop():void {}
		public function play():void { 
			if (anchor) castAnchor(anchor);
		}
		
		/**
		 * DISPOSE
		 */
		override public function dispose():void { layout = null; }
		
		/**
		 * 	UTILITIES
		 */
		protected function setupViews(views:Array):void {
			for (var i:int = 0; i < views.length; i++) {
				views[i].setup();
				if (!views[i].container)component.addDiv( views[i].div );
				else views[i].container.div.addDiv( views[i].div  );
				data += (views[i].div.data != null)?views[i].div.data:'';
				(facade.registerView(views[i].viewClass,views[i].id,views[i].div,views[i].data) as UIView).style = views[i].style;
				if (views[i].visible) facade.getView(views[i].id).show();
			}
			if (transitionName) _transition = new (getDefinitionByName(transitionName))() as ITransition;
			(facade as PageManager).enablePage(this);
		}
		
		/**
		 * 	GETTER/SETTER
		 */
		public function get id():String { return _id; }
		public function get title():String { return _title; }
		public function get parent():IPage { return _parent; }
		public function get transition():ITransition { return _transition; }
		public function get isRoot():Boolean { return !Boolean(parent); }
		public function get isLeaf():Boolean { return length == 0; }
		public function get hasChildren():Boolean { return length > 0; }
		public function get depth():int {
			if (!parent) return 0;
			var child:IPage = this, c:int = 0;
			while (child.parent) {
				c++;
				child = child.parent;
			}
			return c;
		}
		public function get firstChild():IPage { return _firstChild; }
		public function set firstChild(value:IPage):void { _firstChild = value; }
		public function get lastChild():IPage { return _lastChild; }
		public function set lastChild(value:IPage):void { _lastChild = value; }
		public function get next():IPage { return _next; }
		public function set next(value:IPage):void { _next = value; }
		public function get prev():IPage { return _prev; }
		public function set prev(value:IPage):void { _prev = value; }
		public function get anchor():String { return _anchor; }
		public function set anchor(value:String):void { _anchor = value; }
		
		/**
		 * TO STRING
		 * @return
		 */
		public function toString():String { return '[ PAGE > '+id+ ' ]'; }
	}
}