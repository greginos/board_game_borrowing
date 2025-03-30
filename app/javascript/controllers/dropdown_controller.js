import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    // Fermer le menu si on clique en dehors
    document.addEventListener("click", this.closeMenu.bind(this))
  }

  disconnect() {
    document.removeEventListener("click", this.closeMenu.bind(this))
  }

  toggleMenu(event) {
    event.stopPropagation()
    this.menuTarget.classList.toggle("show")
  }

  closeMenu(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.remove("show")
    }
  }
} 