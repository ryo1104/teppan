import $ from 'jquery';

$(document).ready( function() {
  /*初期表示*/
  $('.js-topic-tab__body').hide();
  $('.js-topic-tab__body').eq(0).show();
  $('.js-topic-tab__link').eq(0).addClass('selected');
  /*クリックイベント*/
  $('.js-topic-tab__link').each(function () {
    $(this).on('click', function () {
      var index = $('.js-topic-tab__link').index(this);
      $('.js-topic-tab__link').removeClass('selected');
      $(this).addClass('selected');
      $('.js-topic-tab__body').hide();
      $('.js-topic-tab__body').eq(index).show();
    });
  });
});

$('.topic-form__header-img-filefield').change(function(e){
  const file = e.target.files[0];
  const reader = new FileReader();

  if(file.type.indexOf("image") < 0){
    alert("画像ファイルを指定してください。");
    return false;
  }

  reader.onload = (function(file){
    return function(e){
      $('.topic-form__header-img-content').attr("src", e.target.result);
      $('.topic-form__header-img-content').attr("title", file.name);
    };
  })(file);
  reader.readAsDataURL(file);
});
