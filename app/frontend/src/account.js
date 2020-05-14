require('jquery-jpostal-ja');

$(function () {
	$('#zip').jpostal({
		postcode : [
			'#zip'
		],
		address : {
      "#prefecture"         : "%3",
      "#address_city"       : "%4",
      "#address_town"       : "%5",
      "#prefecture_kana"    : "%8",
      "#address_city_kana"  : "%9",
      "#address_town_kana"  : "%10"
		}
	});
});