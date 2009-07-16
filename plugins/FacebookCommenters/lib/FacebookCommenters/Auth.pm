package FacebookCommenters::Auth;

use strict;

sub password_exists { 0 }

sub login {
    my $class = shift;
    my ($app) = @_;

    my $blog_id = $app->param('blog_id')
        or return $app->error('No blog_id');

    my %facebook = map { $_ => $app->param("facebook_$_") || q{} } qw( id nick url );
    
=pod

    my $plugin = MT->component('FacebookCommenters');
    my $client = $plugin->make_fb_client(
        blog_id => $blog_id,
    );

    my $sig_good = $client->verify_sig(
        params => [],
        sig    => $facebook{sig},
    );
    
    return $app->error($plugin->translate(
        q{Could not authenticate Facebook commenter: Facebook's signature was not valid.}))
            if !$sig_good;

=cut

    return $app->errtrans("Invalid request.")
        if !$blog_id || !$facebook{id};

    # Get the Facebook author for this id.
    my $make_commenter = 'make_commenter';
    if (! $app->can($make_commenter)) {
        # For legacy versions
        $make_commenter = '_make_commenter';
    }
    my $commenter = $app->$make_commenter(
        auth_type   => 'Facebook',
        email       => q(),
        nickname    => $facebook{nick} || $facebook{id},
        name        => $facebook{id},
        external_id => $facebook{id},
    );
    return unless $commenter;
    $commenter->save();

    my $session;
    if ($app->can('make_commenter_session')) {
        # Yay, happy newtime!
        $session = $app->make_commenter_session($commenter);
    }
    else {
        $session = $app->_make_commenter_session(
            $commenter,
            $app->make_magic_token(),
            q{},              # email
            $facebook{id},    # name
            $facebook{nick} || $facebook{id},  # nick
            undef,            # id?
            $facebook{url},   # url
        );
    }
    
    return $app->redirect_to_target();
}

1;
