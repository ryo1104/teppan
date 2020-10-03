import $ from 'jquery';
require("jquery-ui")

$(function () {
    $("#js-bank_name_input").autocomplete({
        source: ( req, res ) => {
            $.ajax({
              url: bank_search_url( req.term ),
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
            $('#js-bank_name_input').val(ui.item.value);
        },
        autoFocus: false,
        delay: 500,
        minLength: 2
    });
});

$(function () {
    if ( $("#js-bank_name_input").val() != null ) {
        $("#js-branch_name_input").autocomplete({
            source: ( req, res ) => {
                $.ajax({
                    url: branch_search_url( $("#js-bank_name_input").val(), req.term ),
                    type: 'GET',
                    dataType: "json",
                    success: ( data ) => {
                        res( items( data ) );
                    },
                    error: () => {
                        res( null );
                    }
                });
            },
            select: function(event, ui) {
                $('#js-branch_name_input').val(ui.item.value);
            },
            autoFocus: false,
            delay: 500,
            minLength: 1
        });
    }
});

const bank_search_url = ( bankName ) => {
   return `/bank_autocomplete?keyword=${encodeURIComponent(bankName)}`
};

const branch_search_url = ( bankName, branchName ) => {
    if ( bankName != null ) {
        return `/branch_autocomplete?bankname=${encodeURIComponent(bankName)}&branchname=${encodeURIComponent(branchName)}`
    }
    else{
        return null
    }
}

const items = ( data ) => {
    let dataArray = Object.values(data)
    let newArray = new Array(dataArray[0].length);
    let i = 0;
    dataArray[0].forEach( (target) => {
        let newObject = target.attributes.name;
        newArray[i] = newObject;
        i++;
    });
    return newArray;
};