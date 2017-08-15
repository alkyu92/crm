class DashboardsController < ApplicationController
  def index
    @opportunities = Opportunity.all
    @tasks = Task.includes(:opportunity).all.order('created_at DESC').take(6)
    @accounts = Account.all.order('created_at DESC').take(6)
    @urgent_tasks = Task.includes(:opportunity).all.order('due_date').take(6)

    @opwon = Opportunity.where(status: "Closed-Won").take(6)
    @oploss = Opportunity.where(status: "Closed-Loss").take(6)
  end

end
