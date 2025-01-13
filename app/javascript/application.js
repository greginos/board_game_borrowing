// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "jquery"
import "./components/board_game"
import "@popperjs/core"
import "bootstrap"
import { Application } from "@hotwired/stimulus";
import BarcodeScannerController from "./controllers/barcode_scanner_controller";

const application = Application.start();
application.register("barcode-scanner", BarcodeScannerController);