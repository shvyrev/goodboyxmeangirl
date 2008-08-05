<?php
//  DEFINE DB TABLES
// --------------------------------------------------------------------
// --------------------------------------------------------------------

// Sites

$D[] = "exp_sites";

$Q[] = "CREATE TABLE `exp_sites` (
	  `site_id` int(5) unsigned NOT NULL auto_increment,
	  `site_label` varchar(100) NOT NULL default '',
	  `site_name` varchar(50) NOT NULL default '',
	  `site_description` text NOT NULL,
	  `site_system_preferences` TEXT NOT NULL ,
	  `site_mailinglist_preferences` TEXT NOT NULL ,
	  `site_member_preferences` TEXT NOT NULL ,
	  `site_template_preferences` TEXT NOT NULL ,
	  `site_weblog_preferences` TEXT NOT NULL ,
	  PRIMARY KEY  (`site_id`),
	  KEY `site_name` (`site_name`))";



// Session data

$D[] = 'exp_sessions';

$Q[] = "CREATE TABLE exp_sessions (
  session_id varchar(40) default '0' NOT NULL,
  site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
  member_id int(10) default '0' NOT NULL,
  admin_sess tinyint(1) default '0' NOT NULL,
  ip_address varchar(16) default '0' NOT NULL,
  user_agent varchar(50) NOT NULL,
  last_activity int(10) unsigned DEFAULT '0' NOT NULL,
  PRIMARY KEY (session_id),
  KEY (`member_id`),
  KEY (`site_id`)
)";

// Throttle

$D[] = 'exp_throttle';

$Q[] = "CREATE TABLE exp_throttle (
  ip_address varchar(16) default '0' NOT NULL,
  last_activity int(10) unsigned DEFAULT '0' NOT NULL,
  hits int(10) unsigned NOT NULL,
  locked_out char(1) NOT NULL default 'n',
  KEY (ip_address),
  KEY (last_activity)
)";


// System stats

$D[] = 'exp_stats';

$Q[] = "CREATE TABLE exp_stats (
  weblog_id int(6) unsigned NOT NULL default '0',
  site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
  total_members mediumint(7) NOT NULL default '0',
  recent_member_id int(10) default '0' NOT NULL,
  recent_member varchar(50) NOT NULL,
  total_entries mediumint(8) default '0' NOT NULL,
  total_forum_topics mediumint(8) default '0' NOT NULL,
  total_forum_posts mediumint(8) default '0' NOT NULL,
  total_comments mediumint(8) default '0' NOT NULL,
  total_trackbacks mediumint(8) default '0' NOT NULL,
  last_entry_date int(10) unsigned default '0' NOT NULL,
  last_forum_post_date int(10) unsigned default '0' NOT NULL,
  last_comment_date int(10) unsigned default '0' NOT NULL,
  last_trackback_date int(10) unsigned default '0' NOT NULL,
  last_visitor_date int(10) unsigned default '0' NOT NULL, 
  most_visitors mediumint(7) NOT NULL default '0',
  most_visitor_date int(10) unsigned default '0' NOT NULL,
  last_cache_clear int(10) unsigned default '0' NOT NULL,
  KEY (weblog_id),
  KEY (site_id)
)";


// Online users

$D[] = 'exp_online_users';

$Q[] = "CREATE TABLE exp_online_users (
 weblog_id int(6) unsigned NOT NULL default '0',
 site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
 member_id int(10) default '0' NOT NULL,
 in_forum char(1) NOT NULL default 'n',
 name varchar(50) default '0' NOT NULL,
 ip_address varchar(16) default '0' NOT NULL,
 date int(10) unsigned default '0' NOT NULL,
 anon char(1) NOT NULL,
 KEY (date),
 KEY (site_id)
)";


// Actions table
// Actions are events that require processing. Used by modules class.

$D[] = 'exp_actions';

$Q[] = "CREATE TABLE exp_actions (
 action_id int(4) unsigned NOT NULL auto_increment,
 class varchar(50) NOT NULL,
 method varchar(50) NOT NULL,
 PRIMARY KEY (action_id)
)";

// Modules table
// Contains a list of all installed modules

$D[] = 'exp_modules';

$Q[] = "CREATE TABLE exp_modules (
 module_id int(4) unsigned NOT NULL auto_increment,
 module_name varchar(50) NOT NULL,
 module_version varchar(12) NOT NULL,
 has_cp_backend char(1) NOT NULL default 'n',
 PRIMARY KEY (module_id)
)";

// Referrer tracking table

$D[] = 'exp_referrers';

$Q[] = "CREATE TABLE exp_referrers (
  ref_id int(10) unsigned NOT NULL auto_increment,
  site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
  ref_from varchar(120) NOT NULL,
  ref_to varchar(120) NOT NULL,
  ref_ip varchar(16) default '0' NOT NULL,
  ref_date int(10) unsigned default '0' NOT NULL,
  ref_agent varchar(100) NOT NULL,
  user_blog varchar(40) NOT NULL,
  PRIMARY KEY (ref_id),
  KEY (site_id)
)";

// Security Hashes
// Used to store hashes needed to process forms in 'secure mode'

$D[] = 'exp_security_hashes';

$Q[] = "CREATE TABLE exp_security_hashes (
 date int(10) unsigned NOT NULL,
 ip_address varchar(16) default '0' NOT NULL,
 hash varchar(40) NOT NULL,
 KEY (hash)
)";

// Captcha data

$D[] = 'exp_captcha';

$Q[] = "CREATE TABLE exp_captcha (
 captcha_id bigint(13) unsigned NOT NULL auto_increment,
 date int(10) unsigned NOT NULL,
 ip_address varchar(16) default '0' NOT NULL,
 word varchar(20) NOT NULL,
 PRIMARY KEY (captcha_id),
 KEY (word)
)";

// Password Lockout
// If password lockout is enabled, a user only gets
// four attempts to log-in within a specified period.
// This table holds the a list of locked out users

$D[] = 'exp_password_lockout';

$Q[] = "CREATE TABLE exp_password_lockout (
 login_date int(10) unsigned NOT NULL,
 ip_address varchar(16) default '0' NOT NULL,
 user_agent varchar(50) NOT NULL,
 KEY (login_date),
 KEY (ip_address),
 KEY (user_agent)
)";

// Reset password
// If a user looses their password, this table
// holds the reset code.

$D[] = 'exp_reset_password';

$Q[] = "CREATE TABLE exp_reset_password (
  member_id int(10) unsigned NOT NULL,
  resetcode varchar(12) NOT NULL,
  date int(10) NOT NULL
)";


$D[] = 'exp_mailing_lists';

