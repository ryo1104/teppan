require('jquery-jpostal-ja');

$(function () {
	$('#js-zip').jpostal({
		postcode : [
			'#js-zip'
		],
		address : {
      "#js-prefecture"         : "%3",
      "#js-address_city"       : "%4",
      "#js-address_town"       : "%5"
		}
	});
});