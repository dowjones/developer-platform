const MaxRandomNews = 5
const MaxRelatedNews = 3

var HostUrl = location.protocol + '//' + location.host;

function renderNewsArray(articlesList, maxDisplayItems) {
  var allItems = ''
  var imgIx = 1;
  articlesList.forEach( newsItem => {
    // TODO: Make it more efficient by stopping at the Max value
    if( imgIx <= maxDisplayItems ){
      allItems += `
        <div class="recent-single-post">
          <div class="post-img">
            <a href="/article/` + newsItem['an'] + `">
              <img src="/static/img/blog/` + imgIx + `.jpg" alt="">
            </a>
          </div>
          <div class="pst-content">
            <p><a href="/article/` + newsItem['an'] + `"><strong>` + newsItem["title"].substring(0,50) + `...</strong>
            <br>` + newsItem["body"].replace("<p>", "").replace("</p>", " ").replace("<br>", " ").substring(0,100) + `...</p></a>
          </div>
          <div class="entry-meta">
          <span class="author-meta">
            <i class="fa fa-building-o"></i>
            <span class="publisher-name">` + newsItem['publisher_name'] + `</span>
          </span>
          <span>&nbsp;&nbsp;</span>
          <span><i class="fa fa-calendar-o"></i>
            <span class="publication-date">` + moment(newsItem['publication_datetime']).format('llll') + `</span>
          </span>
        </div>
        </div>
      `
    }
    imgIx += 1;
  });
  return allItems;
}

function generateNewsSection(newsType, newsSectionCSSObj, maxDisplayItems) {
  newsApiUrl = HostUrl + "/api/news/" + newsType;
  var companiesList = getSelectedCompanies();
  var $container = $(newsSectionCSSObj);
  $.ajax({
    type: "GET",
    url: newsApiUrl,
    contentType: "application/json",
    dataType: "json",
    success: function(randomArticles) {
      $container.html(renderNewsArray(randomArticles, maxDisplayItems));
    }
  });
  return [];
}

function getSelectedCompanies() {
  var sec_code_array = [];
  $('.portfolio-grid').find("input[name='pitem']:checked").each( function () {
    sec_code_array.push($(this).val())
  })
  return sec_code_array;
}

function updateAllNewsSections() {
  generateNewsSection('random', '.random-news', MaxRandomNews)
}

function playAudioReader() {
  var $content = $('.audio-reader');
  audioArticleApiUrl = HostUrl + "/api/article/" + articleContent['an'] + "/_audiofilename";
  $.ajax({
    type: "GET",
    url: audioArticleApiUrl,
    contentType: "application/json",
    dataType: "json",
    success: function(audioResp) {
      newContent = '<audio src="/static/article-audio/' + audioResp['filename'] + '" controls autoplay > \
      Your browser does not support the audio element. \
      </audio>';
      $content.html(newContent);
    }
  })
}


