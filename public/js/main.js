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
		$('.parentcats').tinyNav({
			active: 'selected'
		});
	});
	$('html').addClass('js');
	$(function() {
		$( ".parentcats" ).accordion({
			collapsible: true
});
	});
	$( ".contactme" ).click(function() {
		$(this).next( ".links" ).slideToggle( "300" );
	});
});
