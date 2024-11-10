module Authorizable
  extend ActiveSupport::Concern

  class_methods do
    def authorize_actions(*actions, except: [], only: [])
      authorized_actions = actions.presence || only.presence || %i[index show create update destroy]
      authorized_actions -= except if except.present?

      class_variable_set(:@@authorized_actions, authorized_actions)
    end

    def authorized_actions
      class_variable_defined?(:@@authorized_actions) ? class_variable_get(:@@authorized_actions) : []
    end
  end

  included do
    before_action :authorize_resource, if: :requires_authorization?

    private

    def requires_authorization?
      self.class.authorized_actions.include?(action_name.to_sym)
    end

    def authorize_resource
      policy_name = "#{controller_name.camelize}Policy"
      policy_class = policy_name.constantize
      policy = policy_class.new(current_user, policy_record)

      unless policy.public_send("#{action_name}?")
        render json: { error: "Forbidden" }, status: :forbidden
      end
    rescue NameError => e
      Rails.logger.error e
      render json: { error: e }, status: :internal_server_error
    end

    def policy_record
      case action_name
      when 'index'
        controller_name.classify.constantize
      when 'create'
        controller_name.classify.constantize.new(resource_params)
      else
        instance_variable_get("@#{controller_name.singularize}")
      end
    end

    def resource_params
      method_name = "#{controller_name.singularize}_params"
      send(method_name) if respond_to?(method_name, true)
    end
  end
end