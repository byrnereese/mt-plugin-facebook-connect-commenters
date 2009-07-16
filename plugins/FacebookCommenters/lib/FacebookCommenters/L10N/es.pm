# Movable Type (r) (C) 2001-2008 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: es.pm 99820 2009-03-09 13:55:28Z mschenk $

package FacebookCommenters::L10N::es;

use strict;
use base 'FacebookCommenters::L10N::en_us';
use vars qw( %Lexicon );
%Lexicon = (

## plugins/FacebookCommenters/lib/FacebookCommenters/Auth.pm

## plugins/FacebookCommenters/plugin.pl
	'Provides commenter registration through Facebook Connect.' => 'Provee registro de comentaristas a través de Facebook Connect.',
	'Set up Facebook Commenters plugin' => 'Configurar la extesión de comentaristas de Facebook',
	'{*actor*} commented on the blog post <a href="{*post_url*}">{*post_title*}</a>.' => '{*actor*} comentó en la entrada <a href="{*post_url*}">{*post_title*}</a>.',
	'Could not register story template with Facebook: [_1]. Did you enter the correct application secret?' => 'No se pudo registrar la plantilla de historias con Facebook: [_1]. ¿No introdujo el secreto correcto de la aplicación?',
	'Could not register story template with Facebook: [_1]' => 'No pudo registrar la plantilla de historias con Facebook: [_1]',
	'Facebook' => 'Facebook',

## plugins/FacebookCommenters/tmpl/blog_config_template.tmpl
	'Facebook Application Key' => 'Clave de la aplicación de Facebook',
	'The key for the Facebook application associated with your blog.' => 'La clave de la aplicación de Facebook asociada con su blog.',
	'Edit Facebook App' => 'Editar aplicación de Facebook',
	'Create Facebook App' => 'Crear aplicación de Facebook', # Translate - New
	'Facebook Application Secret' => 'Secreto de la aplicación de Facebook',
	'The secret for the Facebook application associated with your blog.' => 'El secreto de la aplicación de Facebook asociada con su blog.',

);

1;
