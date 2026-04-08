module Patterns
  class Form
    include ActiveModel::Model
    include ActiveModel::Validations

    Error = Class.new(StandardError)
    Invalid = Class.new(Error)
    NoParamKey = Class.new(Error)

    ModelName = Struct.new(:param_key, :route_key, :singular_route_key, keyword_init: true)

    class << self
      def attribute(name, _type = nil)
        attribute_names << name.to_sym
        attr_accessor name
      end

      def attribute_names
        @attribute_names ||= []
      end

      def param_key(key = nil)
        if key.nil?
          @param_key
        else
          @param_key = key
        end
      end
    end

    def initialize(*args)
      attributes = args.extract_options!

      if attributes.blank? && args.last.is_a?(ActionController::Parameters)
        attributes = args.pop.to_unsafe_h
      end

      @resource = args.first
      assign_attributes(build_original_attributes.merge(attributes.to_h.symbolize_keys))
    end

    def save
      valid? ? persist : false
    end

    def save!
      save.tap do |saved|
        raise Invalid unless saved
      end
    end

    def as(form_owner)
      @form_owner = form_owner
      self
    end

    def attributes
      self.class.attribute_names.each_with_object({}) do |name, result|
        result[name] = public_send(name)
      end
    end

    def to_key
      nil
    end

    def to_partial_path
      nil
    end

    def to_model
      self
    end

    def to_param
      if resource.present? && resource.respond_to?(:to_param)
        resource.to_param
      else
        nil
      end
    end

    def persisted?
      if resource.present? && resource.respond_to?(:persisted?)
        resource.persisted?
      else
        false
      end
    end

    def model_name
      @model_name ||= ModelName.new(**model_name_attributes)
    end

    private

    attr_reader :resource, :form_owner

    def assign_attributes(attributes)
      attributes.each do |key, value|
        setter = "#{key}="
        public_send(setter, value) if respond_to?(setter)
      end
    end

    def model_name_attributes
      if self.class.param_key.present?
        {
          param_key: self.class.param_key,
          route_key: self.class.param_key.pluralize,
          singular_route_key: self.class.param_key
        }
      elsif resource.present? && resource.respond_to?(:model_name)
        {
          param_key: resource.model_name.param_key,
          route_key: resource.model_name.route_key,
          singular_route_key: resource.model_name.singular_route_key
        }
      else
        raise NoParamKey
      end
    end

    def build_original_attributes
      return {} if resource.nil?

      base_attributes = resource.respond_to?(:attributes) ? resource.attributes.symbolize_keys : {}

      self.class.attribute_names.each_with_object(base_attributes) do |name, result|
        if result[name].blank? && resource.respond_to?(name)
          result[name] = resource.public_send(name)
        end
      end
    end

    def persist
      raise NotImplementedError, "#persist has to be implemented"
    end
  end
end