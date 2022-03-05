const path = require("path")
const webpack = require("webpack")
// Extracts CSS into .css file
const MiniCssExtractPlugin = require("mini-css-extract-plugin")

module.exports = {
  mode: "production",
  devtool: "source-map",
  entry: {
    application: "./app/javascript/application.js",
  },
  output: {
    path: path.resolve(__dirname, "app/assets/builds"),
  },
  resolve: {
    extensions: [".js", ".jsx", ".ts", ".tsx", ".scss", ".css"]
  },
  module: {
    rules: [
      { test: /\.[tj]sx?$/, exclude: /node_modules/, use: ["babel-loader"] },
      { test: /\.s[ac]ss$/i, use: [MiniCssExtractPlugin.loader, "css-loader", "sass-loader"], },
    ],
  },
  plugins: [
    new MiniCssExtractPlugin(),
  ]
}
