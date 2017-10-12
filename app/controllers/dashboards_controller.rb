class DashboardsController < ApplicationController
  def index
    @opportunities = Opportunity.includes(
    :user, :account, :tasks, :calls, :events).where(
    business_type: "Opportunity").order('created_at DESC')
    @opportunities_open = @opportunities.where(status: 'Open').order('created_at DESC').take(6)
    @opportunities_approved = @opportunities.where(status: 'Approved').order('created_at DESC').take(6)
    @opportunities_closedwon = @opportunities.where(status: 'Closed-Won').order('created_at DESC').take(6)
    @opportunities_closedloss = @opportunities.where(status: 'Closed-Loss').order('created_at DESC').take(6)

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

    @opwon = Opportunity.includes(:account).where(status: "Closed-Won").order('amount DESC')
    @oploss = Opportunity.includes(:account).where(status: "Closed-Loss").order('amount DESC')
    @opopen = Opportunity.includes(:account).where(status: "Open").order('amount DESC')
    @opaprv = Opportunity.includes(:account).where(status: "Approved").order('amount DESC')

    @opwon_sum = @opwon.sum('amount')
    @oploss_sum = @oploss.sum('amount')
    @opopen_sum = @opopen.sum('amount')
    @opaprv_sum = @opaprv.sum('amount')

    gon.opwon_sum = @opwon_sum
    gon.oploss_sum = @oploss_sum
    gon.opopen_sum = @opopen_sum
    gon.opaprv_sum = @opaprv_sum

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

    @acc_open_hash = {}
    Account.all.each do |acc|
      @acc_open_hash[acc.account_name] = acc.opportunities.where(status: "Open").sum("amount")
    end
    @acc_open_hash = @acc_open_hash.sort_by(&:last).reverse.take(6)
    gon.acc_open_hash = @acc_open_hash

    @acc_approved_hash = {}
    Account.all.each do |acc|
      @acc_approved_hash[acc.account_name] = acc.opportunities.where(status: "Approved").sum("amount")
    end
    @acc_approved_hash = @acc_approved_hash.sort_by(&:last).reverse.take(6)
    gon.acc_approved_hash = @acc_approved_hash
  end

end