$Q[] = "CREATE TABLE exp_mailing_lists (
 list_id int(7) unsigned NOT NULL auto_increment,
 list_name varchar(40) NOT NULL,
 list_title varchar(100) NOT NULL,
 list_template text NOT NULL,
 PRIMARY KEY (list_id),
 KEY (list_name)
)";


// Mailing list
// Notes: "authcode" is a random hash assigned to each member
// of the mailing list.  We use this code in the "usubscribe" link
// added to sent emails.

$D[] = 'exp_mailing_list';

$Q[] = "CREATE TABLE exp_mailing_list (
 user_id int(10) unsigned NOT NULL auto_increment,
 list_id int(7) unsigned default '0' NOT NULL,
 ip_address varchar(16) NOT NULL,
 authcode varchar(10) NOT NULL,
 email varchar(50) NOT NULL,
 KEY (list_id),
 KEY (user_id)
)";

// Mailing List Queue
// When someone signs up for the mailing list, they are sent
// a confirmation email.  This prevents someone from signing 
// up another person.  This table holds email addresses that
// are pending activation.

$D[] = 'exp_mailing_list_queue';

$Q[] = "CREATE TABLE exp_mailing_list_queue (
  email varchar(50) NOT NULL,
  list_id int(7) unsigned default '0' NOT NULL,
  authcode varchar(10) NOT NULL,
  date int(10) NOT NULL
)";

// Email Cache
// We store all email messages that are sent from the CP

$D[] = 'exp_email_cache';

$Q[] = "CREATE TABLE exp_email_cache (
  cache_id int(6) unsigned NOT NULL auto_increment,
  cache_date int(10) unsigned default '0' NOT NULL,
  total_sent int(6) unsigned NOT NULL,
  from_name varchar(70) NOT NULL,
  from_email varchar(70) NOT NULL,
  recipient text NOT NULL,
  cc text NOT NULL,
  bcc text NOT NULL,
  recipient_array mediumtext NOT NULL,
  subject varchar(120) NOT NULL,
  message mediumtext NOT NULL,
  `plaintext_alt` MEDIUMTEXT NOT NULL,
  mailinglist char(1) NOT NULL default 'n',
  mailtype varchar(6) NOT NULL,
  text_fmt varchar(40) NOT NULL,
  wordwrap char(1) NOT NULL default 'y',
  priority char(1) NOT NULL default '3',
  PRIMARY KEY (cache_id)
)";

// Cached Member Groups
// We use this table to store the member group assignments
// for each email that is sent.  Since you can send email
// to various combinations of members, we store the member
// group numbers in this table, which is joined to the 
// table above when we need to re-send an email from cache.

$D[] = 'exp_email_cache_mg';

$Q[] = "CREATE TABLE exp_email_cache_mg (
  cache_id int(6) unsigned NOT NULL,
  group_id smallint(4) NOT NULL,
  KEY (cache_id)
)";

// We do the same with mailing lists

$D[] = 'exp_email_cache_ml';

$Q[] = "CREATE TABLE exp_email_cache_ml (
  cache_id int(6) unsigned NOT NULL,
  list_id smallint(4) NOT NULL,
  KEY (cache_id)
)";


// Email Console Cache
// Emails sent from the member profile email console are saved here.

$D[] = 'exp_email_console_cache';

$Q[] = "CREATE TABLE exp_email_console_cache (
  cache_id int(6) unsigned NOT NULL auto_increment,
  cache_date int(10) unsigned default '0' NOT NULL,
  member_id int(10) unsigned NOT NULL,
  member_name varchar(50) NOT NULL,
  ip_address varchar(16) default '0' NOT NULL,
  recipient varchar(70) NOT NULL,
  recipient_name varchar(50) NOT NULL,
  subject varchar(120) NOT NULL,
  message mediumtext NOT NULL,
  PRIMARY KEY (cache_id)
)";

// Email Tracker
// This table is used by the Email module for flood control.

$D[] = 'exp_email_tracker';

$Q[] = "CREATE TABLE exp_email_tracker (
email_id int(10) unsigned NOT NULL auto_increment,
email_date int(10) unsigned default '0' NOT NULL,
sender_ip varchar(16) NOT NULL,
sender_email varchar(75) NOT NULL ,
sender_username varchar(50) NOT NULL ,
number_recipients int(4) unsigned default '1' NOT NULL,
PRIMARY  KEY (email_id) 
)";

// Member table
// Contains the member info

/*
Note: The following fields are intended for use
with the "user_blog" module.

  weblog_id int(6) unsigned NOT NULL default '0',
  template_id int(6) unsigned NOT NULL default '0',
  upload_id int(6) unsigned NOT NULL default '0',
*/


$D[] = 'exp_members';
 
$Q[] = "CREATE TABLE exp_members (
  member_id int(10) unsigned NOT NULL auto_increment,
  group_id smallint(4) NOT NULL default '0',
  weblog_id int(6) unsigned NOT NULL default '0',
  tmpl_group_id int(6) unsigned NOT NULL default '0',
  upload_id int(6) unsigned NOT NULL default '0',
  username varchar(50) NOT NULL,
  screen_name varchar(50) NOT NULL,
  password varchar(40) NOT NULL,
  unique_id varchar(40) NOT NULL,
  authcode varchar(10) NOT NULL,
  email varchar(50) NOT NULL,
  url varchar(75) NOT NULL,
  location varchar(50) NOT NULL,
  occupation varchar(80) NOT NULL,
  interests varchar(120) NOT NULL,
  bday_d int(2) NOT NULL,
  bday_m int(2) NOT NULL,
  bday_y int(4) NOT NULL,
  aol_im varchar(50) NOT NULL,
  yahoo_im varchar(50) NOT NULL,
  msn_im varchar(50) NOT NULL,
  icq varchar(50) NOT NULL,
  bio text NOT NULL,
  signature text NOT NULL,
  avatar_filename varchar(120) NOT NULL,
  avatar_width int(4) unsigned NOT NULL,
  avatar_height int(4) unsigned NOT NULL,  
  photo_filename varchar(120) NOT NULL,
  photo_width int(4) unsigned NOT NULL,
  photo_height int(4) unsigned NOT NULL,  
  sig_img_filename varchar(120) NOT NULL,
  sig_img_width int(4) unsigned NOT NULL,
  sig_img_height int(4) unsigned NOT NULL,
  ignore_list text NOT NULL,
  private_messages int(4) unsigned DEFAULT '0' NOT NULL,
  accept_messages char(1) NOT NULL default 'y',
  last_view_bulletins int(10) NOT NULL default 0,
  last_bulletin_date int(10) NOT NULL default 0,
  ip_address varchar(16) default '0' NOT NULL,
  join_date int(10) unsigned default '0' NOT NULL,
  last_visit int(10) unsigned default '0' NOT NULL, 
  last_activity int(10) unsigned default '0' NOT NULL, 
  total_entries smallint(5) unsigned NOT NULL default '0',
  total_comments smallint(5) unsigned NOT NULL default '0',
  total_forum_topics mediumint(8) default '0' NOT NULL,
  total_forum_posts mediumint(8) default '0' NOT NULL,
  last_entry_date int(10) unsigned default '0' NOT NULL,
  last_comment_date int(10) unsigned default '0' NOT NULL,
  last_forum_post_date int(10) unsigned default '0' NOT NULL,
  last_email_date int(10) unsigned default '0' NOT NULL,
  in_authorlist char(1) NOT NULL default 'n',
  accept_admin_email char(1) NOT NULL default 'y',
  accept_user_email char(1) NOT NULL default 'y',
  notify_by_default char(1) NOT NULL default 'y',
  notify_of_pm char(1) NOT NULL default 'y',
  display_avatars char(1) NOT NULL default 'y',
  display_signatures char(1) NOT NULL default 'y',
  smart_notifications char(1) NOT NULL default 'y',
  language varchar(50) NOT NULL,
  timezone varchar(8) NOT NULL,
  daylight_savings char(1) default 'n' NOT NULL,
  localization_is_site_default char(1) NOT NULL default 'n',
  time_format char(2) default 'us' NOT NULL,
  cp_theme varchar(32) NOT NULL,
  profile_theme varchar(32) NOT NULL,
  forum_theme varchar(32) NOT NULL,
  tracker text NOT NULL,
  template_size varchar(2) NOT NULL default '28',
  notepad text NOT NULL,
  notepad_size varchar(2) NOT NULL default '18',
  quick_links text NOT NULL,
  quick_tabs text NOT NULL,
  pmember_id int(10) NOT NULL default '0',
  PRIMARY KEY (member_id),
  KEY (`group_id`),
  KEY (`unique_id`),
  KEY (`password`)
)";

