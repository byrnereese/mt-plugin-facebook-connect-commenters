# Movable Type (r) (C) 2001-2008 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: fr.pm 99820 2009-03-09 13:55:28Z mschenk $

package FacebookCommenters::L10N::fr;

use strict;
use base 'FacebookCommenters::L10N::en_us';
use vars qw( %Lexicon );
%Lexicon = (

## plugins/FacebookCommenters/lib/FacebookCommenters/Auth.pm

## plugins/FacebookCommenters/plugin.pl
	'Provides commenter registration through Facebook Connect.' => 'Permet l\'enregistrement des auteurs de commentaires via Facebook Connect',
	'Set up Facebook Commenters plugin' => 'Configurer le plugin Facebook Commenters',
	'{*actor*} commented on the blog post <a href="{*post_url*}">{*post_title*}</a>.' => '{*actor*} a commenté la note <a href="{*post_url*}">{*post_title*}</a>.',
	'Could not register story template with Facebook: [_1]. Did you enter the correct application secret?' => 'Impossible d\'enregistrer le modèle d\'histoire avec Facebook : [_1]. Avez-vous correctement entré le secret de l\'application ?',
	'Could not register story template with Facebook: [_1]' => 'Impossible d\'enregistrer le modèle d\'histoire avec Facebook : [_1].',
	'Facebook' => 'Facebook', # Translate - Case

## plugins/FacebookCommenters/tmpl/blog_config_template.tmpl
	'Facebook Application Key' => 'Clé Application Facebook',
	'The key for the Facebook application associated with your blog.' => 'La clé pour l\'application Facebook associée à votre blog.',
	'Edit Facebook App' => 'Éditer l\'application Facebook',
	'Create Facebook App' => 'Créer une application Facebook', # Translate - New
	'Facebook Application Secret' => 'Secret Application Facebook',
	'The secret for the Facebook application associated with your blog.' => 'Le secret pour l\'application Facebook associée à votre blog.',

);

1;
