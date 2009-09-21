# Facebook Connect Commenters Plugin for Movable Type

Authors: Mark Paschal and David Recordon
Copyright 2008 Six Apart, Ltd.
License: Artistic, licensed under the same terms as Perl itself

## Overview

The Facebook Connect Commenters plugin for Movable Type allows commenters to login to your blog using their Facebook account.  It makes use of the Facebook Connect APIs to provide a rich user experience.  Commenters are able to automatically bring their name, profile photo, and friends with them when commenting on a blog running this plugin.

All of this profile information respects a user's privacy settings from Facebook; if they only share their profile photo with their friends then it won't be displayed publicly on a blog. Once a Facebook user has logged in, comments left from other Facebook users will display additional data.  Profile photos and names that were hidden publicly will now be displayed assuming the logged in user is able to see them on Facebook.com.  Additionally, comments left from friends of the user on Facebook will be highlighted.

After leaving a comment, the Facebook user will be given the option to share with their friends on Facebook that they commented on the blog post.  This in turn should help others discover your blog.

**PLEASE NOTE:** Facebook Connect currently requires pre-approval in order for you to launch your blog integration. As long as you are using the standard blog plugin, this should be painless and quick – it should take just a few days at the most.   

Check here to see if Facebook Connect is available for launch with out approval: <http://wiki.developers.facebook.com/index.php/Facebook_Connect_Launch_Plans>

If approval is required, go here to submit your blog with Facebook Connect: <http://www.facebook.com/connect/submit_site.php>


## Prerequisites

* Movable Type 4.1 or higher (4.2 is recommended)
* JSON::XS 2.0 or greater.
* jQuery 1.2.x (bundled with MT 4.25 or greater)

The Facebook Commenters plugin ships with all of the other external libraries you should need to run it.

## Installation

1. If you are installing this plugin on Movable Type 4.1, then you will need to download,
   install and link in your templates the jQuery javascript framework. This can be done 
   by adding the following in between `<head>` and `</head>` of all of your templates/pages.

      <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>

   Note: if you are linking directly to Google Code as the above example does, then you
   will not need to download jQuery separately.

2. Unpack the FacebookCommenters archive.

3. Copy the contents of FacebookCommenters/mt-static into /path/to/mt/mt-static/

4. Copy the contents of FacebookCommenters/plugins into /path/to/mt/plugins/

5. Login to your Movable Type Dashboard which will install the plugin.

6. Navigate to the Plugin Settings on the blog you wish to integrate Facebook Connect.

7. Create a Facebook Application to represent your site.
    1. Go to http://www.facebook.com/developers/editapp.php to create a new application.
    2. Enter a name for your application in the Application Name field.
    3. Click the Optional Fields link to see more entry fields.
    4. Keep all of the defaults, except enter a Callback URL. This URL should point to
    the top-level directory of the site which will be implementing Facebook Connect
    (this is usually your domain, e.g. http://www.example.com, but could also be a
    subdirectory).
    5. You should include a logo that appears on the Facebook Connect dialog. Next to
    Facebook Connect Logo, click Change your Facebook Connect logo and browse to an
    image file. The logo can be up to 99 pixels wide by 22 pixels tall, and must be
    in JPG, GIF, or PNG format.
    6. Click Submit to save your changes.
    7. Take note of the API Key and Secret as you'll need these shortly.

8. Within your blog's Plugin Settings, input the API Key and Secret from Facebook.

9. Edit your templates to include Facebook Connect tags and customize the display.

10. Enable "Facebook" as a Registration Authentication Method via
Preferences -> Registration and ensure that User Registration is allowed.

11. Republish your blog for all of the changes to take effect.

## Template Code

### Embedding the Javascript into the Header

To add basic support for Facebook Connect, you will need to add a non-trivial amount of Javascript into the HTML `<head>` of your web page. You have two choices in how to do this: the first is quick and easy and what most people should do, the second is designed for people who need to specify javascript manually. 

**Using the GreetFacebookCommenters Slug (recommended)**

A single template tag can be added to the HTML `<head>` of your web site. This one simple tag will output all the javascript the average Movable Type user will need. It is designed to work with Movable Type's default javascript.

    <$mt:GreetFacebookCommenters$>

**Hand Coding the Javascript**

