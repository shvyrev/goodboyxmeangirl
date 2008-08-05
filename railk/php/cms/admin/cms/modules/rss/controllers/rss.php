<?php
class Rss extends Controller
{
	function Rss()
	{
		parent::Controller();
		$this->load->model('rss_model', '', TRUE);
		$this->load->helper('xml');
	}

	function index()
	{
		$data['encoding'] = 'utf-8';
		$data['feed_name'] = 'Geek.ma Quotes';
		$data['feed_url'] = 'http://irc.geek.ma';
		$data['page_description'] = 'Les 25 dernières quotes postées sur Geek.ma !';
		$data['page_language'] = 'fr-fr';
		$data['creator_email'] = 'Walid Iguer - lighty at lighty dot ma';
		$data['quotes'] = $this->rss_model->getRecentPosts();
		header("Content-Type: application/rss+xml");
		$this->load->view('rss/posts', $data);
	}
}
?>
