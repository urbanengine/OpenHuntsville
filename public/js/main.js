$(document).ready(function() {
	$(".fancybox").fancybox({
		width	: 600,
		helpers : {
			title : {
				type : 'over'
			},
			overlay : {
				css : {
					'background' : 'rgba(0, 0, 0, 0.7)'
				}
			}
		}
	});
	$(".feedback").fancybox({
		maxWidth	: 610,
		maxHeight	: 600,
		helpers : {
			overlay : {
				css : {
					'background' : 'rgba(0, 0, 0, 0.7)'
				}
			}
		}
	});
	$(function () {
		if ($('.parentcats').length)
		{
			$('.parentcats').tinyNav({
				active: 'selected'
			});
		}
	});
	$('html').addClass('js');
	$(function() {
		if ($('.parentcats').length)
		{
			$( ".parentcats" ).accordion({
				collapsible: true
			});
		}
	});
	$( ".contactme" ).click(function() {
		$(this).next( ".links" ).slideToggle( "300" );
	});
});
