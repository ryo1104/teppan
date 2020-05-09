$('#header-image-upload').change(function(e){
  const file = e.target.files[0];
  const reader = new FileReader();

  if(file.type.indexOf("image") < 0){
    alert("画像ファイルを指定してください。");
    return false;
  }

  reader.onload = (function(file){
    return function(e){
      $("#header-image").attr("src", e.target.result);
      $("#header-image").attr("title", file.name);
    };
  })(file);
  reader.readAsDataURL(file);
});
