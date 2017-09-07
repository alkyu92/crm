class DashboardsController < ApplicationController
  def index
    @opportunities = Opportunity.includes(
    :user, :account, :tasks, :calls, :events).order('created_at DESC').take(6)
    @accounts = Account.includes(:user, :opportunities).order('created_at DESC').take(6)

    @tasks = Task.includes(:opportunity).order('created_at DESC').take(6)
    @urgent_tasks = Task.includes(:opportunity).where('due_date <= ?', 1.day.from_now).take(6)

    @events = Event.includes(:opportunity).order('created_at DESC').take(6)
    @urgent_events = Event.includes(:opportunity).where('event_date <= ?', 1.day.from_now).take(6)

    @calls = Call.includes(:opportunity).order('created_at DESC').take(6)

    @opwon = Opportunity.where(status: "Closed-Won").take(6)
    @oploss = Opportunity.where(status: "Closed-Loss").take(6)
  end

end
