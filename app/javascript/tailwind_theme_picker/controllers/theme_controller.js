/*
  TailwindThemePicker Stimulus controller.

  Persists user choice in TWO cookies (theme, mode) so the server can render the
  matching classes on <html> before any JS runs. localStorage is kept as a tab-local
  cache so cross-tab updates and offline still work.

  If you change cookie names here, update TailwindThemePicker::Configuration and any
  FOUC script the host emits.
*/

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static values = {
    themes: { type: Array, default: [] },
    defaultTheme: { type: String, default: "" },
    theme: { type: String, default: "" },
    darkMode: { type: Boolean, default: false },
    themeCookie: { type: String, default: "theme" },
    modeCookie: { type: String, default: "mode" },
    cookieMaxAge: { type: Number, default: 31536000 }
  }

  static targets = [ "toggle", "panel", "mode" ]

  connect() {
    this.themeValue = this.defaultThemeValue || this.themesValue[0]

    const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches

    // Cookie wins over localStorage (server painted html based on cookie).
    const cookieTheme = this.readCookie(this.themeCookieValue)
    const cookieMode  = this.readCookie(this.modeCookieValue)

    try {
      this.themeValue = cookieTheme || localStorage.getItem("theme") || this.themeValue
      try { localStorage.setItem("theme", this.themeValue) } catch(_) { }

      const storedMode = cookieMode || localStorage.getItem("mode")
      this.darkModeValue = storedMode === null ? prefersDark : storedMode === "dark"
      try { localStorage.setItem("mode", this.darkModeValue ? "dark" : "light") } catch(_) { }
    } catch(_) {}

    if (!this.themesValue.includes(this.themeValue)) this.themeValue = this.defaultThemeValue

    // Backfill cookies in case this is the user's first visit.
    this.writeCookie(this.themeCookieValue, this.themeValue)
    this.writeCookie(this.modeCookieValue, this.darkModeValue ? "dark" : "light")

    this.applyThemeClass(this.themeValue)

    if (this.darkModeValue) {
      document.documentElement.classList.add("dark")
      this.swapIcon(this.modeTarget)
    } else
      document.documentElement.classList.remove("dark")
  }

  togglePanel() {
    this.panelTarget.classList.toggle("hidden")
    this.swapIcon(this.toggleTarget)
  }

  toggleMode() {
    this.darkModeValue = !this.darkModeValue
    document.documentElement.classList.toggle("dark")
    this.swapIcon(this.modeTarget)
    const mode = this.darkModeValue ? "dark" : "light"
    try { localStorage.setItem("mode", mode) } catch(_) { }
    this.writeCookie(this.modeCookieValue, mode)
  }

  choose(event) {
    const name = event.currentTarget.dataset.themeName
    this.applyThemeClass(name)
    this.themeValue = name
    try { localStorage.setItem("theme", name) } catch(_) { }
    this.writeCookie(this.themeCookieValue, name)
  }

  preview(event) {
    this.applyThemeClass(event.currentTarget?.dataset.themeName)
  }

  cancelPreview() {
    this.applyThemeClass(this.themeValue)
  }

  applyThemeClass(theme) {
    document.documentElement.className = document.documentElement.className.replace(/theme-[a-z]+/g, "").trim()
    document.documentElement.classList.add(`theme-${theme}`)
  }

  swapIcon(element) {
    const current = element.innerHTML
    element.innerHTML = element.dataset.icon
    element.dataset.icon = current
  }

  readCookie(name) {
    const match = document.cookie.match(new RegExp("(?:^|; )" + name.replace(/[.$?*|{}()[\]\\\/+^]/g, "\\$&") + "=([^;]*)"))
    return match ? decodeURIComponent(match[1]) : null
  }

  writeCookie(name, value) {
    document.cookie = `${name}=${encodeURIComponent(value)}; path=/; max-age=${this.cookieMaxAgeValue}; SameSite=Lax`
  }

}
