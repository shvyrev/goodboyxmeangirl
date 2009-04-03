/**
 * 
 * Layout Arc for layout graph engine
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	public class LayoutArc
	{
		public var bloc:LayoutBloc;
		public var weight:int;
		
		/**
		 * CONSTRUCTEUR
		 */
		public function LayoutArc(bloc:LayoutBloc, weight:int=1){
			this.bloc=bloc;
			this.weight=weight;
		}
	}
}