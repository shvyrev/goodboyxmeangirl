<?php

class Main extends Controller {

	function Main()
	{
		parent::Controller();
	}
	
	function index()
	{
		$this->load->view('main_view');
	}
	
	function comment()
	{
		$this->load->view('comment_view');
	}
}