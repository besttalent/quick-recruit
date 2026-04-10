class SendEmail < Patterns::Service
  MAILER_ACTIONS_BY_KIND = {
    "rejection_email" => :rejection_email,
    "about_us_email" => :about_us_email,
    "about_us_and_jd_email" => :about_us_and_jd_email,
    "job_description_email" => :job_description_email,
    "not_a_match_email" => :not_a_match_email,
    "f2f_detail_email" => :f2f_detail_email,
    "position_closed_email" => :position_closed_email,
    "send_resume_email" => :send_resume_email,
  }.freeze

  def initialize(candidate, kind, actor)
    @candidate = candidate
    @email = Email.new
    @actor = actor
    @kind = kind
  end

  def call
    create_email
    send_email
    add_event

    email
  end

  private

  def create_email
    email.assign_attributes(
      candidate: candidate,
      user: actor,
      kind: Email.kinds[kind],
    )
    email.save!
    candidate.touch
  end

  def send_email
    action = MAILER_ACTIONS_BY_KIND[kind]
    return if action.blank?

    CandidateMailer.with(candidate: candidate).public_send(action).deliver_later
  end

  def add_event
    Event.create!(
      eventable: candidate,
      action: "send_email",
      action_for_context: "sent an email with subject",
      trackable: email,
      user: actor,
    )
  end

  attr_reader :candidate, :email, :actor, :kind
end
