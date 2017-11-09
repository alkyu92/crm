class DashboardsController < ApplicationController
  def sales_index
    @opportunities = Opportunity.where(business_type: "Opportunity").order('created_at DESC').pluck(
    :id, :name, :created_at).take(6)
    @opportunities_open = Opportunity.joins(:account).where(
    business_type: "Opportunity", status: "Open").order('opportunities.created_at DESC').pluck(
    :id, :name, "opportunities.created_at", :status, :account_name, "accounts.id").take(6)
    @opportunities_approved = Opportunity.joins(:account).where(
    business_type: "Opportunity", status: "Approved").order('opportunities.created_at DESC').pluck(
    :id, :name, "opportunities.created_at", :status, :account_name, "accounts.id").take(6)
    @opportunities_closedwon = Opportunity.joins(:account).where(
    business_type: "Opportunity", status: "Closed-Won").order('opportunities.created_at DESC').pluck(
    :id, :name, "opportunities.created_at", :status, :account_name, "accounts.id").take(6)
    @opportunities_closedloss = Opportunity.joins(:account).where(
    business_type: "Opportunity", status: "Closed-Loss").order('opportunities.created_at DESC').pluck(
    :id, :name, "opportunities.created_at", :status, :account_name, "accounts.id").take(6)

    @cases = Opportunity.where(
    business_type: "Case").order('created_at DESC').pluck(
    :id, :name, :created_at).take(6)
    @cases_inprogress = Opportunity.where(
    business_type: "Case", status: 'In Progress').pluck(
    :id, :name, :created_at, :status).take(6)
    @cases_solved = Opportunity.where(
    business_type: "Case", status: 'Solved').pluck(
    :id, :name, :created_at, :status).take(6)

    @accounts = Account.order('created_at DESC').pluck(:id, :account_name, :created_at).take(6)

    @tasks = Task.order('created_at DESC').pluck(
    :id, :description, :created_at, :polytask_id).take(6)
    @urgent_tasks = Task.order('due_date').where(
    'due_date BETWEEN ? AND ?', 2.day.ago, 3.day.from_now).pluck(
    :id, :description, :due_date, :polytask_id).take(6)

    @events = Event.order('created_at DESC').pluck(
    :id, :description, :created_at, :polyevent_id).take(6)
    @urgent_events = Event.order('event_date').where(
    'event_date BETWEEN ? AND ?', 2.day.ago, 3.day.from_now).pluck(
    :id, :description, :event_date, :polyevent_id).take(6)

    @calls = Call.order('calls.created_at DESC').pluck(
    :id, :description, :call_datetime, :polycall_id).take(6)

    @contacts = Contact.order('created_at DESC').pluck(:name, :created_at).take(6)

    @opwon = Opportunity.joins(:account).where(status: "Closed-Won").order('amount DESC').pluck(
    :account_name, :account_id, :name, :id, :amount)
    @oploss = Opportunity.joins(:account).where(status: "Closed-Loss").order('amount DESC').pluck(
    :account_name, :account_id, :name, :id, :amount, :loss_reason)
    @opopen = Opportunity.joins(:account).where(status: "Open").order('amount DESC').pluck(
    :account_name, :account_id, :name, :id, :amount)
    @opaprv = Opportunity.joins(:account).where(status: "Approved").order('amount DESC').pluck(
    :account_name, :account_id, :name, :id, :amount)

    @opwon_sum = Opportunity.where(status: "Closed-Won").pluck(:amount).sum
    @oploss_sum = Opportunity.where(status: "Closed-Loss").pluck(:amount).sum
    @opopen_sum = Opportunity.where(status: "Open").pluck(:amount).sum
    @opaprv_sum = Opportunity.where(status: "Approved").pluck(:amount).sum

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

  def marketing_index
    @marketings = Opportunity.where(business_type: "Marketing")
  end

  def main

  end

end
