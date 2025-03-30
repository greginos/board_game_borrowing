// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "bootstrap"
import "jquery"
import "quagga"
import "./components/board_game"
import "@popperjs/core"
import { Application } from "@hotwired/stimulus"
import DropdownController from "./controllers/dropdown_controller"

const application = Application.start()
application.register("dropdown", DropdownController)