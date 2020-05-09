import $ from 'jquery';

$(document).ready( function() {
  /*初期表示*/
  $('.ChangeElem_Panel').hide();
  $('.ChangeElem_Panel').eq(0).show();
  $('.ChangeElem_Tab').eq(0).addClass('selected');
  /*クリックイベント*/
  $('.ChangeElem_Tab').each(function () {
    $(this).on('click', function () {
      var index = $('.ChangeElem_Tab').index(this);
      $('.ChangeElem_Tab').removeClass('selected');
      $(this).addClass('selected');
      $('.ChangeElem_Panel').hide();
      $('.ChangeElem_Panel').eq(index).show();
    });
  });
});


$('#user-image-upload').change(function(e){
  const file = e.target.files[0];
  const reader = new FileReader();

  if(file.type.indexOf("image") < 0){
    alert("画像ファイルを指定してください。");
    return false;
  }

  reader.onload = (function(file){
    return function(e){
      $("#user-page-image").attr("src", e.target.result);
      $("#user-page-image").attr("title", file.name);
    };
  })(file);
  reader.readAsDataURL(file);
});