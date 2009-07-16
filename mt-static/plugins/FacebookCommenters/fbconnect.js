
/*
 * Show the feed form. This would be typically called in response to the
 * onclick handler of a "Publish" button, or in the onload event after
 * the user submits a form with info that should be published.
 *
 */
function facebook_publish_feed_story(form_bundle_id, template_data) {
  // Load the feed form
 FB.ensureInit(function() {
      FB.Connect.showFeedDialog(form_bundle_id, template_data);

      // hide the "Loading feed story ..." div
      ge('feed_loading').style.visibility = "hidden";
  });
}

/*
 * If a user is not connected, then the checkbox that says "Publish To Facebook"
 * is hidden in the "add run" form.
 * This function detects whether the user is logged into facebook but just
 * not connected, and shows the checkbox if that's true.
 *
 */
function facebook_show_feed_checkbox() {
  FB.ensureInit(function() {
      FB.Connect.get_status().waitUntilReady(function(status) {
          if (status != FB.UserLoginState.userNotLoggedIn) {
            // If the user is currently logged into Facebook, but has not
            // authorized the app, then go ahead and show them the beacon form + upsell
            checkbox = ge('publish_fb_checkbox');
            if (checkbox) {
              checkbox.style.visibility = "visible";
            }
          }
        });
    });
}

/*
 * Run 
 */
function signface_login () {
    var viewerId = FB.Connect.get_loggedInUser();
    document.getElementById('facebook-signin-id-input').setAttribute('value', viewerId);
    document.getElementById('facebook-signin-url-input').setAttribute('value', 'http://www.facebook.com/profile.php?id=' + viewerId);
    FB.Facebook.apiClient.users_getInfo(viewerId, ['first_name,pic_square'], function (x) {
	if (x[0] && x[0]['first_name']) {
	    var nickname = x[0]['first_name'];
	    document.getElementById('facebook-signin-nick-input').setAttribute('value', nickname);
	}
	document.getElementById('facebook-signin-form').submit();
    });
}
