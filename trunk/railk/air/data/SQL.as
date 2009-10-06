/**
 * DATABASE
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.air.data 
{
	import flash.data.*;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.ErrorEvent;
	import flash.filesystem.File;
	import flash.events.SQLEvent;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLUpdateEvent;
	
	public class SQL extends EventDispatcher
	{
		public var type:String;
		public var mode:String;
		public var encryptionKey:String;
		public var result:SQLResult;
		
		private var connection:SQLConnection;
		private var request:SQLStatement;
		
		/**
		 * CONSTRUCTEUR
		 * @param	type	async|sync
		 */
		public function SQL(type:String='async',mode:String='create',encryptionKey:String='') {
			this.type = type;
			this.mode = mode;
			this.encryptionKey = encryptionKey;
		}
		
		/**
		 * CONNECTIONS
		 * @param	dbName
		 */
		public function connect(dbName:String=''):void {
			connection = new SQLConnection();
			connection.addEventListener(SQLEvent.OPEN, manageEvent, false, 0, true);
			connection.addEventListener(SQLErrorEvent.ERROR, manageEvent, false, 0, true);
			open( (dbName?File.applicationStorageDirectory.resolvePath(dbName):null) );
		}
		
		private function open(db:File):void {
			if (type == 'async') connection.openAsync( db );
			else connection.open( db, mode, false, 1024, encryptionKey);
			request = new SQLStatement();
			request.sqlConnection = connection;
			request.addEventListener( SQLEvent.RESULT, manageEvent, false, 0, true );
		}
		
		public function close():void {
			connection.close();
		}
		
		/**
		 * SQL ACTIONS
		 */
		public function select(data:String, from:String, where:String='', orderBy:String='', limit:String=''):void {
			request.text = 'SELECT '+data+' FROM '+from+(where?' WHERE '+where:'')+(orderBy?' ORDER BY '+orderBy:'')+(limit?' LIMIT '+limit:'');
			request.execute();
		}
		
		public function insert(table:String, into:String, data:String ):void {
			request.text = 'INSERT INTO '+table+'('+into+') VALUES('+data+')';
			request.execute();
		}
		
		public function update(table:String,data:String,where:String=''):void {
			request.text = 'UPDATE '+table+' SET '+data+(where?' WHERE '+where:'');
			request.execute();
		}
		
		public function delete(from:String, where:String=''):void {
			request.text = 'DELETE FROM '+from+(where?' WHERE '+where:'');
			request.execute();
		}
		
		public function createTable(name:String, fields:String):void {
			request.text = 'CREATE TABLE IF NOT EXISTS '+name+'('+fields+')';
			request.execute();
		}
		
		public function alterTable(name:String,add:String:'',rename:String:''):void {
			request.text = 'ALTER TABLE '+name+(rename?' RENAME TO '+name:'')+(add?' ADD '+add:'');
			request.execute();
		}
		
		public function dropTable(name:String):void {
			request.text = 'DROP TABLE IF EXISTS ' + name;
			request.execute();
		}
		
		 /**
		  * MANAGE EVENT
		  * @param	evt
		  */
		private function manageEvent(evt:*):void {
			switch(evt.type) {
				case SQLEvent.OPEN : connection.removeEventListener(SQLEvent.OPEN, manageEvent); break;
				case SQLErrorEvent.ERROR : dispatchEvent(new SQLEvents( SQLEvents.ON_CONNECTION_ERROR,evt.error )); break;
				case SQLEvent.RESULT :
					result = evt.target.getResult();
					if ( result && result.data ) dispatchEvent( new SQLEvents(SQLEvents.ON_RESULT,result.data));
					else dispatchEvent(new SQLEvents( SQLEvents.ON_NO_RESULT ));
					break;
			}
		}
	}
}