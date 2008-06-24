package flowserver;

/**
 *
 * @author Railk
 */

// __________________________________________________________________________________________ IMPORT JAVA
import java.net.*;
import java.io.*;
import java.lang.Thread;
import javax.swing.event.EventListenerList;


public final class FlowServer extends Thread {
    
    // ________________________________________________________________________________ VARIABLES SERVEUR
    private Integer _port;
    private String _adress;
    
    private Boolean listening = true;
    private Boolean clientConnected=false;
    private ServerSocket serverSocket = null;
    private Socket socket = new Socket();
    private BufferedReader input;
    private PrintWriter output;
    private String message;
    private String policy_file = "<?xml version='1.0' encoding='UTF-8'?><cross-domain-policy xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:noNamespaceSchemaLocation='http://www.adobe.com/xml/schemas/PolicyFileSocket.xsd'><allow-access-from domain='*' to-ports='*' secure='false' /><site-control permitted-cross-domain-policies='master-only' /></cross-domain-policy>";
    private String policy_file_old ="<?xml version='1.0'?><!DOCTYPE cross-domain-policy SYSTEM 'http://www.macromedia.com/xml/dtds/cross-domain-policy.dtd'><cross-domain-policy><allow-access-from domain='*' to-ports='*'/></cross-domain-policy>";
    
    // __________________________________________________________________________________ VARIABLES EVENT
    protected EventListenerList listenerList = new EventListenerList();
    
    
    // ——————————————————————————————————————————————————————————————————————————————————————————————————
    // 								                             CONSTRUCTEUR
    // ——————————————————————————————————————————————————————————————————————————————————————————————————
    public FlowServer() throws IOException  {
        //--vars
        _port = 50080;
        _adress = "localhost";
        
        //--initialisation du server
        try {
            serverSocket = new ServerSocket(_port.intValue());
        } catch (IOException e) {
            System.err.println("Could not listen on port: 50080.");
            //System.exit(1);
        }
    }
    
    public FlowServer( String adress, Integer port ) throws IOException {
        
        //--vars
        _port = port;
        _adress = adress;
        
        //--initialisation du server
        try {
            serverSocket = new ServerSocket(port.intValue());
        } catch (IOException e) {
            System.err.println("Could not listen on port: 50080.");
            //System.exit(1);
        }
    }
    
    // ——————————————————————————————————————————————————————————————————————————————————————————————————
    //                                                                                                RUN
    // ——————————————————————————————————————————————————————————————————————————————————————————————————
    public void run() {
     //--server started   
     fireEvent( new FlowServerEvent(this,FlowServerEvent.ON_SERVER_START) ); 
     
     //--ecoute du server
     while (listening) {
        try {
           // On accepte la socket cliente.
           socket = serverSocket.accept();

            // Si la connexion est établie.
            if (socket.isConnected()) {
               clientConnected = true;
               fireEvent( new FlowServerEvent(this,FlowServerEvent.ON_CLIENT_CONNECTED) );
            }
            else {
               clientConnected = false;
               fireEvent( new FlowServerEvent(this,FlowServerEvent.ON_CLIENT_DISCONNECTED) ); 
            }

            //--cannaux de lecture et d'ecriture
            input = new BufferedReader( new InputStreamReader( socket.getInputStream()));
            output = new PrintWriter(socket.getOutputStream(),true);

            //--send policy file
            sendData( policy_file );

            try {
               // On récupère le contenu de la connexion (j'ai envoyé un objet ds ma socket).
               message =  input.readLine();
               System.out.println("SERVER/message recu = "+ message );
            }
            catch(IOException e ){
               System.out.println("SERVER/Le type de l'objet recu est inconnu!" );
            }

        }
        catch (IOException e) {
            System.out.println("SERVER/l'acceptation de la socket cliente a échouée!" );
        }
        
        try {
                Thread.yield();
                Thread.sleep(10);
        } catch (Exception e) {}
        
     }
     
     // On a décidé de ne plus écouter les appels client; le thread va se terminer.
     try {
       output.close();
       input.close();
       socket.close();
       serverSocket.close();
       fireEvent( new FlowServerEvent(this,FlowServerEvent.ON_SERVER_STOP) );
     }
     catch (IOException e) {
       System.out.println("SERVER/la tentative de fermeture du thread serveur a échouée!" );
     }
    }
    
    
    // ——————————————————————————————————————————————————————————————————————————————————————————————————
    //                                                                                          SEND DATA
    // ——————————————————————————————————————————————————————————————————————————————————————————————————
    public void sendData( String data ){
        if(socket.isConnected()){
            output.print( data + (char)0x00 );
            output.flush();
        }
        System.out.println(data);
    }


    // ——————————————————————————————————————————————————————————————————————————————————————————————————
    //                                                                                        STOP SERVER
    // ——————————————————————————————————————————————————————————————————————————————————————————————————
    public void stopListening() {
        listening = false;
    }

    // ——————————————————————————————————————————————————————————————————————————————————————————————————
    // 								                            GETTER/SETTER
    // ——————————————————————————————————————————————————————————————————————————————————————————————————
    public int port(){
        return _port;
    }

    public String adress (){
        return _adress;
    }

    public boolean client(){
        return clientConnected;
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
