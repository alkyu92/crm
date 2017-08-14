class DashboardsController < ApplicationController
  def index
    @opportunities = Opportunity.all
    @tasks = Task.includes(:opportunity).all.order('created_at DESC').take(6)

    @urgent_tasks = Task.includes(:opportunity).all.order('due_date').take(6)
  end

  def show
  end

  def new
  end

  def edit
  end
end
