import $ from 'jquery';
require("jquery-ui.autocomplete")

$(function () {
    $(".js-hashtag-index__search-input").autocomplete({
        source: ( req, res ) => {
            $.ajax({
              url: url( req.term ),
              type: 'GET',
              dataType: "json",
              success: ( data ) => {
                  res( items( data ) )
              },
              error: () => {
                  res();
              }
            });
        },
        select: function(event, ui) {
            $('.js-hashtag-index__search-input').val(ui.item.value);
        },
        autoFocus: false,
        delay: 300,
        minLength: 1
    });
});

const url = (query) => {
  return `/hashtags/autocomplete?keyword=${encodeURIComponent(query)}`
};

const items = ( data ) => {
    let dataArray = Object.values(data)
    let newArray = new Array(dataArray[0].length);
    let i = 0;
    dataArray[0].forEach( (target) => {
        let newObject = target.attributes.hashname;
        newArray[i] = newObject;
        i++;
    });
    return newArray;
};