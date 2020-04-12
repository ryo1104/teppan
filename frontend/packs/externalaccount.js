import $ from 'jquery';

$('#test_bank_input').on('input', function(event) {
  console.log("entry autocomplete....")
//   $('#bank_post_field2').autocomplete({
//       source: function( req, res ) {
//           $.ajax({
//               url: `/externalaccounts/bank_search_autocomplete?keyword=${encodeURIComponent(req.term)}`,
//               type: 'GET',
//               dataType: "json",
//               success: function( data ) {
//                   console.log("result :" + res(data))
//                   res(data);
//               }
//           });
//       },
//       autoFocus: true,
//       delay: 500,
//       minLength: 2
//   });
});