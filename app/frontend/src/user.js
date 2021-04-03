import $ from 'jquery';
require('load-image')
require('load-image-scale')
require('load-image-meta')
require('load-image-fetch')
require('load-image-orientation')
require('load-image-exif')
require('load-image-exif-map')
require('load-image-iptc')
require('load-image-iptc-map')
require('canvas-to-blob')
require('iframe-transport')
require('jquery.ui.widget')
require('jquery.fileupload')
require('jquery.fileupload-process')
require('jquery.fileupload-image')

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

$(function() {
  $('.user-profile-form').find("input:file").each(function(i, elem){
    var fileInput    = $(elem);
    var form         = $(fileInput.parents('form:first'));
    var submitButton = form.find('input[type="submit"]');
    var progressBar  = $("<div class='bar'></div>");
    var barContainer = $("<div class='progress'></div>").append(progressBar);
    var canvas_width = $('.user-profile-form__avatar-img-wrapper').width();
    var canvas_height = $('.user-profile-form__avatar-img-wrapper').height();
    const MIN_SIZE = 120;
    fileInput.after(barContainer);
    fileInput.fileupload({
      fileInput:       fileInput,
      url:             form.data('url'),
      type:            'POST',
      autoUpload:       true,
      formData:         form.data('form-data'),
      paramName:        'file', // S3 does not like nested name fields i.e. name="user[avatar_url]"
      dataType:         'XML',  // S3 returns XML if success_action_status is set to 201
      replaceFileInput: false,
      disableImageResize: /Android(?!.*Chrome)|Opera/
          .test(window.navigator && navigator.userAgent),
      imageMaxWidth: 120,
      imageMaxHeight: 120,
      imageCrop: true, // Force cropped images
      progressall: function (e, data) {
        var progress = parseInt(data.loaded / data.total * 100, 10);
        progressBar.css('width', progress + '%')
      },
      start: function (e) {
        submitButton.prop('disabled', true);
        progressBar.
          css('background', 'green').
          css('display', 'block').
          css('width', '0%').
          text("Loading...");
      },
      done: function(e, data) {
        submitButton.prop('disabled', false);
        progressBar.text("Uploading done");

        if (data.files && data.files[0]){

          // Show the image
          var file = e.target.files[0];
          var reader = new FileReader();
          var canvas = document.getElementById('js-user-avatar-canvas');
          canvas.setAttribute('width', canvas_width);
          canvas.setAttribute('height', canvas_height);
          var context = canvas.getContext('2d');
          reader.onload = function(file){
            return function(e){
              var prv_img = new Image();
              prv_img.src = e.target.result;
              prv_img.onload = function() {
                var dstWidth, dstHeight;
                if (this.width > this.height) {
                  dstWidth = MIN_SIZE;
                  dstHeight = this.height * MIN_SIZE / this.width;
                } else {
                  dstHeight = MIN_SIZE;
                  dstWidth = this.width * MIN_SIZE / this.height;
                }
                canvas.width = dstWidth;
                canvas.height = dstHeight;
                context.drawImage(this, 0, 0, this.width, this.height, 0, 0, dstWidth, dstHeight);
              }
            };
          }(file);
          reader.readAsDataURL(file);
        }

        // extract key and generate URL from response, and send file url to rails
        var key   = $(data.jqXHR.responseXML).find("Key").text();
        var url   = '//' + form.data('host') + '/' + key;
        console.log('url = '+url)
        console.log('param key = '+fileInput.attr('name'))
        var input = $("<input />", { type:'hidden', name: fileInput.attr('name'), value: url })
        form.append(input);
        document.getElementById("js-user-avatar-file_field").style.display="none";
      },
      fail: function(e, data) {
        submitButton.prop('disabled', false);
        progressBar.css("background", "red").text("Failed");
      },
    });
  });
});