$(document).ready(function() {
	$(".fancybox").fancybox({
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
		$("#nav").tinyNav();
	});
	$('html').addClass('js');
});