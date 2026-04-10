module ProgressHelper
  STATUS_GROUPS = {
    waiting: ["waiting_for_evaluation"],
    rejected: ["rejected_in_screening", "rejected_in_first_round", "rejected_in_second_round", "not_interested", "rejected_in_hr_round"],
    not_contactable: ["on_hold", "no_show", "not_contactable", "follow_up_needed"],
    pipelined: ["interview_to_be_scheduled", "first_round_scheduled", "second_round_scheduled", "hr_round_scheduled"],
    selected: ["offer_to_be_made", "offer_made", "offer_accepted", "joined"],
    champions: ["offer_withdrawn", "offer_declined"],
  }.freeze

  PROGRESS_COLORS = {
    waiting: "blue",
    rejected: "red",
    not_contactable: "sky",
    pipelined: "yellow",
    selected: "green",
    champions: "fuchsia",
  }.freeze

  def display_campaign_progress(campaign)
    counts = campaign.candidates.reorder("").group(:status).count
    total = counts.values.sum
    return "".html_safe if total.zero?

    bars = STATUS_GROUPS.keys.map do |group|
      width = (group_count(counts, group) / total.to_f) * 100
      content_tag(:div, nil, class: "bg-#{PROGRESS_COLORS[group]}-400 h-1.5", style: "width: #{width}%")
    end

    safe_join(bars)
  end

  def display_campaign_numbers(campaign)
    stats = campaign.candidates.reorder("").group(:status).count.sort_by { |_status, count| count }
    lines = stats.map { |status, count| "#{status.humanize}: #{count}" }
    safe_join(lines, tag.br)
  end

  def display_opening_associations(opening)
    bucket_links_for(Candidate.where(opening: opening.id), "opening_id", opening.id)
  end

  def display_owner_associations(owner)
    bucket_links_for(Candidate.where(owner: owner.id), "owner_id", owner.id)
  end

  private

  def group_count(status_counts, group)
    STATUS_GROUPS.fetch(group).sum { |status| status_counts[status] || 0 }
  end

  def bucket_links_for(scope, filter_key, filter_value)
    links = scope.reorder("").group(:bucket).count.sort_by { |_bucket, count| count }.map do |bucket, count|
      href = "/report/candidates?#{filter_key}=#{filter_value}&bucket=#{ERB::Util.url_encode(bucket.to_s)}"
      link_to("#{count} #{bucket.humanize}", href, class: "link")
    end

    safe_join(links)
  end
end
