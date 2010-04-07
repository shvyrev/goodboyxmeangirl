<?php
class SEO 
{
	private $xml;
	private $length;
	
	/**
	* CONSTRUCTEUR
	*/
	public function SEO($file) {
		$this->xml = simplexml_load_file($file);
		$this->length = count($this->xml->page);
	}
	
	/**
	* GET THE PAGE TITLE
	*/
	public function getTitle($page) {
		for ($i = 0; $i < $this->length; $i++)  if ($this->xml->page[$i]->attributes()->id == $page) return $this->xml->page[$i]->attributes()->title;
	}
	
	/**
	* CREATE THE NAVIGATION LINKS FOR SEO
	*/
	public function getNav() {
		$url = $this->getUrl();
		$result = "\n";
		for ($i = 0; $i < $this->length; $i++) {
			$id = ($this->xml->page[$i]->attributes()->id == 'index')?'':$this->xml->page[$i]->attributes()->id;
			$result .= '<li><a href="'.$url.(($this->rewrite())?(($id=='')?'':$id.'.html'):(($id=='')?'':'?page='.$id)).'" >'.$this->xml->page[$i]->attributes()->title."</a></li>\n";
		}	
		return $result;
	}
	
	/**
	* GET THE CONTENT OF THE CURRENT PAGE
	*/
	public function getContent($page) {
		$result = "\n";
		for ($i = 0; $i < $this->length; $i++) {
			$p = $this->xml->page[$i];
			if($p->attributes()->id == $page) foreach ($p->children() as $body) $result .= $this->getDiv($body);
		}	
		return $result;
	}
	
	/**
	* UTILITIES
	*/
	private function getDiv($xml) {
		$result = "";
		foreach ($xml->children() as $div) {
			if ($div->getName() != 'div') $result .= '<div id="'.$xml->attributes()->id.'">'.$div->asXml()."</div>\n";
			if(count($div->children())>0) $result .= $this->getDiv($div);
		}
		return $result;
	}
	
	private function rewrite() {
		ob_start();
		phpinfo(INFO_MODULES);
		$contents = ob_get_contents();
		ob_end_clean();
		return (strpos($contents, 'mod_rewrite') !== false)?true:false;
	}
	
	public function getUrl() {
		$url = 'http://'.$_SERVER['HTTP_HOST'];
		$dir = explode('/', $_SERVER['PHP_SELF']);
		for ( $i = 0; $i < (count($dir) - 1); ++$i ) $url .= $dir[$i].'/';
		return $url;
	}
}