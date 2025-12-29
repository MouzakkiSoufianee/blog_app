import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['toggleButton']
  static values = { published: Boolean }

  connect() {
    this.updateToggleButton()
  }

  submitting(event) {
    const form = this.formFrom(event)
    if (form) this.disableButtons(form)
  }

  submitted(event) {
    const form = this.formFrom(event)
    if (form) this.enableButtons(form)

    const fetchResponse = event.detail.fetchResponse
    const succeeded = fetchResponse?.succeeded || fetchResponse?.response?.ok || event.detail.success
    if (!succeeded) return

    this.publishedValue = !this.publishedValue
    this.updateToggleButton()
  }

  updateToggleButton() {
    if (!this.hasToggleButtonTarget) return

    const btn = this.toggleButtonTarget
    if (this.publishedValue) {
      btn.textContent = 'Unpublish'
      btn.classList.add('btn-ghost')
      btn.classList.remove('btn')
    } else {
      btn.textContent = 'Publish now'
      btn.classList.add('btn')
      btn.classList.remove('btn-ghost')
    }
  }

  disableButtons(form) {
    form.querySelectorAll('button').forEach((button) => {
      button.disabled = true
    })
  }

  enableButtons(form) {
    form.querySelectorAll('button').forEach((button) => {
      button.disabled = false
    })
  }

  formFrom(event) {
    return event.target instanceof HTMLFormElement ? event.target : event.target.closest('form')
  }
}