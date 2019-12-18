jQuery(document).ready(function($) {
  "use strict";

  $(window).ready( function() {
    var $content = $('.article-content');
    $content.html(articleContent['body'])
    var $title = $('.article-title');
    $title.html(articleContent['title'])
    var $pubname = $('.publisher-name');
    $pubname.html(articleContent['publisher_name'])
    var $pubdate = $('.publication-date');
    $pubdate.html(moment(articleContent['publication_datetime']).format('llll'))
    generateNewsSection('related', '.related-news', MaxRelatedNews)
  });

});
