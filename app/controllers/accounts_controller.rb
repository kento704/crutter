class AccountsController < ApplicationController
  permits :group_id, :target_id, :description, :auto_update, :auto_follow, :auto_unfollow, :auto_direct_message, :auto_retweet

  def show(id)
    @account = Account.find(id)
    @followers_count_data = {}
    @account.follower_histories.where(FollowerHistory.arel_table[:created_at].gt(7.days.ago)).group(:created_at).sum(:followers_count).each do |k, v|
      @followers_count_data[k] = v
    end
  end

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

  # DELETE /accounts/1
  def destroy(id)
    @account =  Account.find(id)
    @account.destroy

    redirect_to :root, notice: 'Account was successfully destroyed.'
  end

end