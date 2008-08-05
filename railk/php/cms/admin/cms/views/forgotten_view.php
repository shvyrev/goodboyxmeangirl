<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title><?php echo $title; ?></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
		<div id="forgotten">
		<h1>Forgotten Your Password</h1>
		<?php echo form_open('user/forgotten_begin'); ?>

			<label for="username">Email : </label><br />
			<?php echo form_input('email'); ?><br /><br />

			<label for="submit"> </label>
			<?php echo form_submit('submit', 'Submit'); ?>

		<?php echo form_close(); ?>
		<?php echo anchor( 'admin', 'go back' ); ?>
	</div>
</body>
</html>