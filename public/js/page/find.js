$(function() {
	$( "#nav" ).accordion({
		collapsible: true
	});
});
// When any a in the navigation is clicked, evaluate this function
$('.sidebar #nav a').click(function(){
	// The text of the link
	var text = $( this ).text();
	// If another is selected, get an array of all of the profiles/entities
	var $entityArray = $('.entity').toArray();
	if (text.toUpperCase().indexOf("ALL") != -1)
	{
		// If "All" is selected, show all
		$($entityArray).removeClass('hide',700);
	}
	else
	{
		// For each of the categories that were listed for each of the profiles
		$('.entity .categories li a').each(function(){
			// If the text of the link is the same as the navigation link selected
			if (text.toUpperCase() == $(this).text().toUpperCase())
			{
				// Find the closest ancestor with the .entity class
				var myProfile = $(this).closest('.entity');
				// Remove it from the array
				$entityArray = $.grep($entityArray, function(value) {
				  return  value.innerHTML != myProfile[0].innerHTML;
				});
			}
		});
		// Finally, hide every element in the array of profiles without the search string
		$($entityArray).addClass('hide',700);
	}
});