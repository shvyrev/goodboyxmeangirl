<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<?php echo $meta; ?>
<?php echo $css; ?>
<?php echo $js; ?>
<title><?php echo $title; ?></title>
</head>
<body>
	<div id="header">
		<div class="back_to_website">
			<?php echo anchor( '../../' ,'&laquo; Retour au site')?>
		</div>
	</div>
	
	
	<?php if ($login_state == 'false' ): ?>
		<div id="login">
			<?php echo $login; ?>
		</div>
	<?php else: ?>
		<div id="logout">
			<p>Hey !  <?php echo $username;  ?>| <?php echo anchor( 'admin/logout', 'D&eacute;connexion' ); ?></p>
		</div>
	<?php endif; ?>
	
	
	
	<?php if ($login_state == 'true' ): ?>
	<div id="content">
		<div id="menu">
			
		</div>
		<div id="module">
			
		</div>
	</div>
	
	
	<div id="footer">
		<p class="copy">FlowCms &copy;2008 Richard Rodney.</p>
	</div>
	<?php endif; ?>
</body>
</html>