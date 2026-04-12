class Account
  module TitleResourceCrud
    extend ActiveSupport::Concern

    included do
      before_action :set_resource, only: %i[edit update destroy]
    end

    def index
      instance_variable_set("@#{collection_name}", resource_class.all)
      instance_variable_set("@#{resource_name}", resource_class.new)
    end

    def edit
    end

    def create
      resource = resource_class.new(resource_params)

      respond_to do |format|
        if resource.save
          format.turbo_stream do
            render turbo_stream: turbo_stream.prepend(collection_name.to_sym, partial: "#{partial_base}/#{resource_name}", locals: resource_locals(resource)) +
                                 turbo_stream.replace(resource_class.new, partial: "#{partial_base}/form", locals: resource_locals(resource_class.new).merge(message: "#{resource_name.humanize} was created successfully."))
          end
        else
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(resource_class.new, partial: "#{partial_base}/form", locals: resource_locals(resource))
          end
        end
      end
    end

    def update
      respond_to do |format|
        if resource.update(resource_params)
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(resource, partial: "#{partial_base}/#{resource_name}", locals: resource_locals(resource).merge(messages: nil))
          end
        else
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(resource, template: "#{partial_base}/edit", locals: resource_locals(resource).merge(messages: resource.errors.full_messages))
          end
        end
      end
    end

    def destroy
      resource.destroy

      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.remove(resource) }
      end
    end

    private

    def set_resource
      instance_variable_set("@#{resource_name}", resource_class.find(params[:id]))
    end

    def resource
      instance_variable_get("@#{resource_name}")
    end

    def resource_class
      controller_name.classify.constantize
    end

    def resource_name
      controller_name.singularize
    end

    def collection_name
      controller_name
    end

    def partial_base
      "account/#{collection_name}"
    end

    def resource_params
      params.require(resource_name.to_sym).permit(:title)
    end

    def resource_locals(record)
      { resource_name.to_sym => record }
    end
  end
end