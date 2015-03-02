# coding: utf-8

class TargetsController < ApplicationController
  before_action :set_target, only: [:show, :edit, :update, :destroy]
  permits :name, :screen_name

  # GET /targets
  def index
    @targets = Target.all
  end

  # GET /targets/1
  def show
  end

  # GET /targets/new
  def new
    @target = Target.new
  end

  # GET /targets/1/edit
  def edit
  end

  # POST /targets
  def create(target)
    @target = Target.new(target)

    if @target.save
      redirect_to @target, notice: 'Target was successfully created.'
    else
      render :new
    end
  end

  # PUT /targets/1
  def update(target)
    if @target.update(target)
      redirect_to @target, notice: 'Target was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /targets/1
  def destroy
    @target.destroy

    redirect_to targets_url, notice: 'Target was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_target(id)
      @target = Target.find(id)
    end
end