(function($) {
  "use strict";

  /*--------------------------
  preloader
  ---------------------------- */
  $(window).on('load', function() {
    var pre_loader = $('#preloader');
    pre_loader.fadeOut('slow', function() {
      $(this).remove();
    });
  });

  /*---------------------
   TOP Menu Stick
  --------------------- */
  var s = $("#sticker");
  var pos = s.position();
  $(window).on('scroll', function() {
    var windowpos = $(window).scrollTop() > 300;
    if (windowpos > pos.top) {
      s.addClass("stick");
    } else {
      s.removeClass("stick");
    }
  });

  /*----------------------------
   Navbar nav
  ------------------------------ */
  var main_menu = $(".main-menu ul.navbar-nav li ");
  main_menu.on('click', function() {
    main_menu.removeClass("active");
    $(this).addClass("active");
  });

  /*----------------------------
   wow js active
  ------------------------------ */
  new WOW().init();

  $(".navbar-collapse a:not(.dropdown-toggle)").on('click', function() {
    $(".navbar-collapse.collapse").removeClass('in');
  });

  //---------------------------------------------
  //Nivo slider
  //---------------------------------------------
  $('#ensign-nivoslider').nivoSlider({
    effect: 'random',
    slices: 15,
    boxCols: 12,
    boxRows: 8,
    animSpeed: 500,
    pauseTime: 5000,
    startSlide: 0,
    directionNav: true,
    controlNavThumbs: false,
    pauseOnHover: true,
    manualAdvance: false,
  });

  /*----------------------------
   Scrollspy js
  ------------------------------ */
  var Body = $('body');
  Body.scrollspy({
    target: '.navbar-collapse',
    offset: 80
  });

  /*---------------------
    Venobox
  --------------------- */
  var veno_box = $('.venobox');
  veno_box.venobox();

  /*----------------------------
  Page Scroll
  ------------------------------ */
  var page_scroll = $('a.page-scroll');
  page_scroll.on('click', function(event) {
    var $anchor = $(this);
    $('html, body').stop().animate({
      scrollTop: $($anchor.attr('href')).offset().top - 55
    }, 1500, 'easeInOutExpo');
    event.preventDefault();
  });

  /*--------------------------
    Back to top button
  ---------------------------- */
  $(window).scroll(function() {
    if ($(this).scrollTop() > 100) {
      $('.back-to-top').fadeIn('slow');
    } else {
      $('.back-to-top').fadeOut('slow');
    }
  });

  $('.back-to-top').click(function(){
    $('html, body').animate({scrollTop : 0},1500, 'easeInOutExpo');
    return false;
  });

  /*--------------------------
    Back to news button
  ---------------------------- */
  $(window).scroll(function() {
    if ($(this).scrollTop() > 0) {
      $('.back-to-news').fadeIn('slow');
    } else {
      $('.back-to-news').fadeOut('slow');
    }
  });

  $('.back-to-news').click(function(){
    parent.history.back();
    return false;
  });

  /*----------------------------
   Parallax
  ------------------------------ */
  var well_lax = $('.wellcome-area');
  well_lax.parallax("50%", 0.4);
  var well_text = $('.wellcome-text');
  well_text.parallax("50%", 0.6);

  /*--------------------------
   collapse
  ---------------------------- */
  var panel_test = $('.panel-heading a');
  panel_test.on('click', function() {
    panel_test.removeClass('active');
    $(this).addClass('active');
  });

  /*---------------------
   Testimonial carousel
  ---------------------*/
  var test_carousel = $('.testimonial-carousel');
  test_carousel.owlCarousel({
    loop: true,
    nav: false,
    dots: true,
    autoplay: true,
    responsive: {
      0: {
        items: 1
      },
      768: {
        items: 1
      },
      1000: {
        items: 1
      }
    }
  });
  /*----------------------------
   isotope active
  ------------------------------ */
  // portfolio start
  $(window).on("load", function() {
    var $container = $('.awesome-project-content');
    $container.isotope({
      filter: '*',
      animationOptions: {
        duration: 750,
        easing: 'linear',
        queue: false
      }
    });
    var pro_menu = $('.project-menu li a');
    pro_menu.on("click", function() {
      var pro_menu_active = $('.project-menu li a.active');
      pro_menu_active.removeClass('active');
      $(this).addClass('active');
      var selector = $(this).attr('data-filter');
      $container.isotope({
        filter: selector,
        animationOptions: {
          duration: 750,
          easing: 'linear',
          queue: false
        }
      });
      return false;
    });

  });
  //portfolio end

  /*---------------------
   Circular Bars - Knob
--------------------- */
  if (typeof($.fn.knob) != 'undefined') {
    var knob_tex = $('.knob');
    knob_tex.each(function() {
      var $this = $(this),
        knobVal = $this.attr('data-rel');

      $this.knob({
        'draw': function() {
          $(this.i).val(this.cv + '%')
        }
      });

      $this.appear(function() {
        $({
          value: 0
        }).animate({
          value: knobVal
        }, {
          duration: 2000,
          easing: 'swing',
          step: function() {
            $this.val(Math.ceil(this.value)).trigger('change');
          }
        });
      }, {
        accX: 0,
        accY: -150
      });
    });
  }

})(jQuery);