// CP homepage layout
// Each member can have their own control panel layout.
// We store their preferences here.

$D[] = 'exp_member_homepage';

$Q[] = "CREATE TABLE exp_member_homepage (
 member_id int(10) unsigned NOT NULL,
 recent_entries char(1) NOT NULL default 'l',
 recent_entries_order int(3) unsigned NOT NULL default '0',
 recent_comments char(1) NOT NULL default 'l',
 recent_comments_order int(3) unsigned NOT NULL default '0',
 recent_members char(1) NOT NULL default 'n',
 recent_members_order int(3) unsigned NOT NULL default '0',
 site_statistics char(1) NOT NULL default 'r',
 site_statistics_order int(3) unsigned NOT NULL default '0',
 member_search_form char(1) NOT NULL default 'n',
 member_search_form_order int(3) unsigned NOT NULL default '0',
 notepad char(1) NOT NULL default 'r',
 notepad_order int(3) unsigned NOT NULL default '0',
 bulletin_board char(1) NOT NULL default 'r',
 bulletin_board_order int(3) unsigned NOT NULL default '0',
 pmachine_news_feed char(1) NOT NULL default 'n',
 pmachine_news_feed_order int(3) unsigned NOT NULL default '0',
 KEY (member_id)
)";				


// Member Groups table

$D[] = 'exp_member_groups';

$Q[] = "CREATE TABLE exp_member_groups (
  group_id smallint(4) unsigned NOT NULL,
  site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
  group_title varchar(100) NOT NULL,
  group_description text NOT NULL,
  is_locked char(1) NOT NULL default 'y', 
  can_view_offline_system char(1) NOT NULL default 'n', 
  can_view_online_system char(1) NOT NULL default 'y', 
  can_access_cp char(1) NOT NULL default 'y', 
  can_access_publish char(1) NOT NULL default 'n',
  can_access_edit char(1) NOT NULL default 'n',
  can_access_design char(1) NOT NULL default 'n',
  can_access_comm char(1) NOT NULL default 'n',
  can_access_modules char(1) NOT NULL default 'n',
  can_access_admin char(1) NOT NULL default 'n',
  can_admin_weblogs char(1) NOT NULL default 'n',
  can_admin_members char(1) NOT NULL default 'n',
  can_delete_members char(1) NOT NULL default 'n',
  can_admin_mbr_groups char(1) NOT NULL default 'n',
  can_admin_mbr_templates char(1) NOT NULL default 'n',
  can_ban_users char(1) NOT NULL default 'n',
  can_admin_utilities char(1) NOT NULL default 'n',
  can_admin_preferences char(1) NOT NULL default 'n',
  can_admin_modules char(1) NOT NULL default 'n',
  can_admin_templates char(1) NOT NULL default 'n',
  can_edit_categories char(1) NOT NULL default 'n',
  can_delete_categories char(1) NOT NULL default 'n',
  can_view_other_entries char(1) NOT NULL default 'n',
  can_edit_other_entries char(1) NOT NULL default 'n',
  can_assign_post_authors char(1) NOT NULL default 'n',
  can_delete_self_entries char(1) NOT NULL default 'n',
  can_delete_all_entries char(1) NOT NULL default 'n',
  can_view_other_comments char(1) NOT NULL default 'n',
  can_edit_own_comments char(1) NOT NULL default 'n',
  can_delete_own_comments char(1) NOT NULL default 'n',
  can_edit_all_comments char(1) NOT NULL default 'n',
  can_delete_all_comments char(1) NOT NULL default 'n',
  can_moderate_comments char(1) NOT NULL default 'n',
  can_send_email char(1) NOT NULL default 'n',
  can_send_cached_email char(1) NOT NULL default 'n',
  can_email_member_groups char(1) NOT NULL default 'n',
  can_email_mailinglist char(1) NOT NULL default 'n',
  can_email_from_profile char(1) NOT NULL default 'n',
  can_view_profiles char(1) NOT NULL default 'n',
  can_delete_self char(1) NOT NULL default 'n',
  mbr_delete_notify_emails varchar(255) NOT NULL,
  can_post_comments char(1) NOT NULL default 'n', 
  exclude_from_moderation char(1) NOT NULL default 'n',
  can_search char(1) NOT NULL default 'n',
  search_flood_control mediumint(5) unsigned NOT NULL,
  can_send_private_messages char(1) NOT NULL default 'n',
  prv_msg_send_limit smallint unsigned NOT NULL default '20',
  prv_msg_storage_limit smallint unsigned NOT NULL default '60',
  can_attach_in_private_messages char(1) NOT NULL default 'n', 
  can_send_bulletins char(1) NOT NULL default 'n',
  include_in_authorlist char(1) NOT NULL default 'n',
  include_in_memberlist char(1) NOT NULL default 'y',
  include_in_mailinglists char(1) NOT NULL default 'y',
  KEY (group_id),
  KEY (site_id)
)";




