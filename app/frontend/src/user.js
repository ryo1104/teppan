import $ from 'jquery';

$(document).ready( function() {
  /*初期表示*/
  $('.user-show-contents__tab-panel').hide();
  $('.user-show-contents__tab-panel').eq(0).show();
  $('.user-show-contents__tab-index').eq(0).addClass('selected');
  /*クリックイベント*/
  $('.user-show-contents__tab-index').each(function () {
    $(this).on('click', function () {
      var index = $('.user-show-contents__tab-index').index(this);
      $('.user-show-contents__tab-index').removeClass('selected');
      $(this).addClass('selected');
      $('.user-show-contents__tab-panel').hide();
      $('.user-show-contents__tab-panel').eq(index).show();
    });
  });
});


$('.js-user-profile-form__image-upload').change(function(e){
  const file = e.target.files[0];
  const reader = new FileReader();

  if(file.type.indexOf("image") < 0){
    alert("画像ファイルを指定してください。");
    return false;
  }
  
  reader.onload = (function(file){
    return function(e){
      $('.user-edit-form__avatar-img').attr("src", e.target.result);
      $('.user-edit-form__avatar-img').attr("title", file.name);
    };
  })(file);
  reader.readAsDataURL(file);
});