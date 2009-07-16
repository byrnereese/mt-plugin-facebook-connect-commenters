# Movable Type (r) (C) 2001-2008 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: nl.pm 99820 2009-03-09 13:55:28Z mschenk $

package FacebookCommenters::L10N::nl;

use strict;
use base 'FacebookCommenters::L10N::en_us';
use vars qw( %Lexicon );
%Lexicon = (

## plugins/FacebookCommenters/lib/FacebookCommenters/Auth.pm

## plugins/FacebookCommenters/plugin.pl
	'Provides commenter registration through Facebook Connect.' => 'Voegt registratie van reageerders toe via Facebook Connect.',
	'Set up Facebook Commenters plugin' => 'Facebook Reageerders plugin instellen',
	'{*actor*} commented on the blog post <a href="{*post_url*}">{*post_title*}</a>.' => '{*actor*} reageerde op blogbericht <a href="{*post_url*}">{*post_title*}</a>.',
	'Could not register story template with Facebook: [_1]. Did you enter the correct application secret?' => 'Kon verhaalsjabloon niet registreren bij Facebook: [_1].  Vulde u het correcte applicatiegeheim in?',
	'Could not register story template with Facebook: [_1]' => 'Kon verhaalsjabloon niet registreren bij Facebook: [_1].',
	'Facebook' => 'Facebook',

## plugins/FacebookCommenters/tmpl/blog_config_template.tmpl
	'Facebook Application Key' => 'Facebook applicatiesleutel',
	'The key for the Facebook application associated with your blog.' => 'De sleutel voor de Facebook-applicatie geassocieerd met uw blog.',
	'Edit Facebook App' => 'Facebook app bewerken',
	'Create Facebook App' => 'Facebook app aanmaken', # Translate - New
	'Facebook Application Secret' => 'Facebook applicatiegeheim',
	'The secret for the Facebook application associated with your blog.' => 'Het geheim voor de Facebook-applicatie geassocieerd met uw blog.',

);

1;
