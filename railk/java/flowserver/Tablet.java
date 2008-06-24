/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package flowserver;

/**
 *
 * @author Railk
 */

import java.lang.Thread;
import javax.swing.event.EventListenerList;
import cello.tablet.*;

public class Tablet extends Thread {
    
    // _________________________________________________________________________________ VARIABLES TABLET
    private JTablet tablet;
    private JTabletCursor cursor = null;
    private int previousPressure = 0;
    
    // __________________________________________________________________________________ VARIABLES EVENT
    protected EventListenerList listenerList = new EventListenerList();
    
    
    public Tablet() throws JTabletException {
        try {
            tablet = new JTablet();
        } catch (JTabletException e) {
            e.printStackTrace();
        }
    }
    
    public void run(){
        //--
        fireEvent( new FlowServerEvent(this,FlowServerEvent.ON_TABLET_START) );
        //--
        cursor = null;
        while (true) {
            try {
                    tablet.poll();
            } catch (JTabletException ex) {
                    ex.printStackTrace();
            }
            if (cursor != tablet.getCursor()) {
                    cursor = tablet.getCursor();

                    /*switch (cursor.getCursorTypeSpecific()) {
                            case JTabletCursor.TYPE_STYLUS:
                                    fireEvent( new FlowServerEvent(this,FlowServerEvent.ON_CURSOR_CHANGE,JTabletCursor.TYPE_STYLUS) );
                                    break;
                            case JTabletCursor.TYPE_AIRBRUSH:
                                    fireEvent( new FlowServerEvent(this,FlowServerEvent.ON_CURSOR_CHANGE,JTabletCursor.TYPE_AIRBRUSH) );
                                    break;
                            case JTabletCursor.TYPE_4DMOUSE:
                                    fireEvent( new FlowServerEvent(this,FlowServerEvent.ON_CURSOR_CHANGE,JTabletCursor.TYPE_4DMOUSE) );
                                    break;
                            case JTabletCursor.TYPE_LENS_CURSOR:
                                    fireEvent( new FlowServerEvent(this,FlowServerEvent.ON_CURSOR_CHANGE,JTabletCursor.TYPE_LENS_CURSOR) );
                                    break;

                    }*/
                    switch (cursor.getCursorType()) {
                            /*case JTabletCursor.TYPE_UNKNOWN:
                                    fireEvent( new FlowServerEvent(this,FlowServerEvent.ON_CURSOR_CHANGE,JTabletCursor.TYPE_UNKNOWN) );
                                    break;*/
                            case JTabletCursor.TYPE_PEN_TIP:
                                    fireEvent( new FlowServerEvent(this,FlowServerEvent.ON_CURSOR_CHANGE,JTabletCursor.TYPE_PEN_TIP) );
                                    break;
                            case JTabletCursor.TYPE_PEN_ERASER:
                                    fireEvent( new FlowServerEvent(this,FlowServerEvent.ON_CURSOR_CHANGE,JTabletCursor.TYPE_PEN_ERASER) );
                                    break;
                           /* case JTabletCursor.TYPE_PUCK:
                                    fireEvent( new FlowServerEvent(this,FlowServerEvent.ON_CURSOR_CHANGE,JTabletCursor.TYPE_PUCK) );
                                    break;*/

                    }
            }
            
            if( cursor != null && previousPressure != cursor.getData(JTabletCursor.DATA_PRESSURE) ){
                fireEvent( new FlowServerEvent(this,FlowServerEvent.ON_PRESSURE_CHANGE, cursor.getData(JTabletCursor.DATA_PRESSURE) ) );
                previousPressure = cursor.getData(JTabletCursor.DATA_PRESSURE);
            }    
            
            try {
                    Thread.yield();
                    Thread.sleep(10);
            } catch (Exception e) {}
        }
    }
    
    // ——————————————————————————————————————————————————————————————————————————————————————————————————
    // 								                             MANAGE EVENT
    // ——————————————————————————————————————————————————————————————————————————————————————————————————
    public void addEventListener(FlowServerListener listener) {
        listenerList.add(FlowServerListener.class, listener);
    }

    public void removeEventListener(FlowServerListener listener) {
        listenerList.remove(FlowServerListener.class, listener);
    }

    private void fireEvent( FlowServerEvent evt) {
        Object[] listeners = listenerList.getListenerList();

        for (int i=0; i<listeners.length; i+=2) {
            if (listeners[i]==FlowServerListener.class) {
                ((FlowServerListener)listeners[i+1]).onEventFired(evt);
            }
        }
    }
}
