/**
 * Div Structure parser
 * 
 * @author Richard Rodney
 * @version 0.1 
 */

package railk.as3.ui.div
{	
	import flash.utils.getDefinitionByName;
	public class DivStruct
	{	
		private static var lastDiv:IDiv;
		private static var attributes:Object =  { 'class':null, float:'none', align:'none', margins:null, posistion:'relative', x:0, y:0 };
		private static var margins:Object =  { 0:'top', 1:'right', 2:'bottom', 3:'left' };
		
		public static function construct(container:*, xml:XML):void {
			var length:int = xml.children().length();
			for (var i:int = 0; i < length; i++) addDiv(container, xml.children()[i]);
		}
		
		private static function addDiv(container:*, child:XML):void {
			var div:IDiv, length:int = child.children().length();
			if ( A('class',child) ) 
				div = new (getDefinitionByName(A('class',child)))( child.@id, A('float',child), A('align',child), null, A('position',child), A('x',child), A('y',child));
			else { 
				div = new Div( child.@id, A('float',child), A('align',child), A('margins',child), A('position',child), A('x',child), A('y',child) );
				var X:Number = ((lastDiv)?lastDiv.x:0), Y:Number = ((lastDiv)?lastDiv.y:0);
				if (div.float == 'none') Y = Y+div.margins.top+((lastDiv)?lastDiv.height+lastDiv.margins.bottom:0);
				else if ( div.float == 'left') X = X+div.margins.left+((lastDiv)?lastDiv.width+lastDiv.margins.right:0);
				div.x = X;
				div.y = Y;
				div.state.update();
				if (lastDiv) lastDiv.addArc(div);
				lastDiv = div;
			}	
			for (var i:int = 0; i < length; i++) addDiv(div, child.children()[i]);
			container.addChild(div);
		}
		
		private static function A( name:String, xml:XML ):* {
			for (var i:int = 0; i < xml.@*.length(); ++i){
				if (name == xml.@*[i].name()) {
					if (name == 'margins') {
						var a:Array = (xml.@*[i].toString()).split(','), result:Object={ top:0,right:0,bottom:0,left:0 };
						if(a.length==1){ var value:Number = Number(a[0]); result={top:value,right:value,bottom:value,left:value}; }
						else for (var i:int = 0; i < a.length; i++) result[margins[i]] = Number(a[i]);
						return result;
					}
					return xml.@*[i];
				}
			}	
			return attributes[name];
		}	
	}
}