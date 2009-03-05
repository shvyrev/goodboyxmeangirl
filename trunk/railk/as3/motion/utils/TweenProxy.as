/**
 * 
 * RTween Proxy
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion.utils
{	
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import railk.as3.motion.tween.StandartTween;
	
	public dynamic class TweenProxy extends Proxy 
	{
		private var t:StandartTween;
		public function TweenProxy(t:StandartTween):void { this.t = t; }
		
		flash_proxy override function callProperty(methodName:*, ...args:Array):* { t[methodName].apply(null,args); }
		flash_proxy override function getProperty(name:*):* { return t.getProp(name); }
		flash_proxy override function setProperty(name:*,value:*):void { t.setProp(name, value); }
		flash_proxy override function deleteProperty(name:*):Boolean { return t.delProp(name);}
	}
}