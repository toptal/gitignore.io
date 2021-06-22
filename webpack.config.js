const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = {
  output: {
    path: __dirname + '/Public/assets',
  },
  plugins: [
    new MiniCssExtractPlugin({
      // Options similar to the same options in webpackOptions.output
      // both options are optional
      filename: '[name].css',
      chunkFilename: '[id].css',
    }),
  ],
  module: {
    rules: [
      {
        test: /\.css$/,
        use: [
          {
            loader: MiniCssExtractPlugin.loader,
            options: {
              publicPath: '../Public/assets/',
            },
          },
          'css-loader',
        ],
      },
    ],
  },
};
