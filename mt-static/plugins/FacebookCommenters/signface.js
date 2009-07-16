
function apply_commenter_data() {
    FB_RequireFeatures(["XFBML","Api"], function()
    {
        FB.Facebook.init(window.api_key, window.xd_receiver_url);

        // Get the current logged in user
        var session = FB.Facebook.apiClient.get_session();
        if (!session) return;
        var viewerId = session.uid;
        if (!viewerId) return;

        // Find the various FB users we're rendering
        var FBIds = new Array();
        jQuery("fb:name").each(function() {
            FBIds.push($(this).getAttribute("uid"));
        });

        // Highlight your comments
        jQuery(".comment-fb-" + viewerId).each(function() {
            $(this).addClass("comment-friend");
        });

        // Find friends and highlight theirs
        FB.Facebook.apiClient.fql_query("SELECT uid2 FROM friend WHERE uid1=" + viewerId + " AND uid2 IN (" + FBIds.join(',') + ")", function(result, ex)
        {
            for (var i = 0; i < result.length; i++) {
                jQuery(".comment-fb-" + result[i]["uid2"]).each(function() {
                    $(this).addClass("comment-friend");
                });
            }
        });

        // Hide the URL and "remember me" boxes
        mtHide('comments-open-data');
    });
}

function send_story(post_url, post_title, story_template_id) {
    FB_RequireFeatures(["Api", "Connect"], function()
    {
        FB.Facebook.init(window.api_key, window.xd_receiver_url);
        FB.Connect.get_status().waitUntilReady(function(status) {
            FB.Connect.showFeedDialog(
                story_template_id,
                {
                    "post_url": post_url,
                    "post_title": post_title
                },
                "",
                "",
                FB.FeedStorySize.oneLine
            );
        });
    });
}

function facebook_logout() {
    FB_RequireFeatures(["Api", "Connect"], function() {
        FB.Facebook.init(window.api_key, window.xd_receiver_url);

        // Get the current logged in user
        var session = FB.Facebook.apiClient.get_session();
        if (!session) return;
        var viewerId = session.uid;
        if (!viewerId) return;

        FB.Connect.logout();
    });
}
