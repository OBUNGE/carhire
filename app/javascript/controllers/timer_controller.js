import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="timer"
export default class extends Controller {
  static targets = ["output"]
  static values = { startTime: String } // store as ISO timestamp

  connect() {
    console.log("⏱️ Timer connected:", this.startTimeValue) // 👈 First thing that runs

    // Parse the provided start time
    this.start = new Date(this.startTimeValue)
    this.update()
    this.interval = setInterval(() => this.update(), 1000)
  }

  disconnect() {
    clearInterval(this.interval)
  }

  update() {
    const now = new Date()
    let diff = Math.floor((now - this.start) / 1000) // seconds since start
    const hours = String(Math.floor(diff / 3600)).padStart(2, "0")
    diff %= 3600
    const minutes = String(Math.floor(diff / 60)).padStart(2, "0")
    const seconds = String(diff % 60).padStart(2, "0")

    this.outputTarget.textContent = `${hours}:${minutes}:${seconds}`
  }
}
