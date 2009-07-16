<?php
require_once('commenter_auth_lib.php');

class FacebookCommenterAuth extends BaseCommenterAuthProvider {
    function get_key() {
        return 'Facebook';
    }
    function get_label() {
        return 'Facebook Commenter Authenticator';
    }
    function get_logo() {
        return 'plugins/FacebookCommenters/signin_facebook.png';
    }
    function get_logo_small() {
        return 'plugins/FacebookCommenters/facebook_logo.png';
    }
}

global $_commenter_auths;
$provider = new FacebookCommenterAuth();
$_commenter_auths[$provider->get_key()] = $provider;

?>