Some users who prefer to hand edit their javascript code, or integrate with another toolkit like jQuery can use some derivative of the following javascript code fragment.

    <script type="text/javascript">
    /* <![CDATA[ */
    window.api_key = '<$mt:FacebookApplicationID$>';
    window.xd_receiver_url = '<$mt:StaticWebPath$>plugins/FacebookCommenters/xd_receiver.html';
    function facebook_send_story() {
      send_story('<$mt:EntryPermalink$>','<$mt:EntryTitle encode_js="1"$>','<$mt:FacebookStoryTemplateID$>');
    }
    $(document).ready( function () {
      if ( window.location.hash && window.location.hash.match( /^#_logout/ ) ) {
        facebook_logout();
        return;
      }
      apply_commenter_data();
    });
    /* ]]> */
    </script>
    <script type="text/javascript" src="http://static.ak.connect.facebook.com/js/api_lib/v0.4/FeatureLoader.js.php"></script>
    <script type="text/javascript" src="<$mt:StaticWebPath$>plugins/FacebookCommenters/fbconnect.js"></script>
    <script type="text/javascript" src="<$mt:StaticWebPath$>plugins/FacebookCommenters/signface.js"></script>

### Displaying Facebook Profile Userpics

To display a Facebook user's profile photo next to their comment, you will have to use a Comment Detail template which includes userpics.  The following template should work in most cases and http://www.movabletype.org/documentation/designer/publishing-comments-with-userpics.html is a useful guide to adding userpics to your templates.

    <div class="comment"<mt:IfArchiveTypeEnabled archive_type="Individual"> id="comment-<$mt:CommentID$>"</mt:IfArchiveTypeEnabled>>
        <div class="inner">
            <div class="comment-header">
                <div class="user-pic<mt:If tag="CommenterAuthType" eq="Facebook"> comment-fb-<$mt:CommenterUsername$></mt:If>">
    
                <mt:If tag="CommenterAuthType" eq="Facebook">
                    <a href="http://www.facebook.com/profile.php?id=<$mt:CommenterUsername$>" class="auth-icon"><img src="<$mt:CommenterAuthIconURL size="logo_small"$>" alt="<$mt:CommenterAuthType$>"/></a>
                    <fb:profile-pic uid="<$mt:CommenterUsername$>" size="square" linked="true"><img src="http://static.ak.connect.facebook.com/pics/q_default.gif" /></fb:profile-pic>
    
                <mt:Else>
                    <mt:If tag="CommenterAuthIconURL">
                        <a href="<$mt:CommenterURL$>" class="auth-icon"><img src="<$mt:CommenterAuthIconURL size="logo_small"$>" alt="<$mt:CommenterAuthType$>"/></a>
                    </mt:If>
                    <img src="<$mt:StaticWebPath$>images/default-userpic-50.jpg" />
                </mt:If>
                </div>
    
                <div class="asset-meta">
                    <span class="byline">
                    <mt:If tag="CommenterAuthType" eq="Facebook">
                        By <span class="vcard author"><fb:name uid="<$mt:CommenterUsername$>" linked="true" useyou="false"><a href="http://www.facebook.com/profile.php?id=<$mt:CommenterUsername$>"><$mt:CommenterName$></a></fb:name></span> on <a href="#comment-<$mt:CommentID$>"><abbr class="published" title="<$mt:CommentDate format_name="iso8601"$>"><$mt:CommentDate$></abbr></a></span>
    
                    <mt:Else>
                        By <span class="vcard author"><mt:If tag="CommenterURL"><a href="<$mt:CommenterURL$>"><$mt:CommentAuthor default_name="Anonymous" $></a><mt:Else><$mt:CommentAuthorLink default_name="Anonymous" show_email="0"$></mt:If></span><mt:IfNonEmpty tag="CommentAuthorIdentity"><$mt:CommentAuthorIdentity$></mt:IfNonEmpty> on <a href="#comment-<$mt:CommentID$>"><abbr class="published" title="<$mt:CommentDate format_name="iso8601"$>"><$mt:CommentDate$></abbr></a></span>
                    </mt:If>
                    </span>
                </div>
            </div>
            <div class="comment-content">
                <$mt:CommentBody$>
            </div>
        </div>
    </div>

The plugin's root directory also has an example file `comment_detail.mtml.example`, which is the default Comment Detail template module of the Community Blog template set included in MT 4.23 that also has the functionality to add Facebook userpics described above.  If you are using the default template module without any changes, you can overwrite `/path/to/mt/addons/Community.pack/templates/blog/comment_detail.mtml` with this file, and refresh the template from the Template Listing screen.

## Styles

While you don't need to customize any of the CSS styles, there are many CSS classes which can be tweaked to adjust the display of comments.

    .comment-friend {
        background-color: #c3cddf;
    }

