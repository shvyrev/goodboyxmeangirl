/**
 * DIV STATE
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.div
{
	public class DivState
	{
		public var top:Number=0;
		public var right:Number=0;
		public var bottom:Number=0;
		public var left:Number = 0;
		public var x:Number=0;
		public var y:Number=0;
		private var _stageWidth:Number=NaN;
		private var _stageHeight:Number = NaN;
		private var _width:Number=NaN;
		private var _height:Number = NaN;
		
		public function DivState(x:Number=0, y:Number=0, width:*=null, height:*=null, top:Number=0, right:Number=0, bottom:Number=0, left:Number=0) {
			this.x = x;
			this.y = y;
			this.top = top;
			this.right = right;
			this.bottom = bottom;
			this.left = left;
			setWidth(width);
			setHeight(height);
		}
		
		public function setWidth(value:*):DivState { 
			_width = (!value)?NaN:(width is Number)?value:NaN;
			if (value && value is String) _stageWidth = (value.search('%') != -1)?Number(value.replace('%', '')) * .01:NaN;
			return this;
		}
		
		
		public function setHeight(value:*):DivState { 
			_height = (!value)?NaN:(value is Number)?value:NaN;
			if (value && value is String) _stageHeight = (value.search('%') != -1)?Number(value.replace('%', '')) * .01:NaN;
			return this;
		}
		
		public function get stageHeight():Number { return _stageHeight; }
		public function get stageWidth():Number { return _stageWidth; }
		public function get width():Number { return _width; }
		public function get height():Number { return _height; }
	}
}