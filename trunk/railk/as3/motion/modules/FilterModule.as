﻿/** *  * Twin Filter Module *  * @author Richard Rodney * @version 0.1 */package railk.as3.motion.modules {	import flash.filters.BitmapFilter;	import flash.utils.getQualifiedClassName;	import railk.as3.motion.utils.Prop;	public class FilterModule {		static public function update( target:Object, props:Prop, r:Number ):Prop {			var filters:Array = target.filters, b:BitmapFilter=props.start, e:Object=props.end;			for ( var p:String in e) b[p] = b[p]+(e[p]-b[p])*r;			for (var i:int=0; i<filters.length; i++) if (filters[i].toString() == getQualifiedClassName(b)) filters.splice(i, 1);			filters.push( b );			target.filters = filters;			return props;		}	}}