class DashboardsController < ApplicationController
  def index
    @opportunities = Opportunity.includes(
    :user, :account, :tasks, :calls, :events).where(
    business_type: "Opportunity").order('created_at DESC')
    @opportunities_open = @opportunities.where(status: 'Open').take(6)
    @opportunities_closedwon = @opportunities.where(status: 'Closed-Won').take(6)
    @opportunities_closedloss = @opportunities.where(status: 'Closed-Loss').take(6)

    @cases = Opportunity.includes(
    :user, :account, :tasks, :calls, :events).where(
    business_type: "Case").order('created_at DESC')
    @cases_inprogress = @cases.where(status: 'In Progress').take(6)
    @cases_solved = @cases.where(status: 'Solved').take(6)

    @accounts = Account.includes(:user, :opportunities).order('created_at DESC').take(6)

    @tasks = Task.includes(:opportunity).order('created_at DESC').take(6)
    @urgent_tasks = Task.includes(:opportunity).order('due_date').where(
    'due_date BETWEEN ? AND ?', 2.day.ago, 3.day.from_now).take(6)

    @events = Event.includes(:opportunity).order('created_at DESC').take(6)
    @urgent_events = Event.includes(:opportunity).order('event_date').where(
    'event_date BETWEEN ? AND ?', 2.day.ago, 3.day.from_now).take(6)

    @calls = Call.includes(:opportunity).order('created_at DESC').take(6)

    @contacts = Contact.all.order('created_at DESC').take(6)

    @opwon = Opportunity.where(status: "Closed-Won")
    @oploss = Opportunity.where(status: "Closed-Loss")
    gon.opwon_count = @opwon.count
    gon.oploss_count =  @oploss.count

    @acc_won_hash = {}
    Account.all.each do |acc|
      @acc_won_hash[acc.account_name] = acc.opportunities.where(status: "Closed-Won").sum("amount")
    end
    @acc_won_hash = @acc_won_hash.sort_by(&:last).reverse.take(6)
    gon.acc_won_hash = @acc_won_hash

    @acc_loss_hash = {}
    Account.all.each do |acc|
      @acc_loss_hash[acc.account_name] = acc.opportunities.where(status: "Closed-Loss").sum("amount")
    end
    @acc_loss_hash = @acc_loss_hash.sort_by(&:last).reverse.take(6)
    gon.acc_loss_hash = @acc_loss_hash
  end

end
