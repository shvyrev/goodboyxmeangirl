package railk.as3.tween.process.utils {
	
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import railk.as3.tween.process.Process;
	public dynamic class TargetProxy extends Proxy {
		
		private var process:Process;
		public function TargetProxy(process:Process):void { this.process = process; }
		
		flash_proxy override function callProperty(methodName:*, ...args:Array):* { process.target[methodName].apply(null,args); }
		
		flash_proxy override function getProperty(prop:*):* {
			var value:Number = process.getProp(prop);
			return (isNaN(value)) ? process.target[prop] : value;
		}
		
		flash_proxy override function setProperty(prop:*,value:*):void {
			if (isNaN(value)) { process.target[prop] = value; }
			else { process.setProp(String(prop), Number(value)); }
		}
		
		flash_proxy override function deleteProperty(prop:*):Boolean { return process.deleteProp(prop);}
	}
}