<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title><?php echo $title; ?></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
		<div id="registration">
		<h1>Registration</h1>
		<?php echo form_open('admin/register_process'); ?>

			<label for="username">Username : </label>
			<?php echo form_input('username'); ?>
			
			<label for="password">Password : </label>
			<?php echo form_password('password'); ?>
			
			<label for="password2">Repeat Password : </label>
			<?php echo form_password('password2'); ?>
			
			<label for="email">Email : </label>
			<?php echo form_input('email'); ?>
			
			<label for="question">Secret Question : </label>
			<?php echo form_input('question'); ?>
			
			<label for="answer">Answer : </label>
			<?php echo form_input('answer'); ?>
			
			<label for="submit"> </label>
			<?php echo form_submit('submit', 'Submit'); ?>

		<?php echo form_close(); ?>
		<?php echo anchor( 'admin', 'go back' ); ?>
	</div>
</body>
</html>