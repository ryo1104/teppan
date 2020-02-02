// console.log("Hello customscripts");
// var tags =[];
// var alldata = {
//     'Apple': null,
//     'Microsoft': null,
//     'Google': null
// }

// $('.chips-autocomplete').chips({
//   autocompleteOptions: {
//     data: alldata,
//     limit: Infinity,
//     minLength: 1,
//   },
//   placeholder: 'Enter a tag',
//   secondaryPlaceholder: '+Tag',
//   onChipAdd: function(e, chip){
//       var item = chip.childNodes[0].textContent;
//       if(alldata[item] !== null){
//           $('.chips-autocomplete .chip').last().remove();
//       }
//       else{
//           tags.push(item);
//           $('#tags').val(tags);
//       }
//   },
//   onChipDelete: function(e, chip){
//       var item = chip.childNodes[0].textContent;
//       tags = $.grep(tags, function(value) {
//           return value != item;
//       });
//       $('#tags').val(tags);
//   }
// });
