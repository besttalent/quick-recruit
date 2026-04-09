import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from "@rails/request.js"

export default class extends Controller {
    async update_owner({ params }) {
        return this.patchCandidate(params.candidate, "update/owner", { owner_id: params.owner })
    }

    async update_bucket({ params }) {
        return this.patchCandidate(params.candidate, "update/bucket", { bucket: params.bucket })
    }

    async update_status({ params }) {
        return this.patchCandidate(params.candidate, "update/status", { status: params.status })
    }

    async update_campaign({ params }) {
        return this.patchCandidate(params.candidate, "update/campaign", { campaign_id: params.campaign })
    }

    async toggle_recycle({ params }) {
        return this.patchCandidate(params.candidate, "toggle/recycle", { status: params.candidate })
    }

    async patchCandidate(candidateId, path, payload) {
        const request = new FetchRequest("patch", `/candidates/${candidateId}/${path}`, {
            body: JSON.stringify(payload),
            responseKind: "turbo-stream",
        })

        try {
            await request.perform()
        } catch (error) {
            console.error(`Candidate request failed: ${path}`, error)
        }
    }

}
