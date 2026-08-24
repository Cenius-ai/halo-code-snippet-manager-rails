import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["lightIcon", "darkIcon"]

  connect() {
    this.applyTheme()
  }

  toggle() {
    const current = document.documentElement.classList.contains("dark")
    if (current) {
      document.documentElement.classList.remove("dark")
      localStorage.setItem("theme", "light")
    } else {
      document.documentElement.classList.add("dark")
      localStorage.setItem("theme", "dark")
    }
    this.updateIcons()
  }

  applyTheme() {
    const stored = localStorage.getItem("theme")
    if (stored === "dark") {
      document.documentElement.classList.add("dark")
    } else if (stored === "light") {
      document.documentElement.classList.remove("dark")
    } else {
      // System preference
      if (window.matchMedia("(prefers-color-scheme: dark)").matches) {
        document.documentElement.classList.add("dark")
      }
    }
    this.updateIcons()
  }

  updateIcons() {
    const isDark = document.documentElement.classList.contains("dark")
    if (this.hasLightIconTarget && this.hasDarkIconTarget) {
      this.lightIconTarget.classList.toggle("hidden", isDark)
      this.darkIconTarget.classList.toggle("hidden", !isDark)
    }
  }
}
