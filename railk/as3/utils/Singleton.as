package railk.as3.utils {
	
	import flash.utils.Dictionary
	public class Singleton
	{
		private static var insts:Dictionary;
		public static function getInstance(clazz:Class,...cancelParentClasses:Array):*
		{
			var inst:*;
			if(!insts) insts = new Dictionary();
			if(insts[clazz] && insts[clazz] != -1) inst = insts[clazz];
			if(!inst)
			{
				inst = new clazz();
				insts[clazz] = inst;
			}
			if(cancelParentClasses)
			{
				for each(var cl:Class in cancelParentClasses){insts[cl] = -1;}
			}
			return inst;
		}
		public static function assertSingle(clazz:Class):void
		{
			if( !insts )  throw new Error("Error: Instantiation of class "+clazz+" failed: Use "+clazz+".getInstance() instead of new.");
			else if(insts[clazz]) throw new Error("Error creating class "+clazz+",  It's a singleton and cannot be instantiated more than once.");
		}
	}
	
}