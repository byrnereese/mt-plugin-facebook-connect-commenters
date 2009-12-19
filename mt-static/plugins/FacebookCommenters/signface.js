
function apply_commenter_data(fb) {
    FB_RequireFeatures(["XFBML","Api"], function()
    {
        FB.Facebook.init(fb.api_key, fb.xd_receiver_url);

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
        $('#comments-open-data').hide();
    });
}

function send_comment(fb, story, image, comment) {
    FB_RequireFeatures(["Api", "Connect"], function()
    {
        FB.Facebook.init(fb.api_key, fb.xd_receiver_url);
        FB.Connect.get_status().waitUntilReady(function(status) {
            var actionLinks = [
                               { "text": "Read My Comment", "href": story.url + "#comment-" + comment.id },
                               { "text": "Read Blog Post", "href": story.url }
                              ];
            FB.Connect.streamPublish(
                                     '', // user message
                                     {
                                         name: story.title,
                                         href: story.url,
                                         description: comment.text,
                                         caption: '{*actor*} posted a comment to "' + story.blog_name + '"',
                                         comments_xid: story.xid,
                                         media: [ image ]
                                     },
                                     actionLinks,
                                     null, // target_id
                                     null, // user message prompt
                                     null  // callback
                                     );
        });
    });
}

function facebook_logout(fb) {
    FB_RequireFeatures(["Api", "Connect"], function() {
        FB.Facebook.init(fb.api_key, fb.xd_receiver_url);

        // Get the current logged in user
        var session = FB.Facebook.apiClient.get_session();
        if (!session) return;
        var viewerId = session.uid;
        if (!viewerId) return;

        FB.Connect.logout();
    });
}
