class SessionsController < ApplicationController
  skip_before_action :check_signed_in, only: [:new, :create]
  before_action :redirect_if_authenticated, only: [:new, :create]

  def new
    @form = SignInForm.new
  end

  def create
    permitted_params = params.require(:sign_in_form).permit(SignInForm::ATTRS)
    @form = SignInForm.new(permitted_params)
    if @form.submit
      session[:user_address] = @form.address
      return redirect_to root_path
    end

    @form.reset
    render :new, status: :unprocessable_entity
  end

  def destroy
    session[:user_address] = nil
    redirect_to new_sessions_path, notice: 'Logged out!'
  end

  private

  def redirect_if_authenticated
    redirect_to root_path if user_signed_in?
  end
end
