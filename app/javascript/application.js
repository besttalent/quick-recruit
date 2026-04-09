// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import 'flowbite'
import "@rails/request.js"


const reinitializeFlowbite = () => {
    if (window.initFlowbite) window.initFlowbite()
}

document.addEventListener("turbo:load", reinitializeFlowbite)
document.addEventListener("turbo:frame-load", reinitializeFlowbite)


import "trix"
import "@rails/actiontext"
