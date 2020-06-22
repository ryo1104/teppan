const glob = require('glob')
const path = require('path')
const webpack = require('webpack')

const MODE = "development";
const enabledSourceMap = MODE === "development";
const ManifestPlugin = require('webpack-manifest-plugin')
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');

const frontend_path = path.join(__dirname, 'app', 'frontend')
const js_entry  = { 
  "application"     : path.join(frontend_path, 'src', 'application.js'),
  "hashtag"         : path.join(frontend_path, 'src', 'hashtag.js'),
  "topic"           : path.join(frontend_path, 'src', 'topic.js'),
  "user"            : path.join(frontend_path, 'src', 'user.js'),
  "account"         : path.join(frontend_path, 'src', 'account.js'),
  "externalaccount" : path.join(frontend_path, 'src', 'externalaccount.js'),
  "trade"           : path.join(frontend_path, 'src', 'trade.js')
}

// const img_path = path.join(frontend_path, 'images')
// const images = glob.sync(path.join(img_path, '**/*.{png,jpg,jpeg,gif,ico}'))
// const img_entry = images.reduce((img_entry, target) => {
//   const asset = path.relative(img_path, target)
//   const ext = path.extname(asset)
//   const asset_name = asset.replace(ext, '')
//   return Object.assign(img_entry, {
//     [asset_name]: target
//   })
// }, {})
// const entry = Object.assign(js_entry, img_entry)

module.exports = {

    mode: MODE, // development に設定するとソースマップ有効でJSファイルが出力される
    context: frontend_path,
    entry: js_entry,
    output: {
      filename: 'js/[name]-[hash].js',
      chunkFilename: 'js/[name]-[hash].chunk.js',
      path: path.resolve(__dirname, 'public/packs'),
      publicPath: '/packs/',
    },
    plugins: [
      new ManifestPlugin({
        fileName: 'manifest.json',
        publicPath: '/packs/',
        writeToFileEmit: true,
      }),
      new MiniCssExtractPlugin({
        filename: 'css/[name]-[hash].css',
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
          'jquery-ui': 'jquery-ui-dist/jquery-ui.min.js'
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