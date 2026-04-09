import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from "@rails/request.js"

export default class extends Controller {
  async toggleInterviewer(event) {
    const checkbox = event.target
    const userId = checkbox.dataset.userId
    const openingId = checkbox.dataset.openingId
    const checked = checkbox.checked

    try {
      await this.postOpening(openingId, "toggle_interviewer", { user_id: userId, checked })
    } catch (error) {
      checkbox.checked = !checked
      alert("Could not update interviewer selection.")
      console.error("Opening request failed: toggle_interviewer", error)
    }
  }

  async postOpening(openingId, path, payload) {
    const request = new FetchRequest("post", `/openings/${openingId}/${path}`, {
      body: JSON.stringify(payload),
      responseKind: "turbo-stream",
    })

    const response = await request.perform()
    if (!response.ok) throw new Error(`Request failed with status ${response.status}`)
  }
}