// Weblog access privs
// Member groups assignment for each weblog

$D[] = 'exp_weblog_member_groups';

$Q[] = "CREATE TABLE exp_weblog_member_groups (
  group_id smallint(4) unsigned NOT NULL,
  weblog_id int(6) unsigned NOT NULL,
  KEY (group_id)
)";

// Module access privs
// Member Group assignment for each module

$D[] = 'exp_module_member_groups';

$Q[] = "CREATE TABLE exp_module_member_groups (
  group_id smallint(4) unsigned NOT NULL,
  module_id mediumint(5) unsigned NOT NULL,
  KEY (group_id)
)";


// Template Group access privs
// Member group assignment for each template group

$D[] = 'exp_template_member_groups';

$Q[] = "CREATE TABLE exp_template_member_groups (
  group_id smallint(4) unsigned NOT NULL,
  template_group_id mediumint(5) unsigned NOT NULL,
  KEY (group_id)
)";


// Member Custom Fields
// Stores the defenition of each field

$D[] = 'exp_member_fields';

$Q[] = "CREATE TABLE exp_member_fields (
 m_field_id int(4) unsigned NOT NULL auto_increment,
 m_field_name varchar(32) NOT NULL,
 m_field_label varchar(50) NOT NULL,
 m_field_description text NOT NULL, 
 m_field_type varchar(12) NOT NULL default 'text',
 m_field_list_items text NOT NULL,
 m_field_ta_rows tinyint(2) default '8',
 m_field_maxl smallint(3) NOT NULL,
 m_field_width varchar(6) NOT NULL,
 m_field_search char(1) NOT NULL default 'y',
 m_field_required char(1) NOT NULL default 'n',
 m_field_public char(1) NOT NULL default 'y',
 m_field_reg char(1) NOT NULL default 'n',
 m_field_fmt char(5) NOT NULL default 'none',
 m_field_order int(3) unsigned NOT NULL,
 PRIMARY KEY (m_field_id)
)";

// Member Data
// Stores the actual data

$D[] = 'exp_member_data';

$Q[] = "CREATE TABLE exp_member_data (
 member_id int(10) unsigned NOT NULL,
 KEY (member_id)
)";

// Weblog Table

$D[] = 'exp_weblogs';

// Note: The is_user_blog field indicates whether the blog is
// assigned as a "user blogs" weblog

$Q[] = "CREATE TABLE exp_weblogs (
 weblog_id int(6) unsigned NOT NULL auto_increment,
 site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
 is_user_blog char(1) NOT NULL default 'n',
 blog_name varchar(40) NOT NULL,
 blog_title varchar(100) NOT NULL,
 blog_url varchar(100) NOT NULL,
 blog_description varchar(225) NOT NULL,
 blog_lang varchar(12) NOT NULL,
 blog_encoding varchar(12) NOT NULL,
 total_entries mediumint(8) default '0' NOT NULL,
 total_comments mediumint(8) default '0' NOT NULL,
 total_trackbacks mediumint(8) default '0' NOT NULL,
 last_entry_date int(10) unsigned default '0' NOT NULL,
 last_comment_date int(10) unsigned default '0' NOT NULL,
 last_trackback_date int(10) unsigned default '0' NOT NULL,
 cat_group varchar(255) NOT NULL, 
 status_group int(4) unsigned NOT NULL,
 deft_status varchar(50) NOT NULL default 'open',
 field_group int(4) unsigned NOT NULL,
 search_excerpt int(4) unsigned NOT NULL,
 enable_trackbacks char(1) NOT NULL default 'n',
 trackback_use_url_title char(1) NOT NULL default 'n',
 trackback_max_hits int(2) unsigned NOT NULL default '5', 
 trackback_field int(4) unsigned NOT NULL,
 deft_category varchar(60) NOT NULL,
 deft_comments char(1) NOT NULL default 'y',
 deft_trackbacks char(1) NOT NULL default 'y',
 weblog_require_membership char(1) NOT NULL default 'y',
 weblog_max_chars int(5) unsigned NOT NULL,
 weblog_html_formatting char(4) NOT NULL default 'all',
 weblog_allow_img_urls char(1) NOT NULL default 'y',
 weblog_auto_link_urls char(1) NOT NULL default 'y', 
 weblog_notify char(1) NOT NULL default 'n',
 weblog_notify_emails varchar(255) NOT NULL,
 comment_url varchar(80) NOT NULL,
 comment_system_enabled char(1) NOT NULL default 'y',
 comment_require_membership char(1) NOT NULL default 'n',
 comment_use_captcha char(1) NOT NULL default 'n',
 comment_moderate char(1) NOT NULL default 'n',
 comment_max_chars int(5) unsigned NOT NULL,
 comment_timelock int(5) unsigned NOT NULL default '0',
 comment_require_email char(1) NOT NULL default 'y',
 comment_text_formatting char(5) NOT NULL default 'xhtml',
 comment_html_formatting char(4) NOT NULL default 'safe',
 comment_allow_img_urls char(1) NOT NULL default 'n',
 comment_auto_link_urls char(1) NOT NULL default 'y',
 comment_notify char(1) NOT NULL default 'n',
 comment_notify_authors char(1) NOT NULL default 'n',
 comment_notify_emails varchar(255) NOT NULL,
 comment_expiration int(4) unsigned NOT NULL default '0',
 search_results_url varchar(80) NOT NULL,
 tb_return_url varchar(80) NOT NULL,
 ping_return_url varchar(80) NOT NULL, 
 show_url_title char(1) NOT NULL default 'y',
 trackback_system_enabled char(1) NOT NULL default 'n',
 show_trackback_field char(1) NOT NULL default 'y',
 trackback_use_captcha char(1) NOT NULL default 'n',
 show_ping_cluster char(1) NOT NULL default 'y',
 show_options_cluster char(1) NOT NULL default 'y',
 show_button_cluster char(1) NOT NULL default 'y',
 show_forum_cluster char(1) NOT NULL default 'y',
 show_pages_cluster CHAR(1) NOT NULL DEFAULT 'y',
 show_show_all_cluster CHAR(1) NOT NULL DEFAULT 'y',
 show_author_menu char(1) NOT NULL default 'y',
 show_status_menu char(1) NOT NULL default 'y',
 show_categories_menu char(1) NOT NULL default 'y',
 show_date_menu char(1) NOT NULL default 'y', 
 rss_url varchar(80) NOT NULL,
 enable_versioning char(1) NOT NULL default 'n',
 enable_qucksave_versioning char(1) NOT NULL default 'n',
 max_revisions smallint(4) unsigned NOT NULL default 10,
 default_entry_title varchar(100) NOT NULL,
 url_title_prefix varchar(80) NOT NULL,
 live_look_template int(10) UNSIGNED NOT NULL default 0,
 PRIMARY KEY (weblog_id),
 KEY (cat_group),
 KEY (status_group),
 KEY (field_group),
 KEY (is_user_blog),
 KEY (site_id)
)";

