class Users::AccountController < ApplicationController
  before_action :authenticate_user!

  def index

  end

  def show

  end

  def edit
    fields = params.permit(:sms_enabled)
    current_user.update(fields)

    redirect_to :account
  end

end
