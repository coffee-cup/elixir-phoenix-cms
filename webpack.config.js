const WebpackNotifierPlugin = require('webpack-notifier');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

const webpack = require('webpack');
const path = require('path');

require('dotenv').config({
  path: './.env.client'
});

// These environment variables are sent to the client
const envVars = ['WEBSOCKET_URL'];

const isProd = process.env.NODE_ENV === 'production';
console.log(
  isProd ? 'Building for Production ⚡️' : 'Building for Development 💃'
);

const config = {
  entry: {
    app: './assets/js/app.js',
    form: './assets/js/form.js'
  },

  output: {
    path: path.join(__dirname, '/priv/static'),
    filename: '[name].js'
  },

  watch: !isProd,
  watchOptions: {
    ignored: /node_modules/
  },

  module: {
    loaders: [
      {
        test: /\.js$/,
        enforce: 'pre',
        loaders: ['eslint-loader'],
        exclude: [/node_modules/]
      },
      {
        test: /\.js$/,
        exclude: [/node_modules/],
        loaders: ['babel-loader']
      },
      {
        test: /\.(css|scss)$/,
        loader: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: [
            'css-loader',
            {
              loader: 'postcss-loader',
              options: {
                config: { path: './postcss.config.js' }
              }
            },
            'sass-loader'
          ]
        })
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loaders: {
          loader: 'url-loader',
          options: {
            limit: 10000,
            mimetype: 'application/font-woff'
          }
        }
      },
      {
        test: /\.ttf(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'url-loader',
        options: {
          limit: 10000,
          mimetype: 'application/octet-stream'
        }
      },
      {
        test: /\.eot(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'file-loader'
      },
      {
        test: /\.svg(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'url-loader',
        options: {
          limit: 10000,
          mimetype: 'image/svg+xml'
        }
      }
    ]
  },

  plugins: [
    new ExtractTextPlugin('app.css'),
    new CopyWebpackPlugin([{ from: './assets/static' }]),
    new webpack.LoaderOptionsPlugin({
      options: {
        noParse: [/\.elm$/]
      }
    }),
    new webpack.EnvironmentPlugin(envVars)
  ]
};

if (isProd) {
  config.devServer = {};
  config.devtool = '';
  config.plugins = config.plugins.concat([
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: JSON.stringify('production')
      }
    }),
    new webpack.optimize.UglifyJsPlugin({
      compressor: {
        warnings: false
      }
    }),
    new webpack.LoaderOptionsPlugin({
      minimize: true
    })
  ]);
} else {
  config.devtool = 'inline-source-map';
  config.plugins = config.plugins.concat([new WebpackNotifierPlugin()]);
  config.performance = {
    hints: false
  };
}

module.exports = config;
