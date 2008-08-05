<?php
class Admin_model extends Model {

    function Admin_model()
    {
        parent::Model();
    }
	
	function getAdminPass( $data )
	{
		$this->db->select('password');
		$this->db->where('username', $data); 
		$query = $this->db->get('users',1);
		$row = $query->row();
		$result = array( 'user' => $data, 'pass' => $row->password);
		
		return $result;
	}
}
?>