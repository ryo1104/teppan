import $ from 'jquery';
require('raty-js')

const halfStar  = "/packs/images/star-half.png"
const offStar   = "/packs/images/star-off.png"
const onStar    = "/packs/images/star-on.png"

$('.js-neta-index__star').raty({
  score: function() {
    return $(this).attr('rating-data');
  },
  readOnly : true,
  number   : 5,  
  half     : true,
  size     : 24,
  starHalf : halfStar,
  starOff  : offStar,
  starOn   : onStar,
});

$('.js-topics-index__star').raty({
  score: function() {
    return $(this).attr('rating-data');
  },
  readOnly : true,
  number   : 5,  
  half     : true,
  size     : 24,
  starHalf : halfStar,
  starOff  : offStar,
  starOn   : onStar,
});

$('.js-user-show-profile__star').raty({
  score: function() {
    return $(this).attr('rating-data');
  },
  readOnly : true,
  number   : 5,  
  half     : true,
  size     : 24,
  starHalf : halfStar,
  starOff  : offStar,
  starOn   : onStar,
});

$('.js-follow-list__star').raty({
  score: function() {
    return $(this).attr('rating-data');
  },
  readOnly : true,
  number   : 5,  
  half     : true,
  size     : 24,
  starHalf : halfStar,
  starOff  : offStar,
  starOn   : onStar,
});

$('.js-review-index__star').raty({
  score: function() {
    return $(this).attr('rating-data');
  },
  readOnly : true,
  number   : 5,  
  half     : true,
  size     : 24,
  starHalf : halfStar,
  starOff  : offStar,
  starOn   : onStar,
});

$('.js-review-new__star').raty({
  number   : 5,  
  half     : false,
  precision:   false,
  // size     : 32,
  hints: ['1 : どゆこと？', '2 : つまらん', '3 : 面白い', '4 : ワロタ！', '5 : 殿堂入り！'],
  starHalf : halfStar,
  starOff  : offStar,
  starOn   : onStar,
  target: '#hint1',
  targetType: 'hint',
  targetKeep:  true,
  round:  { down: .25, full: .6, up: .76 },
  click: function(score, evt) {
    $("#reviewnew__rate").val(score);
  }
});