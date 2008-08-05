<?php
class Admin extends Controller {

	var $login_error;
	var $login_banned;

	function Admin()
	{
		parent::Controller();
		$this->load->helper('form');
		$this->load->library('user_agent');
		$this->load->model('admin_model', 'Get', TRUE);
	}
	
	function index()
	{
		$this->_checkCookie();
		$data['title'] = "Flow Cms | Login";
		$data['query'] = $this->db->get('users');
		$data['browser'] = $this->_checkBrowser();
		$data['meta'] = $this->_create_meta();
		$data['css'] = $this->_create_css();
		if ($this->redux_auth->logged_in()) 
		{ 
			$data['login_state'] = 'true'; 
			$data['js'] = $this->_create_js('logged'); 
			$data['username'] = $this->redux_auth->current_user();
		}
		else 
		{ 
			$data['login_state'] = 'false'; 
			$data['js'] = $this->_create_js();
			$data['login'] = $this->_create_login();
		}
		
		////////////////////////////////////////
		$this->load->view('admin_view', $data);
		////////////////////////////////////////
	}
	
	function _checkCookie()
	{
		$ck = get_cookie('flow');
		if ( !empty( $ck ) )
		{
			list($user, $pass) = split(',', $ck);
			$this->redux_auth->login($user,$pass);
		}
	}
	
	function _checkBrowser()
	{
		if ($this->agent->is_browser())
		{
			$agent = $this->agent->browser().' '.$this->agent->version();
		}
		elseif ($this->agent->is_robot())
		{
			$agent = $this->agent->robot();
		}
		elseif ($this->agent->is_mobile())
		{
			$agent = $this->agent->mobile();
		}
		else
		{
			$agent = 'Unidentified User Agent';
		}

		return $agent;
	}
	
	function _create_js( $logged='' )
	{
		$js = js('prototype.js');
		$js .= js('scriptaculous/scriptaculous.js');
		$js .= js('jquery/jquery.js');
		$js .= js('thickbox/thickbox.js');
		$js .= js('lightbox/js/lightbox.js');
		$js .= js('swfobject.js');
		$js .= js('swfaddress.js');
		$js .= js('swfmacmousewheel2.js');
		$js .= js('onJSReady.js');
		$js .= js('replaceHtml.js');
		if( $logged=='' ) $js .= js('login.js');
		
		return $js;
	}
	
	function _create_css()
	{
		if ( $this->_checkBrowser() == 'Internet Explorer 6.0' ) $css = link_tag(CSSPATH.'/admin_ie6.css'); 
		else $css = link_tag(CSSPATH.'/admin.css');
		
		return $css;
	}
	
	function _create_meta()
	{
		$meta = '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />';
		return $meta;
	}	
	
	function _create_login()
	{
		$login = form_open('admin/login');
		$login .= '<label for="username">Login : </label><br />';
		$login .= form_input('username','','id=user_login').'<br />';
		$login .= '<label for="password">Password : </label><br />';
		$login .= form_password('password', '', 'id=user_pass').'<br />';
		$login .= '<label for="checkbox"> </label>';
		$login .= '<p class="souvenir">'.form_checkbox('rememberme', 'checked','','class=souvenir').' Se souvenir de moi</p>';
		$login .= '<label for="submit"> </label>';
		$login .= '<p class="submit">'.form_submit('submit', 'Connexion','id=submit').'</p>';
		$login .= form_close();
		$login .= '<p id="nav">'.anchor( 'admin/forgotten', 'Mot de passe oubli&eacute; ?' ).'</p>';
		
		
		return $login;
	}
	
	
	function login ()
	{
		$rules['username']	= "";
		$rules['password']	= "";
		$rules['rememberme'] = "";
		
		$this->validation->set_rules($rules);
		
		$fields['username']	= "Username";
		$fields['password']	= "Password";
		$fields['rememberme'] = "Remember";
		
		$this->validation->set_fields($fields);
		
		if ($this->validation->run())
		{
			$login = $this->redux_auth->login
			(
				$this->input->post('username'),
				$this->input->post('password')
			);
			
			switch ((string)$login)
			{
				case 'NOT_ACTIVATED':
					echo 'not activated';
					break;
				case 'BANNED':
					echo 'banned';
					break;
				case true:
					if ( $this->input->post('rememberme') == "checked" )
					{
						$cookie = array( 'name'  => 'flow', 'value'  => $this->input->post('username').','.$this->input->post('password'),'expire' => '86500' );
						set_cookie($cookie); 
					}
					redirect('admin');
					break;
				case false:
					echo 'error';
					break;
			}
		}
		else
		{
			$this->load->view('admin_view');
		}
	}
	
	function logout ()
	{
		$this->redux_auth->logout();
		delete_cookie('flow');
		redirect( 'admin' );
	}
	
	function forgotten()
	{
		$data['title'] = "Flow Cms | Forgotten Password";
		////////////////////////////////////////
		$this->load->view('forgotten_view', $data);
		////////////////////////////////////////
	}
	
	function forgotten_process()
	{
		
		$rules['email']	= "callback_check_email";
		
		$this->validation->set_rules($rules);
		
		$fields['email'] = "Email";
		
		
		switch ( $type )
		{
			case 'begin' :
				$result = $this->redux_auth->forgotten_begin( $data );
				break;
			
			case 'process' :
				$result = $this->redux_auth->forgotten_process( $data );
				break;
				
			case 'end' :
				$result = $this->redux_auth->forgotten_end( $data );
				break;
		}
		
		return $result;
	}
	
	function register()
	{
		$data['title'] = "Flow Cms | Register";
		$data['js'] = $this->_create_js();
		$data['css'] = $this->_create_css();
		$data['meta'] = $this->_create_meta();
		
		////////////////////////////////////////
		$this->load->view('register_view', $data);
		////////////////////////////////////////
	}
	
	function register_process()
	{
		$rules['username'] 	= "callback_check_username";
		$rules['password'] 	= "";
		$rules['password2'] 	= "";
		$rules['email']	= "callback_check_email";
		$rules['question'] 	= "";
		$rules['answer'] 	= "";
		
		$this->validation->set_rules($rules);
		
		$fields['username'] 	= "Username";
		$fields['password'] 	= "Password";
		$fields['password2'] 	= "Repeat Password";
		$fields['email'] 	= "Email";
		$fields['question']	= "Secret Question";
		$fields['answer']	= "Answer";
		
		$this->validation->set_fields($fields);
		
		if ($this->validation->run())
		{
			$registration = $this->redux_auth->register
			(
				$this->input->post('username'),
				$this->input->post('password'),
				$this->input->post('email'),
				$this->input->post('question'),
				$this->input->post('answer')
			);
			
			switch ((string)$registration)
			{
				case 'REGISTRATION_SUCCESS':
					redirect('admin');
					break;
				case 'REGISTRATION_SUCCESS_EMAIL':
					echo 'success mail';
					break;
				case false:
					echo 'error';
					break;
			}
		}
		else
		{
			$this->load->view('admin');
		}
	}
	
	function check_username ($username)
	{
		if ($this->redux_auth->check_username($username))
		{
			$this->validation->set_message('check_username', 'The username '.$username.' has been taken.');
			return false;
		}
		else
		{
			return true;
		}
	}
	
	function check_email ($email)
	{
		if ($this->redux_auth->check_email($email))
		{
			$this->validation->set_message('check_email', 'The email '.$email.' is already in use.');
			return false;
		}
		else
		{
			return true;
		}
	}

}

/* End of file welcome.php */
/* Location: ./system/application/controllers/welcome.php */