// app/javascript/controllers/countdown_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    until: String,
    urgentThreshold: Number,   // in milliseconds
    warningThreshold: Number,  // in milliseconds
    bookingId: Number
  }

  connect() {
    console.log("✅ Countdown connected:", this.element, "until:", this.untilValue)

    if (!this.untilValue) {
      this.element.textContent = "No return time set"
      return
    }

    this.targetTime = new Date(this.untilValue).getTime()
    if (isNaN(this.targetTime)) {
      this.element.textContent = "Invalid return time"
      return
    }

    this.update()
    this.timer = setInterval(() => this.update(), 1000)
  }

  disconnect() {
    if (this.timer) {
      clearInterval(this.timer)
      this.timer = null
    }
  }

  update() {
    const now = Date.now()
    const distance = this.targetTime - now

    if (distance <= 0) {
      this.element.textContent = "Time's up!"
      this.element.classList.remove("text-orange-600", "text-red-600", "font-bold", "font-semibold")
      this.element.classList.add("text-gray-500")
      this.disconnect()
      return
    }

    const days = Math.floor(distance / (1000 * 60 * 60 * 24))
    const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))
    const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60))
    const seconds = Math.floor((distance % (1000 * 60)) / 1000)

    this.element.textContent = `${days}d ${hours}h ${minutes}m ${seconds}s`

    this.element.classList.remove("text-orange-600", "text-red-600", "font-bold", "font-semibold")

    if (this.urgentThresholdValue && distance <= this.urgentThresholdValue) {
      this.element.classList.add("text-red-600", "font-bold")
    } else if (this.warningThresholdValue && distance <= this.warningThresholdValue) {
      this.element.classList.add("text-orange-600", "font-semibold")
    }
  }
}
