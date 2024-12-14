class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  # Temporary until auth exists
  def current_account
    @account ||= Account.first
  end
end
