export const TrixEditor = {
  mounted() {
    this.el.addEventListener("trix-change", e => {
      // Force the hidden input to trigger a change event for LiveView
      this.el.previousElementSibling.dispatchEvent(new Event("change", {bubbles: true}))
    })
  }
}
