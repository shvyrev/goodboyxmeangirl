<?php
class Rss_model extends Model
{
	function Rss_model()
	{
		parent::Model();
	}
	function getRecentPosts()
	{
		$this->db->orderby('id', 'desc');
		$this->db->limit(25);
		return $this->db->get('posts');
	}
}
?>
