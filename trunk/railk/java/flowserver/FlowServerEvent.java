/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package flowserver;

/**
 *
 * @author Railk
 */


import java.util.EventObject;

public class FlowServerEvent extends EventObject {
    
    // _________________________________________________________________________________ CONSTANTES EVENT
    public static final int ON_CLIENT_CONNECTED = 1 ;
    public static final int ON_CLIENT_DISCONNECTED = 2 ;
    public static final int ON_SERVER_START = 3;
    public static final int ON_SERVER_STOP = 4;
    
     public static final int ON_TABLET_START = 5;
     public static final int ON_TABLET_STOP = 6;
     public static final int ON_CURSOR_CHANGE = 7;
     public static final int ON_PRESSURE_CHANGE = 8;
    
    // __________________________________________________________________________________ VARIABLES EVENT
    private int _args;
    private int _type;

    public FlowServerEvent(Object source, int type){
        super( source );
        _type = type;
    }
    
   public FlowServerEvent(Object source, int type, int args){
        super( source );
        _args = args;
        _type = type;
    }
    
    public int args(){
        return _args;
    }
    
    public int type(){
        return _type;
    }
}
