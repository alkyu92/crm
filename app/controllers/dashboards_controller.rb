class DashboardsController < ApplicationController
  def index
    @opportunities = Opportunity.all
    @tasks = Task.all
  end

  def show
  end

  def new
  end

  def edit
  end
end
