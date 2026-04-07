class BaseController < ApplicationController
  before_action :authenticate_user!

  include Pagy::Method

  LIMIT = 30

  def pagy_nil_safe(params, collection, vars = {})
    return pagy(:offset, collection, page: params[:page], **vars) if collection.respond_to?(:offset)

    pagy = Pagy::Offset.new(count: collection.size, page: params[:page], **Pagy::OPTIONS.merge(vars))
    [pagy, collection]
  end

  def render_partial(partial, collection:, cached: false)
    respond_to do |format|
      format.html
      format.json {
        render json: { entries: render_to_string(partial: partial, formats: [:html], collection: collection, cached: cached),
                       pagination: render_to_string(partial: "shared/paginator", formats: [:html], locals: { pagy: @pagy }) }
      }
    end
  end

  def render_partial_as(partial, collection:, cached: false, as:)
    respond_to do |format|
      format.html
      format.json {
        render json: { entries: render_to_string(partial: partial, formats: [:html], collection: collection, as: as, cached: cached),
                       pagination: render_to_string(partial: "shared/paginator", formats: [:html], locals: { pagy: @pagy }) }
      }
    end
  end
end
