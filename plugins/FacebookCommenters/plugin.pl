
package FacebookCommenters::Plugin;
use base qw( MT::Plugin );

our $instance = __PACKAGE__->new({
    id          => 'FacebookCommenters',
    key         => 'FacebookCommenters',
    name        => 'Facebook Commenters',
    description => '<MT_TRANS phrase="Provides commenter registration through Facebook Connect.">',
    version     => '1.1',
    author_name => 'Six Apart, Ltd.',
    author_link => 'http://www.sixapart.com/',
    plugin_link => 'http://www.sixapart.com/',
    l10n_class  => 'FacebookCommenters::L10N',
});
MT->add_plugin($instance);

sub instance { $instance }

my $API_SERVER     = q{http://api.new.facebook.com/restserver.php};

sub init_registry {
    my ($plugin) = @_;
    $plugin->registry({
        settings => {
            facebook_app_key => {
                Default => q{},
                Scope   => 'blog',
            },
            facebook_app_secret => {
                Default => q{},
                Scope   => 'blog',
            },
            facebook_story_template_id => {
                Scope => 'blog',
            },
        },
        blog_config_template => 'blog_config_template.tmpl',
        callbacks => {
            'MT::App::Comments::template_param.login' => sub {
                my ($cb, $app, $param, $tmpl) = @_;
                my $sets = $tmpl->getElementsByTagName('setvarblock');
                my ($set) = grep { $_ && ref $_ && $_->getAttribute('name') eq 'html_head' } @$sets;
                return if !$set;

                # We're just putting this string in the body of a preparsed
                # tag, so it can't include MT template code.
                $set->appendChild($tmpl->createTextNode(<<"EOF"));
                    <style type="text/css">
                        .fb_popupContainer {
                            z-index: 9000;  /* ITS Z-INDEX IS OVER NINE-THOUSAND?!?! */
                        }
                        a.fbconnect_login_button { text-decoration: none; }
                    </style>
                    <script src="http://yui.yahooapis.com/combo?2.5.2/build/yahoo-dom-event/yahoo-dom-event.js" type="text/javascript"></script>
EOF
            },
        },
        commenter_authenticators => {
            Facebook => {
                class => 'FacebookCommenters::Auth',
                label => 'Facebook',
                logo  => 'plugins/FacebookCommenters/signin_facebook.png',
                logo_small => 'plugins/FacebookCommenters/facebook_logo.png',
                login_form => '
                <div>
                   <fb:login-button length="long" onlogin="signface_login();"></fb:login-button>
                </div>
                <form id="facebook-signin-form" method="post" action="<mt:var name="script_url">">
                    <input type="hidden" name="__mode"   value="login_external">
                    <input type="hidden" name="blog_id"  value="<mt:var name="blog_id">">
                    <input type="hidden" name="entry_id" value="<mt:var name="entry_id">">
                    <mt:if name="return_url">
                    <input type="hidden" name="return_url" value="<mt:var name="return_url" escape="html">">
                    <mt:else>
                    <input type="hidden" name="static"   value="<mt:var name="static" escape="html">">
                    </mt:if>
                    <input type="hidden" name="key"      value="Facebook">
                    <input type="hidden" name="facebook_id"   id="facebook-signin-id-input">
                    <input type="hidden" name="facebook_nick" id="facebook-signin-nick-input">
                    <input type="hidden" name="facebook_url"  id="facebook-signin-url-input">
                </form>

                <!-- put the script tags in the <body> element, after all XFBML -->
                    <script src="http://static.ak.connect.facebook.com/js/api_lib/v0.4/FeatureLoader.js.php" type="text/javascript"></script>
                    <script type="text/javascript" src="<$mt:StaticWebPath$>plugins/FacebookCommenters/fbconnect.js"></script>
                    <script type="text/javascript">
                      FB.init(\'<mt:var name="fb_api_key" escape="js">\', 
                              \'<mt:staticwebpath>plugins/FacebookCommenters/xd_receiver.html\');
                    </script>
',
                login_form_params => sub {
                    my ($key, $blog_id, $entry_id, $static) = @_;
                    my $params = MT::_commenter_auth_params(@_);
                    $params->{fb_api_key} = $instance->get_config_value('facebook_app_key', "blog:$blog_id");

                    my $return_url = MT->instance->param('return_url');
                    $params->{return_url} = $return_url if $return_url;

                    return $params;
                },
                condition => sub {
                    my ( $blog, $reason ) = @_;
                    return 1 unless $blog;
                    my $fb_api_key = $instance->get_config_value('facebook_app_key', "blog:" . $blog->id);
                    my $fb_api_secret = $instance->get_config_value('facebook_app_secret', "blog:" . $blog->id);
                    unless ( $fb_api_secret && $fb_api_key ) {
                        $$reason = 
                            '<a href="?__mode=cfg_plugins&amp;blog_id=' . $blog->id . '">'
                          . $instance->translate('Set up Facebook Commenters plugin')
                          . '</a>';
                        return 0;
                    }
                    return 1;
                }
            },
        },
        tags => {
            function => {
                GreetFacebookCommenters => '$FacebookCommenters::FacebookCommenters::Plugin::tag_greet',
            },
        },
    });

    require MT::Template::ContextHandlers;
    my $old_comment_author_link = \&MT::Template::Context::_hdlr_comment_author_link;
    my $new_comment_author_link = sub {
        my ($ctx, $args) = @_;
        my $link = $old_comment_author_link->(@_);
        
        my $commenter = $ctx->stash('commenter');
        if (!$commenter) {
            return $link;
        }
        my $auth_type = $commenter->auth_type || q{};
        if ($auth_type ne 'Facebook') {
            return $link;
        }

        my $id = $commenter->name;
        return qq{<fb:name uid="$id" linked="true">$link</fb:name>};
    };

    no warnings 'redefine';
    *MT::Template::Context::_hdlr_comment_author_link = $new_comment_author_link;
}

sub make_fb_client {
    my $plugin = shift;
    my %param = @_;

    local @param{qw( api_key secret )} = @param{qw( api_key secret )};
    my $blog_id = $param{blog_id} || q{};
    $param{api_key} ||= $plugin->get_config_value('facebook_app_key',    "blog:$blog_id");
    $param{secret}  ||= $plugin->get_config_value('facebook_app_secret', "blog:$blog_id");

    require WWW::Facebook::API;
    my $client = WWW::Facebook::API->new(
        desktop      => 0,
        api_key      => $param{api_key},
        secret       => $param{secret},
        throw_errors => 0,
        server_uri   => $API_SERVER,
    );

    return $client;
}

sub save_config {
    my $plugin = shift;
    my ($param, $scope) = @_;

    my $client = $plugin->make_fb_client(
        api_key      => $param->{facebook_app_key}    || q{},
        secret       => $param->{facebook_app_secret} || q{},
    );

    my $story = $plugin->translate(
        '{*actor*} commented on the blog post <a href="{*post_url*}">{*post_title*}</a>.'
    );

    # Supposed to pass a JSON array as a string here, wtf?
    $client->_parse( q{ [ 1 ] } );  # build the parser
    my $response = $client->feed->register_template_bundle(
        one_line_story_templates => $client->_parser()->encode( [ $story ] ),
    );
    if ('HASH' eq ref $response && $response->{error_code}) {
        my $err;
        my $error_msg = $response->{error_msg};
        if ($response->{error_code} == 104) {
            $err = $plugin->translate('Could not register story template with Facebook: [_1]. Did you enter the correct application secret?', $error_msg);
        }
        else {
            $err = $plugin->translate('Could not register story template with Facebook: [_1]',
                $error_msg);
        }
        return $plugin->error($err);
    }

    local ($param->{facebook_story_template_id})
        = ref $response ? @$response : ($response);
    return $plugin->SUPER::save_config(@_);
}

sub tag_greet {
    my ($ctx, $args) = @_;

    my $entry    = $ctx->stash('entry');
    return '' unless $entry;

    my $blog     = $ctx->stash('blog');
    my $blog_id  = $blog->id;
    my $app_key  = $instance->get_config_value('facebook_app_key', "blog:$blog_id");
    my $story_id = $instance->get_config_value('facebook_story_template_id', "blog:$blog_id");

    my $tmpl = $instance->load_tmpl('greets.tmpl');
    my $vars = $ctx->{__stash}{vars};

    local $vars->{fb_api_key} = $app_key;
    local $vars->{facebook_story_template_id} = $story_id;

    local $vars->{facebook_send_story} = $vars->{comment_confirmation} ? 1
                                       : $vars->{comment_pending}      ? 1
                                       :                                 0
                                       ;
    local $vars->{facebook_apply_commenter_data} = 1
        if $ctx->stash('entry');
    local $vars->{facebook_act_now} = $vars->{facebook_send_story}
        || $vars->{facebook_apply_commenter_data};

    return $tmpl->build($ctx);
}

1;

