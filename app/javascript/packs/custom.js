$(function(){
  $('.star_rating').raty({
    score: function() {
    return $(this).attr('rating-data');
    },
    readOnly : true,
    number   : 5,  
    half     : true,
    size     : 24,
    starHalf : '/assets/star-half.png',
    starOff  : '/assets/star-off.png',
    starOn   : '/assets/star-on.png',
  });
});

$(function(){
  $('.new_star_rating').raty({
    number   : 5,  
    half     : false,
    precision:   false,
    size     : 24,
    starHalf : '/assets/star-half.png',
    starOff  : '/assets/star-off.png',
    starOn   : '/assets/star-on.png',
    target: '#hint1',
    targetType: 'number',
    round:  { down: .25, full: .6, up: .76 },
    click: function(score, evt) {
      $("#review_rate").val(score);
    }
  });
});



$('.button-collapse').sideNav({
  menuWidth: 160,
  edge: 'right', // Choose the horizontal origin
});
