function countBio()
{
	var $len = $( '#bio' ).val().length;
	var left = 160 - $len;
	$( '#bio-character-count' ).html(left);
	if (left < 0)
	{
		$( '#bio-character-count' ).parent().addClass("error");
	}
	else
	{
		$( '#bio-character-count' ).parent().removeClass("error");
	}
}
$( document ).ready(function(){
	countBio();
	$( '#bio' ).on("change keyup paste", function(){
		countBio();
	});
});