// Weblog Titles
// We store weblog titles separately from weblog data

$D[] = 'exp_weblog_titles';

$Q[] = "CREATE TABLE exp_weblog_titles (
 entry_id int(10) unsigned NOT NULL auto_increment,
 site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
 weblog_id int(4) unsigned NOT NULL,
 author_id int(10) unsigned NOT NULL default '0',
 pentry_id int(10) NOT NULL default '0',
 forum_topic_id int(10) unsigned NOT NULL,
 ip_address varchar(16) NOT NULL,
 title varchar(100) NOT NULL,
 url_title varchar(75) NOT NULL,
 status varchar(50) NOT NULL,
 versioning_enabled char(1) NOT NULL default 'n',
 view_count_one int(10) unsigned NOT NULL default '0',
 view_count_two int(10) unsigned NOT NULL default '0',
 view_count_three int(10) unsigned NOT NULL default '0',
 view_count_four int(10) unsigned NOT NULL default '0',
 allow_comments varchar(1) NOT NULL default 'y',
 allow_trackbacks varchar(1) NOT NULL default 'n',
 sticky varchar(1) NOT NULL default 'n',
 entry_date int(10) NOT NULL,
 dst_enabled varchar(1) NOT NULL default 'n',
 year char(4) NOT NULL,
 month char(2) NOT NULL,
 day char(3) NOT NULL,
 expiration_date int(10) NOT NULL default '0',
 comment_expiration_date int(10) NOT NULL default '0',
 edit_date bigint(14),
 recent_comment_date int(10) NOT NULL,
 comment_total int(4) unsigned NOT NULL default '0',
 trackback_total int(4) unsigned NOT NULL default '0',
 sent_trackbacks text NOT NULL,
 recent_trackback_date int(10) NOT NULL,
 PRIMARY KEY (entry_id),
 KEY (weblog_id),
 KEY (author_id),
 KEY (url_title),
 KEY (status),
 KEY (entry_date),
 KEY (expiration_date),
 KEY (site_id)
)";


$D[] = 'exp_entry_versioning';

$Q[] = "CREATE TABLE exp_entry_versioning (
 version_id int(10) unsigned NOT NULL auto_increment,  
 entry_id int(10) unsigned NOT NULL,
 weblog_id int(4) unsigned NOT NULL,
 author_id int(10) unsigned NOT NULL,
 version_date int(10) NOT NULL,
 version_data mediumtext NOT NULL,
 PRIMARY KEY (version_id),
 KEY (entry_id)
)";


// Weblog Custom Field Groups

$D[] = 'exp_field_groups';

$Q[] = "CREATE TABLE exp_field_groups (
 group_id int(4) unsigned NOT NULL auto_increment,
 site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
 group_name varchar(50) NOT NULL,
 PRIMARY KEY (group_id),
 KEY (site_id)
)"; 

// Weblog Custom Field Definitions

$D[] = 'exp_weblog_fields';

$Q[] = "CREATE TABLE exp_weblog_fields (
 field_id int(6) unsigned NOT NULL auto_increment,
 site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
 group_id int(4) unsigned NOT NULL, 
 field_name varchar(32) NOT NULL,
 field_label varchar(50) NOT NULL,
 field_instructions TEXT NOT NULL,
 field_type varchar(12) NOT NULL default 'text',
 field_list_items text NOT NULL,
 field_pre_populate char(1) NOT NULL default 'n', 
 field_pre_blog_id int(6) unsigned NOT NULL,
 field_pre_field_id int(6) unsigned NOT NULL,
 field_related_to varchar(12) NOT NULL default 'blog',
 field_related_id int(6) unsigned NOT NULL,
 field_related_orderby varchar(12) NOT NULL default 'date',
 field_related_sort varchar(4) NOT NULL default 'desc',
 field_related_max smallint(4) NOT NULL,
 field_ta_rows tinyint(2) default '8',
 field_maxl smallint(3) NOT NULL,
 field_required char(1) NOT NULL default 'n',
 field_text_direction CHAR(3) NOT NULL default 'ltr',
 field_search char(1) NOT NULL default 'n',
 field_is_hidden char(1) NOT NULL default 'n',
 field_fmt varchar(40) NOT NULL default 'xhtml',
 field_show_fmt char(1) NOT NULL default 'y',
 field_order int(3) unsigned NOT NULL,
 PRIMARY KEY (field_id),
 KEY (group_id),
 KEY (site_id)
)";


// Relationships table

$D[] = 'exp_relationships';

$Q[] = "CREATE TABLE exp_relationships (
 rel_id int(6) unsigned NOT NULL auto_increment,
 rel_parent_id int(10) NOT NULL default '0',
 rel_child_id int(10) NOT NULL default '0',
 rel_type varchar(12) NOT NULL,
 rel_data mediumtext NOT NULL,
 reverse_rel_data mediumtext NOT NULL,
 PRIMARY KEY (rel_id),
 KEY (rel_parent_id),
 KEY (rel_child_id)
)";


// Field formatting definitions

$D[] = 'exp_field_formatting';

$Q[] = "CREATE TABLE exp_field_formatting (
 field_id int(10) unsigned NOT NULL,
 field_fmt varchar(40) NOT NULL,
 KEY (field_id)
)";


// Weblog data

$D[] = 'exp_weblog_data';

$Q[] = "CREATE TABLE exp_weblog_data (
 entry_id int(10) unsigned NOT NULL,
 site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
 weblog_id int(4) unsigned NOT NULL,
 field_id_1 text NOT NULL,
 field_ft_1 varchar(40) NOT NULL default 'xhtml',
 field_id_2 text NOT NULL,
 field_ft_2 varchar(40) NOT NULL default 'xhtml',
 field_id_3 text NOT NULL,
 field_ft_3 varchar(40) NOT NULL default 'xhtml',
 KEY (entry_id),
 KEY (weblog_id),
 KEY (site_id)
)";


// Ping Status
// This table saves the status of the xml-rpc ping buttons
// that were selected when an entry was submitted.  This
// enables us to set the buttons to the same state when editing

$D[] = 'exp_entry_ping_status';

