const { environment } = require('@rails/webpacker')
const MonacoWebpackPlugin = require('monaco-editor-webpack-plugin')

environment.plugins.prepend(
  'MonacoEditor',
  new MonacoWebpackPlugin({
    languages: ['markdown']
  })
)

module.exports = environment
