import M from 'materialize-css';

document.addEventListener('DOMContentLoaded', function() {
  // var modal_elems = document.querySelectorAll('.modal');
  // M.Modal.init(modal_elems, {});
  
  var sidenav_elems = document.querySelectorAll('.sidenav');
  M.Sidenav.init(sidenav_elems, { edge : 'right' });
});

// $(function() {
//   $(".top-page__subtitle").css({ 
//     "color":"#ff9800",
//     "font-size":"20px"
//     });
// });
