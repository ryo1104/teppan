const glob = require('glob')
const path = require('path')
const webpack = require('webpack')

const MODE = "production";
const enabledSourceMap = MODE === "development";
const { WebpackManifestPlugin } = require('webpack-manifest-plugin')
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');

const frontend_path = path.join(__dirname, 'app', 'frontend')
const js_entry  = { 
  "account"               : path.join(frontend_path, 'src', 'account.js'),
  "actiontext"            : path.join(frontend_path, 'src', 'actiontext.js'),
  "application"           : path.join(frontend_path, 'src', 'application.js'),
  "bankaccount"           : path.join(frontend_path, 'src', 'bankaccount.js'),
  "hashtag-entry"         : path.join(frontend_path, 'src', 'hashtag-entry.js'),
  "hashtag-autocomplete"  : path.join(frontend_path, 'src', 'hashtag-autocomplete.js'),
  "headerimg-direct"      : path.join(frontend_path, 'src', 'headerimg-direct.js'),
  "neta"                  : path.join(frontend_path, 'src', 'neta.js'),
  "topic"                 : path.join(frontend_path, 'src', 'topic.js'),
  "trade"                 : path.join(frontend_path, 'src', 'trade.js'),
  "user"                  : path.join(frontend_path, 'src', 'user.js')
}

module.exports = {

    mode: MODE, // development に設定するとソースマップ有効でJSファイルが出力される
    context: frontend_path,
    entry: js_entry,
    output: {
      filename: 'js/[name]-[contenthash].js',
      chunkFilename: 'js/[name]-[contenthash].chunk.js',
      path: path.resolve(__dirname, 'public/packs'),
      publicPath: '/packs/',
    },
    plugins: [
      new WebpackManifestPlugin({
        fileName: 'manifest.json',
        publicPath: '/packs/',
        writeToFileEmit: true,
      }),
      new MiniCssExtractPlugin({
        filename: 'css/[name]-[contenthash].css',
      }),
      new CleanWebpackPlugin(),
      new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery'
      })
    ],
    resolve: {
      // modules: [ path.resolve(frontend_path, 'images') , 'node_modules'],
      alias: {
          'materialize' : 'materialize-css/dist/js/materialize.min',
          'jquery.ui.widget': 'jquery-ui/ui/widget',
          'load-image': 'blueimp-load-image/js/load-image',
          'load-image-scale': 'blueimp-load-image/js/load-image-scale',
          'load-image-meta': 'blueimp-load-image/js/load-image-meta',
          'load-image-fetch': 'blueimp-load-image/js/load-image-fetch',
          'load-image-orientation': 'blueimp-load-image/js/load-image-orientation',
          'load-image-exif': 'blueimp-load-image/js/load-image-exif',
          'load-image-exif-map': 'blueimp-load-image/js/load-image-exif-map',
          'load-image-iptc': 'blueimp-load-image/js/load-image-iptc',
          'load-image-iptc-map': 'blueimp-load-image/js/load-image-iptc-map',
          'canvas-to-blob': 'blueimp-canvas-to-blob/js/canvas-to-blob.min',
          'iframe-transport': 'blueimp-file-upload/js/jquery.iframe-transport',
          'jquery.fileupload': 'blueimp-file-upload/js/jquery.fileupload',
          'jquery.fileupload-process': 'blueimp-file-upload/js/jquery.fileupload-process',
          'jquery.fileupload-image': 'blueimp-file-upload/js/jquery.fileupload-image',
          'jquery-ui.autocomplete' : 'jquery-ui/ui/widgets/autocomplete'
      }
    },
    // resolveLoader: {
    //   modules: [ path.resolve(__dirname, 'node_modules', 'jquery-ui-dist') , 'node_modules']
    // },
    module: {
      rules: [
        {
          test: /\.(sa|sc|c)ss$/,
          use: [
            "style-loader", // linkタグに出力する機能
            {
              loader: MiniCssExtractPlugin.loader, // CSSファイルを出力する機能
              options: {  
                url: false, // CSS内のurl()メソッドを取り込む
                sourceMap: enabledSourceMap,  // ソースマップの利用有無
                importLoaders: 2  // 0 => no loaders (default);  // 1 => postcss-loader;  // 2 => postcss-loader, sass-loader
              }
            },
            "css-loader?url=false",
            'sass-loader',
          ],
        },
        { 
          test: /\.(jpe?g|png|gif|ico)$/, 
          loader: "file-loader",
          options: {
            name: "[name].[ext]",
            outputPath: 'images',
          },
        },
        {
          test: /\.js$/,
          include: frontend_path,
          use: [
            {
              loader: 'babel-loader',
              options: {
                presets: [['@babel/preset-env', { modules:false }]]
              }
            }
          ]
        }
      ]
    }
}