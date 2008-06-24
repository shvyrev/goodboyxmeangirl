/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package flowserver;

/**
 *
 * @author Railk
 */
import java.io.IOException;
import java.applet.*;
import java.awt.*;
import javax.swing.*;
import cello.tablet.JTabletException;


public final class main extends Applet implements FlowServerListener {
    
    private static FlowServer server;
    private static Tablet tablet;

    
    private static final String APPNAMEVERSION = "FlowServer version 0.1";
    private static JFrame frame;
    private static JLabel labelCursor;
    private static JLabel labelPressure;
    private static JLabel labelTablet;
    private static JLabel labelServer;
    private static JLabel labelClient;
    
    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        frame = new JFrame(APPNAMEVERSION);
        main app = new main();
        frame.add(app);
        frame.add( createPanel() );
        frame.setSize(100,150);
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
        
        app.init();
        app.start();
    }
    
    @Override
    public void init(){
        
        //--init tablet
        try {
            tablet = new Tablet();
        }
        catch(JTabletException e){
            e.printStackTrace();
        }
                
        //--init server
        try {
            server = new FlowServer( "localhost",new Integer(50080) );
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    @Override
    public void start() {
       server.addEventListener(this);
       server.start();
       
       tablet.addEventListener(this);
       tablet.start();
    }
    
    @Override
    public void stop() {
        server.stopListening();
        server.removeEventListener(this);
        tablet.removeEventListener(this);
	server = null;
        tablet = null;
    }
   
    
    @Override
    public void finalize(){
        stop();
        destroy();
    }
    
    
    private static JPanel createPanel(){
        //--panel
        JPanel panel = new JPanel();
        panel.setLayout( new GridLayout(5, 1) );
        
        //--state labels
	labelCursor = new JLabel();
        labelPressure = new JLabel();
        labelTablet = new JLabel();
        labelServer = new JLabel();
        labelClient = new JLabel();
        
	panel.add(labelCursor);
        panel.add(labelPressure);
        panel.add(labelTablet);
        panel.add(labelServer);
        panel.add(labelClient);
        
        return panel;
    }
    
    
    public void onEventFired(FlowServerEvent evt){
        switch(evt.type()){
            case FlowServerEvent.ON_CLIENT_CONNECTED :
                System.out.println("client connected");
                //labelClient.setText("client connected");
                break;
                
            case FlowServerEvent.ON_CLIENT_DISCONNECTED :
                System.out.println("client disconnected");
                //labelClient.setText("client disconnected");
                break;
            
            case FlowServerEvent.ON_SERVER_START :
                System.out.println("server started");
                //labelServer.setText("server started");
                break;
            
            case FlowServerEvent.ON_SERVER_STOP :
                System.out.println("server stoped");
                //labelServer.setText("server stoped");
                break; 
                
            case FlowServerEvent.ON_TABLET_START :
                System.out.println("tablet started");
                //labelTablet.setText("tablet started");
                break;
            
            case FlowServerEvent.ON_TABLET_STOP :
                System.out.println("tablet Stoped");
                //labelTablet.setText("tablet stoped");
                break;    
                
            case FlowServerEvent.ON_CURSOR_CHANGE :
                System.out.println("cursor "+evt.args());
                //labelCursor.setText("cursor "+evt.args());
                server.sendData("cursor/"+evt.args());
                break;
             
            case FlowServerEvent.ON_PRESSURE_CHANGE :
                //System.out.println("pressure "+evt.args());
                //labelPressure.setText("pressure "+evt.args());
                server.sendData("pressure/"+evt.args());
                break;    
        }
    }
}
