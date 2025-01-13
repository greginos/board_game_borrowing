# Pin npm packages by running ./bin/importmap

pin "application"
pin "jquery" # @3.7.1
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "quagga", to: "https://cdn.jsdelivr.net/npm/quagga@0.12.1/dist/quagga.min.js"
