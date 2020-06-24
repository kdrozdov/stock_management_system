class ApplicationController < ActionController::API
  before_action { validate_params! }

  def validate_params!
    if safe_params && safe_params.failure?
      render(json: { errors: safe_params.errors.to_h }, status: :unprocessable_entity) &&
        throw(:abort)
    end
  end
end
