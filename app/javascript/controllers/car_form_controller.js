import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static values = { reorderUrl: String }

  connect() {
    const el = document.getElementById("sortable-images")
    if (el) {
      new Sortable(el, {
        animation: 150,
        handle: ".drag-handle",
        onEnd: () => this.reorder(el)
      })
    }
  }

  reorder(el) {
    const ids = Array.from(el.querySelectorAll(".sortable-item"))
                     .map(item => item.dataset.id)

    fetch(this.reorderUrlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Accept": "application/json"
      },
      body: JSON.stringify({ car_image_ids: ids })
    })
  }

  confirmDelete(event) {
    event.preventDefault()
    const url = event.currentTarget.dataset.url
    if (confirm("Are you sure you want to delete this image?")) {
      fetch(url, {
        method: "DELETE",
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
          "Accept": "application/json"
        }
      }).then(r => {
        if (r.ok) event.currentTarget.closest(".sortable-item").remove()
      })
    }
  }

  setCover(event) {
    event.preventDefault()
    const url = event.currentTarget.dataset.url
    fetch(url, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Accept": "application/json"
      }
    }).then(r => {
      if (r.ok) {
        document.querySelectorAll(".cover-label").forEach(lbl => lbl.remove())
        document.querySelectorAll(".cover-link").forEach(link => link.style.display = "inline")

        const actions = event.currentTarget.closest(".image-actions")
        event.currentTarget.style.display = "none"
        const span = document.createElement("span")
        span.className = "cover-label"
        span.textContent = "Cover ✓"
        actions.prepend(span)
      }
    })
  }
}
