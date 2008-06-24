/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package flowserver;

/**
 *
 * @author Railk
 */

import java.util.EventListener;

public interface FlowServerListener extends EventListener {
    public void onEventFired( FlowServerEvent evt);
}
