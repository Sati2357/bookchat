// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require jquery.turbolinks
//= require turbolinks
//= require_tree .


$(document).on('turbolinks:load', function(){
	
	$(".topwrapper2_row_content").hover(function(){
      var zoom = $(this).find(".zoom-check");
	  var zoom_normal = $(this).find(".zoom-black");
	  var zoom_hide = $(this).find(".zoom-black-hover");
	  if (zoom.hasClass("open")) {
		  $(zoom).removeClass("open");
		  $(zoom_normal).slideDown();
		  $(zoom_hide).slideUp();
	  } else {
		  $(zoom).addClass("open");
		  $(zoom_normal).slideUp();
		  $(zoom_hide).slideDown();
	  }
    });
	
	$(".teacher_header_name").click(function(){
	 if ($(this).hasClass("active")) {
      $(".sub").slideUp();
      $(".teacher_header_name").removeClass("active");
	  $(this).find("span").text("MENU▼");
    } else {
      $(".sub").slideDown();
      $(".teacher_header_name").addClass("active");
	  $(this).find("span").text("CLOSE✖︎");
    }
	});
	$(".book_comment_writeBTN").click(function(){
		$(".book_commentPost").slideDown();
	});
	$(".book_comment_delete").click(function(){
		$(".book_comment").slideUp();
		$(".read_chapter_content").slideDown();
	});
	$(".reader_comment").click(function(){
		$(".book_comment").slideDown();
		$(".read_chapter_content").slideUp();
	});
	var nowchecked = $('input[name=xxxx]:checked').val();
	$('input[name=back_description]').click(function(){
		if($(this).val() == nowchecked) {
			$(this).prop('checked', false);
			nowchecked = false;
		} else {
			nowchecked = $(this).val();
		}
	});
	$(".reader_centralClick").click(function(){
	    $(".reader_centralClick").removeClass("active");
		$(this).addClass("active");
		var category = $(this).attr("id");
		$(".column-box").slideUp();
     　 $(".reader_centralContent").children("."+ category).slideDown();
	});
});