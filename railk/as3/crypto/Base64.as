﻿/**
 * BASE64
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.crypto
{	
	import flash.utils.ByteArray;
	
	public class Base64
	{
		private static var BASE64_CHARS:String='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
		
		/**
		 * BASE 64 ENCODE STRING
		 */
		public static function encode(data:String):String {
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(data);			
			return encodeByteArray(bytes);
		}
		
		/**
		 * BASE 64 ENCODE BYTEARRAY
		 */
		public static function encodeByteArray(data:ByteArray):String {
			var output:String = "";
			var dataBuffer:Array;
			var outputBuffer:Array = new Array(4);
			
			data.position = 0;			
			while (data.bytesAvailable > 0) {
				dataBuffer = new Array();
				for (var i:uint = 0; i < 3 && data.bytesAvailable > 0; i++) dataBuffer[i] = data.readUnsignedByte();
				
				outputBuffer[0] = (dataBuffer[0] & 0xfc) >> 2;
				outputBuffer[1] = ((dataBuffer[0] & 0x03) << 4) | ((dataBuffer[1]) >> 4);
				outputBuffer[2] = ((dataBuffer[1] & 0x0f) << 2) | ((dataBuffer[2]) >> 6);
				outputBuffer[3] = dataBuffer[2] & 0x3f;
				
				for (var j:uint = dataBuffer.length; j < 3; j++) outputBuffer[j + 1] = 64;
				for (var k:uint = 0; k < outputBuffer.length; k++) output += BASE64_CHARS.charAt(outputBuffer[k]);
			}
			return output;
		}
		
		/**
		 * BASE 64 DECODE STRING
		 */
		public static function decode(data:String):String {
			var bytes:ByteArray = decodeToByteArray(data);
			return bytes.readUTFBytes(bytes.length);
		}
		
		/**
		 * BASE 64 DECODE BYTEARRAY
		 */
		public static function decodeToByteArray(data:String):ByteArray {
			var output:ByteArray = new ByteArray();
			var dataBuffer:Array = new Array(4);
			var outputBuffer:Array = new Array(3);

			for (var i:uint = 0; i < data.length; i += 4) {
				for (var j:uint = 0; j < 4 && i + j < data.length; j++) dataBuffer[j] = BASE64_CHARS.indexOf(data.charAt(i + j));
      			
				outputBuffer[0] = (dataBuffer[0] << 2) + ((dataBuffer[1] & 0x30) >> 4);
				outputBuffer[1] = ((dataBuffer[1] & 0x0f) << 4) + ((dataBuffer[2] & 0x3c) >> 2);		
				outputBuffer[2] = ((dataBuffer[2] & 0x03) << 6) + dataBuffer[3];
				
				for (var k:uint = 0; k < outputBuffer.length; k++) {
					if (dataBuffer[k+1] == 64) break;
					output.writeByte(outputBuffer[k]);
				}
			}
			output.position = 0;
			return output;
		}
	}	
}