$Q[] = "CREATE TABLE exp_entry_ping_status (
 entry_id int(10) unsigned NOT NULL,
 ping_id int(10) unsigned NOT NULL
)";

// Comment table

$D[] = 'exp_comments';

$Q[] = "CREATE TABLE exp_comments (
 comment_id int(10) unsigned NOT NULL auto_increment,
 site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
 entry_id int(10) unsigned NOT NULL default '0',
 weblog_id int(4) unsigned NOT NULL,
 author_id int(10) unsigned NOT NULL default '0',
 status char(1) NOT NULL default 'o',
 name varchar(50) NOT NULL,
 email varchar(50) NOT NULL,
 url varchar(75) NOT NULL,
 location varchar(50) NOT NULL, 
 ip_address varchar(16) NOT NULL,
 comment_date int(10) NOT NULL,
 edit_date timestamp(14),
 comment text NOT NULL,
 notify char(1) NOT NULL default 'n',
 PRIMARY KEY (comment_id),
 KEY (entry_id),
 KEY (weblog_id),
 KEY (author_id),
 KEY (status),
 KEY (site_id)
)";

// Trackback table.

$D[] = 'exp_trackbacks';

$Q[] = "CREATE TABLE exp_trackbacks (
 trackback_id int(10) unsigned NOT NULL auto_increment,
 site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
 entry_id int(10) unsigned NOT NULL default '0',
 weblog_id int(4) unsigned NOT NULL,
 title varchar(100) NOT NULL,
 content text NOT NULL,
 weblog_name varchar(100) NOT NULL,
 trackback_url varchar(200) NOT NULL,
 trackback_date int(10) NOT NULL,
 trackback_ip varchar(16) NOT NULL,
 PRIMARY KEY (trackback_id),
 KEY (entry_id),
 KEY (weblog_id),
 KEY (site_id)
)";


// Status Groups

$D[] = 'exp_status_groups';

$Q[] = "CREATE TABLE exp_status_groups (
 group_id int(4) unsigned NOT NULL auto_increment,
 site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
 group_name varchar(50) NOT NULL,
 PRIMARY KEY (group_id),
 KEY (site_id)
)"; 

// Status data

$D[] = 'exp_statuses';

$Q[] = "CREATE TABLE exp_statuses (
 status_id int(6) unsigned NOT NULL auto_increment,
 site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
 group_id int(4) unsigned NOT NULL,
 status varchar(50) NOT NULL,
 status_order int(3) unsigned NOT NULL,
 highlight varchar(30) NOT NULL,
 PRIMARY KEY (status_id),
 KEY (group_id),
 KEY (site_id)
)"; 

// Status "no access" 
// Stores groups that can not access certain statuses

$D[] = 'exp_status_no_access';

$Q[] = "CREATE TABLE exp_status_no_access (
 status_id int(6) unsigned NOT NULL,
 member_group smallint(4) unsigned NOT NULL
)";



// Category Groups
// Note: The is_user_blog field indicates whether the blog is
// assigned as a "user blogs" weblog

$D[] = 'exp_category_groups';

$Q[] = "CREATE TABLE exp_category_groups (
 group_id int(6) unsigned NOT NULL auto_increment,
 site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
 group_name varchar(50) NOT NULL,
 sort_order char(1) NOT NULL default 'a',
 `field_html_formatting` char(4) NOT NULL default 'all',
 `can_edit_categories` TEXT NOT NULL,
 `can_delete_categories` TEXT NOT NULL,
 is_user_blog char(1) NOT NULL default 'n',
 PRIMARY KEY (group_id),
 KEY (site_id)
)"; 

// Category data

$D[] = 'exp_categories';

$Q[] = "CREATE TABLE exp_categories (
 cat_id int(10) unsigned NOT NULL auto_increment,
 site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
 group_id int(6) unsigned NOT NULL,
 parent_id int(4) unsigned NOT NULL,
 cat_name varchar(100) NOT NULL,
 `cat_url_title` varchar(75) NOT NULL,
 cat_description text NOT NULL,
 cat_image varchar(120) NOT NULL,
 cat_order int(4) unsigned NOT NULL,
 PRIMARY KEY (cat_id),
 KEY (group_id),
 KEY (cat_name),
 KEY (site_id)
)"; 


$D[] = 'exp_category_fields';

$Q[] = "CREATE TABLE `exp_category_fields` (
		`field_id` int(6) unsigned NOT NULL auto_increment,
		`site_id` int(4) unsigned NOT NULL default 1,
		`group_id` int(4) unsigned NOT NULL,
		`field_name` varchar(32) NOT NULL default '',
		`field_label` varchar(50) NOT NULL default '',
		`field_type` varchar(12) NOT NULL default 'text',
		`field_list_items` text NOT NULL,
		`field_maxl` smallint(3) NOT NULL default 128,
		`field_ta_rows` tinyint(2) NOT NULL default 8,
		`field_default_fmt` varchar(40) NOT NULL default 'none',
		`field_show_fmt` char(1) NOT NULL default 'y',
		`field_text_direction` CHAR(3) NOT NULL default 'ltr',
		`field_required` char(1) NOT NULL default 'n',
		`field_order` int(3) unsigned NOT NULL,
		PRIMARY KEY (`field_id`),
		KEY `site_id` (`site_id`),
		KEY `group_id` (`group_id`)
		)";
		
$D[] = 'exp_category_field_data';
		
$Q[] = "CREATE TABLE `exp_category_field_data` (
		`cat_id` int(4) unsigned NOT NULL,
		`site_id` int(4) unsigned NOT NULL default 1,
		`group_id` int(4) unsigned NOT NULL,
		PRIMARY KEY (`cat_id`),
		KEY `site_id` (`site_id`),
		KEY `group_id` (`group_id`)				
		)";


// Category posts
// This table stores the weblog entry ID and the category IDs
// that are assigned to it

$D[] = 'exp_category_posts';

$Q[] = "CREATE TABLE exp_category_posts (
 entry_id int(10) unsigned NOT NULL,
 cat_id int(10) unsigned NOT NULL,
 KEY (entry_id),
 KEY (cat_id)
)"; 

// Control panel log

$D[] = 'exp_cp_log';

$Q[] = "CREATE TABLE exp_cp_log (
  id int(10) NOT NULL auto_increment,
  site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
  member_id int(10) unsigned NOT NULL,
  username varchar(32) NOT NULL,
  ip_address varchar(16) default '0' NOT NULL,
  act_date int(10) NOT NULL,
  action varchar(200) NOT NULL,
  PRIMARY KEY  (id),
  KEY (site_id)
)"; 

// HTML buttons
// These are the buttons that appear on the PUBLISH page.
// Each member can have their own set of buttons

$D[] = 'exp_html_buttons';

