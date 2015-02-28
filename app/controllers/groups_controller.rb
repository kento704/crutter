class GroupsController < ApplicationController
  permits :name, :display_order, :message_pattern_id

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/:id/edit
  def edit(id)
    @group = Group.find(id)
  end

  # POST /groups
  def create(group)
    @group = Group.new(group)

    if @group.save
      redirect_to :root, notice: 'Group was successfully created.'
    else
      render :new
    end
  end

  def update(id, group)
    @group = Group.find(id)
    if @group.update(group)
      redirect_to :root
    else
      render :edit
    end
  end

  # AJAX: PATCH /groups/:group_id/change_order
  def change_order(group_id, order)
    @group = Group.find(group_id)

    old_order = @group.display_order
    new_order = order.to_i

    # 値が大きくなる場合、他のグループの値を1減らす
    if old_order < new_order
      Group.update_order(old_order, new_order + 1, -1)
    else
      Group.update_order(new_order - 1, old_order,  1)
    end

    @group.update(display_order: new_order)

    render nothing: true

  end

end 