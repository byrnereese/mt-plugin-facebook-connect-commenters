# Movable Type (r) (C) 2001-2008 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: de.pm 99820 2009-03-09 13:55:28Z mschenk $

package FacebookCommenters::L10N::de;

use strict;
use base 'FacebookCommenters::L10N::en_us';
use vars qw( %Lexicon );
%Lexicon = (

## plugins/FacebookCommenters/lib/FacebookCommenters/Auth.pm

## plugins/FacebookCommenters/plugin.pl
	'Provides commenter registration through Facebook Connect.' => 'Ermöglicht es Kommentarautoren, sich über Facebook Connect zu registrieren',
	'Set up Facebook Commenters plugin' => 'Facebook Kommentarautoren-Plugin einrichten',
	'{*actor*} commented on the blog post <a href="{*post_url*}">{*post_title*}</a>.' => '{*actor*} hat den Blog-Eintrag <a href="{*post_url*}">{*post_title*}</a> kommentiert.',
	'Could not register story template with Facebook: [_1]. Did you enter the correct application secret?' => 'Das Story Template konnte nicht bei Facebook registriert werden: [_1]. Haben Sie das Application Secret richtig eingegeben?',
	'Could not register story template with Facebook: [_1]' => 'Das Story Template konnte nicht bei Facebook registriert werden: [_1]. ',
	'Facebook' => 'Facebook',

## plugins/FacebookCommenters/tmpl/blog_config_template.tmpl
	'Facebook Application Key' => 'Facebook Application Key',
	'The key for the Facebook application associated with your blog.' => 'Der Application Key der mit Ihrem Blog verknüpften Facebook-Anwendung',
	'Edit Facebook App' => 'Facebook-Anwendung bearbeiten', # Translate - Improved (2) # OK
	'Create Facebook App' => 'Facebook-Anwendung erstellen', # Translate - New # OK
	'Facebook Application Secret' => 'Facebook Application Secret',
	'The secret for the Facebook application associated with your blog.' => 'Das Application Secret der mit Ihrem Blog verknüpften Facebook-Anwendung',

);

1;
