import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["feedback"]
  static values = { text: String }

  copy() {
    const text = this.textValue || this.element.getAttribute("data-copy-text") || ""

    navigator.clipboard.writeText(text).then(() => {
      this.showFeedback()
    }).catch(() => {
      // Fallback for older browsers or when clipboard is unavailable
      this.fallbackCopy(text)
    })
  }

  fallbackCopy(text) {
    const textarea = document.createElement("textarea")
    textarea.value = text
    textarea.style.position = "fixed"
    textarea.style.opacity = "0"
    document.body.appendChild(textarea)
    textarea.select()
    try {
      document.execCommand("copy")
      this.showFeedback()
    } catch (e) {
      // Silent failure — clipboard unavailable
    }
    document.body.removeChild(textarea)
  }

  showFeedback() {
    if (this.hasFeedbackTarget) {
      this.feedbackTarget.classList.remove("hidden")
      this.feedbackTarget.classList.add("inline-block")
      setTimeout(() => {
        this.feedbackTarget.classList.add("hidden")
        this.feedbackTarget.classList.remove("inline-block")
      }, 2000)
    }
  }
}
