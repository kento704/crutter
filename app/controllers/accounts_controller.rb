class AccountsController < ApplicationController
  permits :target_user, :description, :auto_update, :auto_follow, :auto_unfollow

  def edit(id)
    @account = Account.find(id)
  end

  # PATCH /accounts
  def update(id, account)
    @account =  Account.find(id)

    if @account.update(account)
      redirect_to :root, notice: 'Account was successfully updated.'
    else
      render :edit
    end
  end

end 