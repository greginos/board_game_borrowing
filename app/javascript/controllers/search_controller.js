import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    console.log("Search controller connected")
  }

  search(event) {
    event.preventDefault()
    const searchTerm = this.inputTarget.value
    if (searchTerm.trim()) {
      window.location.href = `/board_games?query=${encodeURIComponent(searchTerm.trim())}`
    } else {
      window.location.href = '/board_games'
    }
  }
} 