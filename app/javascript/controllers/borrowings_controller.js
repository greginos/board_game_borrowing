import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "title"]

  connect() {
    // Fermer le menu par défaut
    this.contentTarget.style.maxHeight = "0"
    this.titleTarget.classList.add("collapsed")
  }

  toggle() {
    const isCollapsed = this.contentTarget.style.maxHeight === "0px" || !this.contentTarget.style.maxHeight
    this.contentTarget.style.maxHeight = isCollapsed ? this.contentTarget.scrollHeight + "px" : "0"
    this.titleTarget.classList.toggle("collapsed")
  }
} 