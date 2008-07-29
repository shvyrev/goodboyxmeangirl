/**
* 
* Interface for the comment layout configutation
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.utils.comment
{
	
	public interface IConfig
	{
		function createEmptyCom():Object;
		function createComName():Object;
		function createComMail():Object;
		function createComTexte():Object;
		function createComDate():Object;
		function createComWebsite():Object;
		function createComNote():Object;
		function createComAnswer():Object;
		function createComEdit():Object;
		function createComDelete():Object;
		function createFormName():Object;
		function createFormMail():Object;
		function createFormWebsite():Object;
		function createFormTexte():Object;
		function createFormReset():Object;
		function createFormSend():Object;
		function createFormView():Object;
		function createScrollBar( toScroll:* ):Object;
	}
	
}