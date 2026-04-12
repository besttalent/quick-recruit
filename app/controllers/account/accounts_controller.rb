class Account::AccountsController < Account::BaseController
  include ActiveStorage::SetCurrent

  before_action :set_account

  def show
  end

  def update
    if @account.update(account_params)
      redirect_to account_account_path, notice: "Company profile was updated successfully"
    else
      render :show, status: :unprocessable_entity
    end
  end

  def update_logo
    if @account.logo.attach(params[:account][:logo])
      redirect_to account_account_path, notice: "Company logo was updated successfully"
    else
      redirect_to account_account_path, alert: @account.errors.full_messages.join(" and ")
    end
  end

  def destroy_logo
    if @account.logo.destroy
      redirect_to account_account_path, notice: "Company logo was deleted successfully"
    else
      redirect_to account_account_path, alert: "Company logo was not deleted"
    end
  end

  private

  def set_account
    @account = Account.first_or_initialize
  end

  def account_params
    params.require(:account).permit(:company_name, :company_website_url, :company_introduction)
  end
end
