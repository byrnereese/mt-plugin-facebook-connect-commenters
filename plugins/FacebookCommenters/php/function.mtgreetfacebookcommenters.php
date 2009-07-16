<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtgreetfacebookcommenters($args, &$ctx) {

    $entry = $ctx->stash('entry');
    if (empty($entry))
        return '';

    $blog = $ctx->stash('blog');
    if (empty($blog))
        return '';
    $blog_id = $blog['blog_id'];

    # Load settings
    $config = $ctx->mt->db->fetch_plugin_config('FacebookCommenters', "blog:$blog_id");
    if (empty($config) || 
        empty($config['facebook_app_key']) ||
        empty($config['facebook_story_template_id']))
        return '';

    # Load 'greets.tmpl'
    $dir = dirname(__FILE__);
    $dir = explode(DIRECTORY_SEPARATOR, $dir);
    array_pop($dir);
    $dir = implode(DIRECTORY_SEPARATOR, $dir);
    $fp = fopen("$dir/tmpl/greets.tmpl", "r");
    $tmpl = '';
    while (!feof($fp)) {
        $tmpl .= fgets($fp, 1024);
    }
    fclose ($fp);
    if (empty($tmpl))
        return '';

    # Bind variants
    $localvars = array('fb_api_key', 'facebook_story_template_id','facebook_send_story','facebook_apply_commenter_data','facebook_act_now');
    $ctx->localize($localvars);
    $ctx->__stash['vars']['fb_api_key'] = $config['facebook_app_key'];
    $ctx->__stash['vars']['facebook_story_template_id'] = $config['facebook_story_template_id'];
    $ctx->__stash['vars']['facebook_send_story'] =
        (isset($ctx->__stash['vars']['comment_confirmation']) && $ctx->__stash['vars']['comment_confirmation']) ? 1
        : (isset($ctx->__stash['vars']['comment_pending']) && $ctx->__stash['vars']['comment_pending']) ? 1
        : 0;
    $ctx->__stash['vars']['facebook_apply_commenter_data'] = 1;
    if ($ctx->__stash['vars']['facebook_send_story'])
        $ctx->__stash['vars']['facebook_act_now'] = $ctx->__stash['vars']['facebook_send_story'];
    elseif ($ctx->__stash['vars']['facebook_apply_commenter_data'])
        $ctx->__stash['vars']['facebook_act_now'] = $ctx->__stash['vars']['facebook_apply_commenter_data'];

    # Build template;
    $_var_compiled = '';
    if (!$ctx->_compile_source('evaluated template', $tmpl, $_var_compiled)) {
        return $ctx->error("Error compiling text '$text'");
    }
    ob_start();
    $ctx->_eval('?>' . $_var_compiled);
    $_contents = ob_get_contents();
    ob_end_clean();
    $ctx->restore($localvars);

    return $_contents;
}

