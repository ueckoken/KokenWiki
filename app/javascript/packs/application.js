/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
//console.log('Hello World from Webpacker')
// Support component names relative to this directory:
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import "bootstrap"
import { Toast } from "bootstrap"
var componentRequireContext = require.context("components", true)
var ReactRailsUJS = require("react_ujs")

Rails.start()
Turbolinks.start()
ActiveStorage.start()

ReactRailsUJS.useContext(componentRequireContext)

// ref: https://github.com/reactjs/react-rails#event-handling
// If Turbolinks is imported via Webpacker (and thus not available globally),
// ReactRailsUJS will be unable to locate it.
// To fix this, you can temporarily add it to the global namespace:
globalThis.Turbolinks = Turbolinks
ReactRailsUJS.detectEvents()
delete globalThis.Turbolinks

// 「クロップボードにコピーされました」を出す
document.addEventListener("turbolinks:load", () => {
    const $toast = document.getElementById("clipboard-copy-toast")
    const toast = new Toast($toast)
    document.addEventListener("clipboard-copy", () => {
        toast.show()
    })
})
