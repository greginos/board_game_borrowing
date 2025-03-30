// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "./controllers"
import "bootstrap"
import "jquery"
import "quagga"
import "./components/board_game"
import "@popperjs/core"
import { Application } from "@hotwired/stimulus"
// import BarcodeScannerController from "./controllers/barcode_scanner_controller"
import DropdownController from "./controllers/dropdown_controller"

const application = Application.start()
// application.register("barcode-scanner", BarcodeScannerController)
application.register("dropdown", DropdownController)