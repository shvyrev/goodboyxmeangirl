-- phpMyAdmin SQL Dump
-- version 2.11.6
-- http://www.phpmyadmin.net
--
-- Serveur: localhost
-- Généré le : Sam 02 Août 2008 à 21:27
-- Version du serveur: 5.0.51
-- Version de PHP: 5.2.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Base de données: `cms`
--

-- --------------------------------------------------------

--
-- Structure de la table `banned`
--

DROP TABLE IF EXISTS `banned`;
CREATE TABLE IF NOT EXISTS `banned` (
  `id` tinyint(3) unsigned NOT NULL auto_increment,
  `reason` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Contenu de la table `banned`
--


-- --------------------------------------------------------

--
-- Structure de la table `category`
--

DROP TABLE IF EXISTS `category`;
CREATE TABLE IF NOT EXISTS `category` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `name` varchar(128) character set utf8 default NULL,
  `post_id` text character set utf8,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Contenu de la table `category`
--


-- --------------------------------------------------------

--
-- Structure de la table `comments`
--

DROP TABLE IF EXISTS `comments`;
CREATE TABLE IF NOT EXISTS `comments` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(128) character set utf8 default NULL,
  `date` varchar(128) character set utf8 default NULL,
  `content` text character set utf8,
  `auteur` varchar(128) character set utf8 default NULL,
  `email` varchar(128) character set utf8 default NULL,
  `website` varchar(128) character set utf8 default NULL,
  `post_id` text character set utf8,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Contenu de la table `comments`
--


-- --------------------------------------------------------

--
-- Structure de la table `countries`
--

DROP TABLE IF EXISTS `countries`;
CREATE TABLE IF NOT EXISTS `countries` (
  `id` tinyint(3) unsigned NOT NULL auto_increment,
  `country` varchar(75) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=242 ;

--
-- Contenu de la table `countries`
--

INSERT INTO `countries` (`id`, `country`) VALUES
(1, 'United States'),
(2, 'Canada'),
(3, 'Mexico'),
(4, 'Afghanistan'),
(5, 'Albania'),
(6, 'Algeria'),
(7, 'Andorra'),
(8, 'Angola'),
(9, 'Anguilla'),
(10, 'Antarctica'),
(11, 'Antigua and Barbuda'),
(12, 'Argentina'),
(13, 'Armenia'),
(14, 'Aruba'),
(15, 'Ascension Island'),
(16, 'Australia'),
(17, 'Austria'),
(18, 'Azerbaijan'),
(19, 'Bahamas'),
(20, 'Bahrain'),
(21, 'Bangladesh'),
(22, 'Barbados'),
(23, 'Belarus'),
(24, 'Belgium'),
(25, 'Belize'),
(26, 'Benin'),
(27, 'Bermuda'),
(28, 'Bhutan'),
(29, 'Bolivia'),
(30, 'Bophuthatswana'),
(31, 'Bosnia-Herzegovina'),
(32, 'Botswana'),
(33, 'Bouvet Island'),
(34, 'Brazil'),
(35, 'British Indian Ocean'),
(36, 'British Virgin Islands'),
(37, 'Brunei Darussalam'),
(38, 'Bulgaria'),
(39, 'Burkina Faso'),
(40, 'Burundi'),
(41, 'Cambodia'),
(42, 'Cameroon'),
(44, 'Cape Verde Island'),
(45, 'Cayman Islands'),
(46, 'Central Africa'),
(47, 'Chad'),
(48, 'Channel Islands'),
(49, 'Chile'),
(50, 'China, Peoples Republic'),
(51, 'Christmas Island'),
(52, 'Cocos (Keeling) Islands'),
(53, 'Colombia'),
(54, 'Comoros Islands'),
(55, 'Congo'),
(56, 'Cook Islands'),
(57, 'Costa Rica'),
(58, 'Croatia'),
(59, 'Cuba'),
(60, 'Cyprus'),
(61, 'Czech Republic'),
(62, 'Denmark'),
(63, 'Djibouti'),
(64, 'Dominica'),
(65, 'Dominican Republic'),
(66, 'Easter Island'),
(67, 'Ecuador'),
(68, 'Egypt'),
(69, 'El Salvador'),
(70, 'England'),
(71, 'Equatorial Guinea'),
(72, 'Estonia'),
(73, 'Ethiopia'),
(74, 'Falkland Islands'),
(75, 'Faeroe Islands'),
(76, 'Fiji'),
(77, 'Finland'),
(78, 'France'),
(79, 'French Guyana'),
(80, 'French Polynesia'),
(81, 'Gabon'),
(82, 'Gambia'),
(83, 'Georgia Republic'),
(84, 'Germany'),
(85, 'Gibraltar'),
(86, 'Greece'),
(87, 'Greenland'),
(88, 'Grenada'),
(89, 'Guadeloupe (French)'),
(90, 'Guatemala'),
(91, 'Guernsey Island'),
(92, 'Guinea Bissau'),
(93, 'Guinea'),
(94, 'Guyana'),
(95, 'Haiti'),
(96, 'Heard and McDonald Isls'),
(97, 'Honduras'),
(98, 'Hong Kong'),
(99, 'Hungary'),
(100, 'Iceland'),
(101, 'India'),
(102, 'Iran'),
(103, 'Iraq'),
(104, 'Ireland'),
(105, 'Isle of Man'),
(106, 'Israel'),
(107, 'Italy'),
(108, 'Ivory Coast'),
(109, 'Jamaica'),
(110, 'Japan'),
(111, 'Jersey Island'),
(112, 'Jordan'),
(113, 'Kazakhstan'),
(114, 'Kenya'),
(115, 'Kiribati'),
(116, 'Kuwait'),
(117, 'Laos'),
(118, 'Latvia'),
(119, 'Lebanon'),
(120, 'Lesotho'),
(121, 'Liberia'),
(122, 'Libya'),
(123, 'Liechtenstein'),
(124, 'Lithuania'),
(125, 'Luxembourg'),
(126, 'Macao'),
(127, 'Macedonia'),
(128, 'Madagascar'),
(129, 'Malawi'),
(130, 'Malaysia'),
(131, 'Maldives'),
(132, 'Mali'),
(133, 'Malta'),
(134, 'Martinique (French)'),
(135, 'Mauritania'),
(136, 'Mauritius'),
(137, 'Mayotte'),
(139, 'Micronesia'),
(140, 'Moldavia'),
(141, 'Monaco'),
(142, 'Mongolia'),
(143, 'Montenegro'),
(144, 'Montserrat'),
(145, 'Morocco'),
(146, 'Mozambique'),
(147, 'Myanmar'),
(148, 'Namibia'),
(149, 'Nauru'),
(150, 'Nepal'),
(151, 'Netherlands Antilles'),
(152, 'Netherlands'),
(153, 'New Caledonia (French)'),
(154, 'New Zealand'),
(155, 'Nicaragua'),
(156, 'Niger'),
(157, 'Niue'),
(158, 'Norfolk Island'),
(159, 'North Korea'),
(160, 'Northern Ireland'),
(161, 'Norway'),
(162, 'Oman'),
(163, 'Pakistan'),
(164, 'Panama'),
(165, 'Papua New Guinea'),
(166, 'Paraguay'),
(167, 'Peru'),
(168, 'Philippines'),
(169, 'Pitcairn Island'),
(170, 'Poland'),
(171, 'Polynesia (French)'),
(172, 'Portugal'),
(173, 'Qatar'),
(174, 'Reunion Island'),
(175, 'Romania'),
(176, 'Russia'),
(177, 'Rwanda'),
(178, 'S.Georgia Sandwich Isls'),
(179, 'Sao Tome, Principe'),
(180, 'San Marino'),
(181, 'Saudi Arabia'),
(182, 'Scotland'),
(183, 'Senegal'),
(184, 'Serbia'),
(185, 'Seychelles'),
(186, 'Shetland'),
(187, 'Sierra Leone'),
(188, 'Singapore'),
(189, 'Slovak Republic'),
(190, 'Slovenia'),
(191, 'Solomon Islands'),
(192, 'Somalia'),
(193, 'South Africa'),
(194, 'South Korea'),
(195, 'Spain'),
(196, 'Sri Lanka'),
(197, 'St. Helena'),
(198, 'St. Lucia'),
(199, 'St. Pierre Miquelon'),
(200, 'St. Martins'),
(201, 'St. Kitts Nevis Anguilla'),
(202, 'St. Vincent Grenadines'),
(203, 'Sudan'),
(204, 'Suriname'),
(205, 'Svalbard Jan Mayen'),
(206, 'Swaziland'),
(207, 'Sweden'),
(208, 'Switzerland'),
(209, 'Syria'),
(210, 'Tajikistan'),
(211, 'Taiwan'),
(212, 'Tahiti'),
(213, 'Tanzania'),
(214, 'Thailand'),
(215, 'Togo'),
(216, 'Tokelau'),
(217, 'Tonga'),
(218, 'Trinidad and Tobago'),
(219, 'Tunisia'),
(220, 'Turkmenistan'),
(221, 'Turks and Caicos Isls'),
(222, 'Tuvalu'),
(223, 'Uganda'),
(224, 'Ukraine'),
(225, 'United Arab Emirates'),
(226, 'Uruguay'),
(227, 'Uzbekistan'),
(228, 'Vanuatu'),
(229, 'Vatican City State'),
(230, 'Venezuela'),
(231, 'Vietnam'),
(232, 'Virgin Islands (Brit)'),
(233, 'Wales'),
(234, 'Wallis Futuna Islands'),
(235, 'Western Sahara'),
(236, 'Western Samoa'),
(237, 'Yemen'),
(238, 'Yugoslavia'),
(239, 'Zaire'),
(240, 'Zambia'),
(241, 'Zimbabwe');

-- --------------------------------------------------------

--
-- Structure de la table `groups`
--

DROP TABLE IF EXISTS `groups`;
CREATE TABLE IF NOT EXISTS `groups` (
  `id` tinyint(3) unsigned NOT NULL auto_increment,
  `title` varchar(20) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Contenu de la table `groups`
--


-- --------------------------------------------------------

--
-- Structure de la table `members`
--

DROP TABLE IF EXISTS `members`;
CREATE TABLE IF NOT EXISTS `members` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) character set utf8 default NULL,
  `password` varchar(128) character set utf8 default NULL,
  `email` varchar(128) character set utf8 default NULL,
  `website` varchar(128) character set utf8 default NULL,
  `role` varchar(128) character set utf8 NOT NULL default 'member',
  `logged` varchar(128) character set utf8 NOT NULL default 'false',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Contenu de la table `members`
--


-- --------------------------------------------------------

--
-- Structure de la table `pageadmin`
--

DROP TABLE IF EXISTS `pageadmin`;
CREATE TABLE IF NOT EXISTS `pageadmin` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(128) character set utf8 default NULL,
  `content` text character set utf8,
  `place` varchar(128) character set utf8 default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Contenu de la table `pageadmin`
--


-- --------------------------------------------------------

--
-- Structure de la table `pagesite`
--

DROP TABLE IF EXISTS `pagesite`;
CREATE TABLE IF NOT EXISTS `pagesite` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(128) character set utf8 default NULL,
  `content` text character set utf8,
  `type` varchar(128) character set utf8 default NULL,
  `post_number` varchar(128) character set utf8 default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Contenu de la table `pagesite`
--


-- --------------------------------------------------------

--
-- Structure de la table `posts`
--

DROP TABLE IF EXISTS `posts`;
CREATE TABLE IF NOT EXISTS `posts` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(128) character set utf8 default NULL,
  `date` date default NULL,
  `auteur` varchar(128) character set utf8 default NULL,
  `excerpt` text,
  `content` text character set utf8,
  `category` varchar(128) character set utf8 default NULL,
  `comment_number` int(11) default NULL,
  `tag_number` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Contenu de la table `posts`
--


-- --------------------------------------------------------

--
-- Structure de la table `questions`
--

DROP TABLE IF EXISTS `questions`;
CREATE TABLE IF NOT EXISTS `questions` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `question` varchar(80) NOT NULL default '',
  `answer` varchar(40) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Contenu de la table `questions`
--


-- --------------------------------------------------------

--
-- Structure de la table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
CREATE TABLE IF NOT EXISTS `sessions` (
  `session_id` varchar(40) NOT NULL default '',
  `ip_address` varchar(16) NOT NULL default '',
  `user_agent` varchar(50) NOT NULL,
  `last_activity` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`session_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Contenu de la table `sessions`
--


-- --------------------------------------------------------

--
-- Structure de la table `tags`
--

DROP TABLE IF EXISTS `tags`;
CREATE TABLE IF NOT EXISTS `tags` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `name` varchar(128) character set utf8 default NULL,
  `post_id` text character set utf8,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Contenu de la table `tags`
--


-- --------------------------------------------------------

--
-- Structure de la table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `group_id` tinyint(3) unsigned NOT NULL default '0',
  `banned_id` tinyint(3) unsigned NOT NULL default '0',
  `country_id` tinyint(3) unsigned NOT NULL default '0',
  `question_id` mediumint(8) unsigned NOT NULL default '0',
  `username` varchar(128) character set utf8 NOT NULL default '''''',
  `password` varchar(128) character set utf8 default NULL,
  `email` varchar(128) character set utf8 default NULL,
  `website` varchar(128) character set utf8 default NULL,
  `role` varchar(128) character set utf8 default NULL,
  `logged` varchar(128) character set utf8 NOT NULL default 'false',
  `postnumber` int(11) NOT NULL default '0',
  `hash` varchar(128) character set utf8 NOT NULL default '''''',
  `activation_code` varchar(128) character set utf8 NOT NULL default '''''',
  `forgotten_password_code` varchar(128) character set utf8 NOT NULL default '''''',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Contenu de la table `users`
--

INSERT INTO `users` (`id`, `group_id`, `banned_id`, `country_id`, `question_id`, `username`, `password`, `email`, `website`, `role`, `logged`, `postnumber`, `hash`, `activation_code`, `forgotten_password_code`) VALUES
(1, 1, 0, 1, 0, 'admin', 'admin', 'admin@website.fr', 'http://www.website.fr/', 'admin', 'false', 0, '''''', '''''', '''''');