$Q[] = "CREATE TABLE exp_html_buttons (
  id int(10) unsigned NOT NULL auto_increment,
  site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
  member_id int(10) default '0' NOT NULL,
  tag_name varchar(32) NOT NULL,
  tag_open varchar(120) NOT NULL,
  tag_close varchar(120) NOT NULL,
  accesskey varchar(32) NOT NULL,
  tag_order int(3) unsigned NOT NULL,
  tag_row char(1) NOT NULL default '1',
  PRIMARY KEY (id),
  KEY (site_id)
)";


// Ping Servers
// Each member can have their own set ping server definitions

$D[] = 'exp_ping_servers';

$Q[] = "CREATE TABLE exp_ping_servers (
  id int(10) unsigned NOT NULL auto_increment,
  site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
  member_id int(10) default '0' NOT NULL,
  server_name varchar(32) NOT NULL,
  server_url varchar(150) NOT NULL,
  port varchar(4) NOT NULL default '80',
  ping_protocol varchar(12) NOT NULL default 'xmlrpc',
  is_default char(1) NOT NULL default 'y',
  server_order int(3) unsigned NOT NULL,
  PRIMARY KEY (id),
  KEY (site_id)
)";


// Template Groups
// Note:  The 'is_user_blog' field is used to indicate
// whether a template group has been assigned to a
// specific user as part of the "user blogs" module

$D[] = 'exp_template_groups';

$Q[] = "CREATE TABLE exp_template_groups (
 group_id int(6) unsigned NOT NULL auto_increment,
 site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
 group_name varchar(50) NOT NULL,
 group_order int(3) unsigned NOT NULL,
 is_site_default char(1) NOT NULL default 'n',
 is_user_blog char(1) NOT NULL default 'n',
 PRIMARY KEY (group_id),
 KEY (site_id)
)";

// Template data

$D[] = 'exp_templates';

$Q[] = "CREATE TABLE exp_templates (
 template_id int(10) unsigned NOT NULL auto_increment,
 site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
 group_id int(6) unsigned NOT NULL,
 template_name varchar(50) NOT NULL,
 save_template_file char(1) NOT NULL default 'n',
 template_type varchar(16) NOT NULL default 'webpage',
 template_data mediumtext NOT NULL,
 template_notes text NOT NULL,
 edit_date int(10) NOT NULL DEFAULT 0,
 cache char(1) NOT NULL default 'n',
 refresh int(6) unsigned NOT NULL,
 no_auth_bounce varchar(50) NOT NULL,
 enable_http_auth CHAR(1) NOT NULL default 'n',
 allow_php char(1) NOT NULL default 'n',
 php_parse_location char(1) NOT NULL default 'o',
 hits int(10) unsigned NOT NULL,
 PRIMARY KEY (template_id),
 KEY (group_id),
 KEY (site_id)
)"; 

// Template "no access"
// Since each template can be made private to specific member groups
// we store member IDs of people who can not access certain templates

$D[] = 'exp_template_no_access';

$Q[] = "CREATE TABLE exp_template_no_access (
 template_id int(6) unsigned NOT NULL,
 member_group smallint(4) unsigned NOT NULL,
 KEY (`template_id`)
)";

// Specialty Templates
// This table contains the various specialty templates, like:
// Admin notification of new members
// Admin notification of comments and trackbacks
// Membership activation instruction
// Member lost password instructions
// Validated member notification
// Remove from mailinglist notification

$D[] = 'exp_specialty_templates';

$Q[] = "CREATE TABLE exp_specialty_templates (
 template_id int(6) unsigned NOT NULL auto_increment,
 site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
 enable_template char(1) NOT NULL default 'y',
 template_name varchar(50) NOT NULL,
 data_title varchar(80) NOT NULL,
 template_data text NOT NULL,
 PRIMARY KEY (template_id),
 KEY (template_name),
 KEY (site_id)
)"; 

// Global variables
// These are user-definable variables

$D[] = 'exp_global_variables';

$Q[] = "CREATE TABLE exp_global_variables (
 variable_id int(6) unsigned NOT NULL auto_increment,
 site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
 variable_name varchar(50) NOT NULL,
 variable_data text NOT NULL,
 user_blog_id int(6) NOT NULL default '0',
 PRIMARY KEY (variable_id),
 KEY (variable_name),
 KEY (site_id)
)";

// Revision tracker
// This is our versioning table, used to store each
// change that is made to a template.

$D[] = 'exp_revision_tracker';

$Q[] = "CREATE TABLE exp_revision_tracker (
 tracker_id int(10) unsigned NOT NULL auto_increment,  
 item_id int(10) unsigned NOT NULL,
 item_table varchar(20) NOT NULL,
 item_field varchar(20) NOT NULL,
 item_date int(10) NOT NULL,
 item_data mediumtext NOT NULL,
 PRIMARY KEY (tracker_id),
 KEY (item_id)
)";


// Upload preferences

// Note: The is_user_blog field indicates whether the blog is
// assigned as a "user blogs" weblog

$D[] = 'exp_upload_prefs';

$Q[] = "CREATE TABLE exp_upload_prefs (
 id int(4) unsigned NOT NULL auto_increment,
 site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
 is_user_blog char(1) NOT NULL default 'n',
 name varchar(50) NOT NULL,
 server_path varchar(100) NOT NULL,
 url varchar(100) NOT NULL,
 allowed_types varchar(3) NOT NULL default 'img',
 max_size varchar(16) NOT NULL,
 max_height varchar(6) NOT NULL,
 max_width varchar(6) NOT NULL,
 properties varchar(120) NOT NULL,
 pre_format varchar(120) NOT NULL,
 post_format varchar(120) NOT NULL,
 file_properties varchar(120) NOT NULL,
 file_pre_format varchar(120) NOT NULL,
 file_post_format varchar(120) NOT NULL,
 PRIMARY KEY (id),
 KEY (site_id)
)";

// Upload "no access"
// We store the member groups that can not access various upload destinations

$D[] = 'exp_upload_no_access';

$Q[] = "CREATE TABLE exp_upload_no_access (
 upload_id int(6) unsigned NOT NULL,
 upload_loc varchar(3) NOT NULL,
 member_group smallint(4) unsigned NOT NULL
)";


// Search results

$D[] = 'exp_search';

$Q[] = "CREATE TABLE exp_search (
 search_id varchar(32) NOT NULL,
 site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
 search_date int(10) NOT NULL,
 keywords varchar(60) NOT NULL,
 member_id int(10) unsigned NOT NULL,
 ip_address varchar(16) NOT NULL,
 total_results int(6) NOT NULL,
 per_page smallint(3) unsigned NOT NULL,
 query text NOT NULL,
 custom_fields text NOT NULL,
 result_page varchar(70) NOT NULL,
 PRIMARY KEY (search_id),
 KEY (site_id)
)";

