import M from 'materialize-css';

document.addEventListener('DOMContentLoaded', function() {
  var sidenav_elems = document.querySelectorAll('.sidenav');
  M.Sidenav.init(sidenav_elems, { edge : 'right' });
});

