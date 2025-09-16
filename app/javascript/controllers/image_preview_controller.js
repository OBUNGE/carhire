import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image-preview"
export default class extends Controller {
  static targets = ["dropzone", "preview"]

  highlight(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.add("border-blue-500")
  }

  unhighlight(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.remove("border-blue-500")
  }

  drop(event) {
    event.preventDefault()
    this.unhighlight(event)
    const files = event.dataTransfer.files
    this.handleFiles(files)
  }

  preview(event) {
    const files = event.target.files
    this.handleFiles(files)
  }

  handleFiles(files) {
    Array.from(files).forEach(file => {
      if (!file.type.startsWith("image/")) return
      this.resizeImage(file, 300, 300).then(dataUrl => {
        const img = document.createElement("img")
        img.src = dataUrl
        img.className = "rounded-lg w-full h-auto object-cover"
        this.previewTarget.appendChild(img)
      })
    })
  }

  resizeImage(file, maxWidth, maxHeight) {
    return new Promise(resolve => {
      const reader = new FileReader()
      reader.onload = event => {
        const img = new Image()
        img.onload = () => {
          const canvas = document.createElement("canvas")
          canvas.width = maxWidth
          canvas.height = maxHeight
          const ctx = canvas.getContext("2d")
          ctx.drawImage(img, 0, 0, maxWidth, maxHeight)
          resolve(canvas.toDataURL(file.type))
        }
        img.src = event.target.result
      }
      reader.readAsDataURL(file)
    })
  }
}