// Search term log

$D[] = 'exp_search_log';

$Q[] = "CREATE TABLE exp_search_log (
  id int(10) NOT NULL auto_increment,
  site_id INT(4) UNSIGNED NOT NULL DEFAULT 1,
  member_id int(10) unsigned NOT NULL,
  screen_name varchar(50) NOT NULL,
  ip_address varchar(16) default '0' NOT NULL,
  search_date int(10) NOT NULL,
  search_type varchar(32) NOT NULL,
  search_terms varchar(200) NOT NULL,
  PRIMARY KEY (id),
  KEY (site_id)
)"; 

// Private messating tables

$D[] = 'exp_message_attachments';

$Q[] = "CREATE TABLE exp_message_attachments (
  attachment_id int(10) unsigned NOT NULL auto_increment,
  sender_id int(10) unsigned NOT NULL default '0',
  message_id int(10) unsigned NOT NULL default '0',
  attachment_name varchar(50) NOT NULL default '',
  attachment_hash varchar(40) NOT NULL default '',
  attachment_extension varchar(20) NOT NULL default '',
  attachment_location varchar(125) NOT NULL default '',
  attachment_date int(10) unsigned NOT NULL default '0',
  attachment_size int(10) unsigned NOT NULL default '0',
  is_temp char(1) NOT NULL default 'y',
  PRIMARY KEY (attachment_id)
)";

$D[] = 'exp_message_copies';

$Q[] = "CREATE TABLE exp_message_copies (
  copy_id int(10) unsigned NOT NULL auto_increment,
  message_id int(10) unsigned NOT NULL default '0',
  sender_id int(10) unsigned NOT NULL default '0',
  recipient_id int(10) unsigned NOT NULL default '0',
  message_received char(1) NOT NULL default 'n',
  message_read char(1) NOT NULL default 'n',
  message_time_read int(10) unsigned NOT NULL default '0',
  attachment_downloaded char(1) NOT NULL default 'n',
  message_folder int(10) unsigned NOT NULL default '1',
  message_authcode varchar(10) NOT NULL default '',
  message_deleted char(1) NOT NULL default 'n',
  message_status varchar(10) NOT NULL default '',
  PRIMARY KEY  (copy_id),
  KEY message_id (message_id),
  KEY recipient_id (recipient_id),
  KEY sender_id (sender_id)
)";

$D[] = 'exp_message_data';

$Q[] = "CREATE TABLE exp_message_data (
  message_id int(10) unsigned NOT NULL auto_increment,
  sender_id int(10) unsigned NOT NULL default '0',
  message_date int(10) unsigned NOT NULL default '0',
  message_subject varchar(255) NOT NULL default '',
  message_body text NOT NULL,
  message_tracking char(1) NOT NULL default 'y',
  message_attachments char(1) NOT NULL default 'n',
  message_recipients varchar(200) NOT NULL default '',
  message_cc varchar(200) NOT NULL default '',
  message_hide_cc char(1) NOT NULL default 'n',
  message_sent_copy char(1) NOT NULL default 'n',
  total_recipients int(5) unsigned NOT NULL default '0',
  message_status varchar(25) NOT NULL default '',
  PRIMARY KEY  (message_id),
  KEY sender_id (sender_id)
)";


$D[] = 'exp_message_folders';

$Q[] = "CREATE TABLE exp_message_folders (
  member_id int(10) unsigned NOT NULL default '0',
  folder1_name varchar(50) NOT NULL default 'InBox',
  folder2_name varchar(50) NOT NULL default 'Sent',
  folder3_name varchar(50) NOT NULL default '',
  folder4_name varchar(50) NOT NULL default '',
  folder5_name varchar(50) NOT NULL default '',
  folder6_name varchar(50) NOT NULL default '',
  folder7_name varchar(50) NOT NULL default '',
  folder8_name varchar(50) NOT NULL default '',
  folder9_name varchar(50) NOT NULL default '',
  folder10_name varchar(50) NOT NULL default '',
  KEY member_id (member_id)
)";

$D[] = 'exp_message_listed';

$Q[] = "CREATE TABLE exp_message_listed (
  listed_id int(10) unsigned NOT NULL auto_increment,
  member_id int(10) unsigned NOT NULL default '0',
  listed_member int(10) unsigned NOT NULL default '0',
  listed_description varchar(100) NOT NULL default '',
  listed_type varchar(10) NOT NULL default 'blocked',
  PRIMARY KEY (listed_id)
)";

$D[] = 'exp_extensions';

$Q[] = "CREATE TABLE `exp_extensions` (
	`extension_id` int(10) unsigned NOT NULL auto_increment,
	`class` varchar(50) NOT NULL default '',
	`method` varchar(50) NOT NULL default '',
	`hook` varchar(50) NOT NULL default '',
	`settings` text NOT NULL,
	`priority` int(2) NOT NULL default '10',
	`version` varchar(10) NOT NULL default '',
	`enabled` char(1) NOT NULL default 'y',
	PRIMARY KEY (`extension_id`)
)";


$D[] = 'exp_member_search';

$Q[] = "CREATE TABLE `exp_member_search` 
		 (
			 `search_id` varchar(32) NOT NULL,
			 `site_id` INT(4) UNSIGNED NOT NULL DEFAULT 1,
			 `search_date` int(10) unsigned NOT NULL,
			 `keywords` varchar(200) NOT NULL,
			 `fields` varchar(200) NOT NULL,
			 `member_id` int(10) unsigned NOT NULL,
			 `ip_address` varchar(16) NOT NULL,
			 `total_results` int(8) unsigned NOT NULL,
			 `query` text NOT NULL,
			 PRIMARY KEY  (`search_id`),
			 KEY `member_id` (`member_id`),
			 KEY `site_id` (`site_id`)
		 )";
		 
$D[] = 'exp_member_bulletin_board';
		 
$Q[] =	"CREATE TABLE `exp_member_bulletin_board`
		(
			`bulletin_id` int(10) unsigned NOT NULL auto_increment,
			`sender_id` int(10) unsigned NOT NULL,
			`bulletin_group` int(8) unsigned NOT NULL,
			`bulletin_date` int(10) unsigned NOT NULL,
			`hash` varchar(10) NOT NULL DEFAULT '',
			`bulletin_expires` int(10) unsigned NOT NULL DEFAULT 0,
			`bulletin_message` text NOT NULL,
			PRIMARY KEY  (`bulletin_id`),
			KEY `sender_id` (`sender_id`),
			KEY `hash` (`hash`)
		)";
?>		