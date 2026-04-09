import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        this.onClick = this.onClick.bind(this)
        this.onKeyDown = this.onKeyDown.bind(this)

        this.element.addEventListener("click", this.onClick)
        document.addEventListener("keydown", this.onKeyDown)
    }

    disconnect() {
        this.element.removeEventListener("click", this.onClick)
        document.removeEventListener("keydown", this.onKeyDown)
    }

    onClick(event) {
        const trigger = event.target.closest("[data-dropdown-toggle]")

        if (trigger) {
            event.preventDefault()

            const menu = this.menuFor(trigger)
            if (!menu) return

            const willOpen = menu.classList.contains("hidden")
            this.hideAll()
            this.setVisible(menu, willOpen)
            return
        }

        if (this.clickedInsideAnyMenu(event.target)) return

        this.hideAll()
    }

    onKeyDown(event) {
        if (event.key === "Escape") this.hideAll()
    }

    menuFor(trigger) {
        const id = trigger.dataset.dropdownToggle
        if (!id) return null

        return document.getElementById(id)
    }

    allMenus() {
        return Array.from(document.querySelectorAll("[data-dropdown-toggle]"))
            .map((trigger) => this.menuFor(trigger))
            .filter(Boolean)
    }

    clickedInsideAnyMenu(target) {
        return this.allMenus().some((menu) => menu.contains(target))
    }

    setVisible(menu, visible) {
        menu.classList.toggle("hidden", !visible)
    }

    hideAll() {
        this.allMenus().forEach((menu) => menu.classList.add("hidden"))
    }
}
