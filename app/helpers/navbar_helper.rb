module NavbarHelper
  def navbar_variant_for(user)
    return "admin" if user.admin? || user.super_admin?
    return "recruiter" if user.recruiter?
    return "data" if user.data?
    return "interviewer" if user.interviewer?
    return "recruiter_admin" if user.recruiter_admin?

    "default"
  end
end
