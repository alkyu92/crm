class OpportunitiesController < ApplicationController

  def index
    @opportunities = Opportunity.includes(:account, :stages).page(params[:page]).per(10)
    @opportunity = current_user.opportunities.build

    # AJAX Account opportunities
    # @stages = Stage.all
    # @accounts = Account.all
  end

  def show
    # for AJAX
    @subject = Opportunity.find(params[:id])
    @opportunity = @subject
    @accounts = Account.all

    @optask = @opportunity.tasks.includes(:user).order('due_date').page(params[:task_page]).per(10)
    @opcall = @opportunity.calls.includes(:user).order('created_at DESC').page(params[:call_page]).per(10)
    @opevent = @opportunity.events.includes(:user).order('event_date').page(params[:event_page]).per(10)
  end

  def new
    if params[:account_id]
      @account = Account.find(params[:account_id])
      @opportunity = @account.opportunities.build
    else
      @opportunity = Opportunity.new
    end
  end

  def create
    if params[:account_id]
      @account = Account.find(params[:account_id])
      @opportunity = @account.opportunities.build(params_opportunity)
    else
      @opportunity = Opportunity.new(params_opportunity)
    end

    @opportunity.user_id = @opportunity.user_id || current_user.id

    # for AJAX
    @subject = @opportunity if params[:opportunity_id]
    @subject = @account if params[:account_id]
    @opportunities = Opportunity.page(params[:page]).per(10)
    @accop = Opportunity.includes(:account, :stages).page(params[:acc_page]).per(10)


      if @opportunity.save
        # account timeline
        @acoptimeline = @opportunity.account.timelines.create!(
        action: "#{current_user.name} created opportunity <strong>#{@opportunity.name}</strong>",
        user_id: current_user.id
        )

        # opportunity timeline
        @opportunity.timelines.create!(
        action: "#{current_user.name} created opportunity <strong>#{@opportunity.name}</strong>",
        user_id: current_user.id
        )

        flash.now[:success] = "opportunity entry created!"
        redirect_to opportunity_path(@opportunity)
      else
        flash.now[:danger] = "Failed to create opportunity entry!"
        render 'new'
      end

  end

  def update
    @opportunity = Opportunity.includes(:user).find(params[:id])

    @old_name = @opportunity.name
    @old_probability = @opportunity.probability
    @old_amount = @opportunity.amount
    @old_description = @opportunity.description
    @old_loss_reason = @opportunity.loss_reason
    @old_close_date = @opportunity.close_date
    @old_status = @opportunity.status

    respond_to do |format|
      # for AJAX
      @subject = @opportunity

      if @opportunity.update(params_opportunity)

          if params[:docs]
            params[:docs].each { |doc|
              @opportunity.documents.create!(doc: doc)
            }
            # timeline

          end

        if params[:attached]
          params[:attached].each { |attach|
            @opportunity.documents.where(id: attach).destroy_all
          }
        end

        if params[:delete_all]
          @opportunity.documents.destroy_all
        end

        if params[:assigned]
          @ctct = Contact.where(id: params[:assigned])
          @values = @ctct.map {|ct| "(#{ct.id}, #{@opportunity.id}, 'Opportunity', '#{ct.created_at}', '#{ct.updated_at}')"}.join(',')
          @sql = "INSERT INTO relationships ('contact_id', 'contactable_id', 'contactable_type', 'created_at', 'updated_at') VALUES #{@values}"
          ActiveRecord::Base.connection.execute(@sql)
          # timeline
          @opportunity.timelines.create!(
          action: "#{current_user.name} assigned
          <strong>#{@ctct.map {|ct| ct.name}.join(' ,')}</strong>",
          user_id: current_user.id
          )
        end

        save_timeline_if_any_changes
        format.js { flash.now[:success] = "opportunity entry updated!" }
      else
        format.js { flash.now[:danger] = "Failed to update opportunity!" }
      end
    end
  end

  def destroy
    @opportunity = Opportunity.includes(:user).find(params[:id])
    @opportunity.destroy

    respond_to do |format|
      format.js { flash[:success] = "opportunity entry deleted!" }
      format.html {
        flash[:success] = "opportunity entry deleted!"
        redirect_to opportunities_path
      }
    end

    @opportunities = Opportunity.includes(:account, :stages).page(params[:page]).per(10)
  end

  def delete_attachment
    respond_to do |format|
      @opportunity = Opportunity.find(params[:opportunity_id])
      @opportunity.documents.find(params[:id]).destroy

      @subject = @opportunity

      # timeline
      format.js { flash.now[:success] = "Attachment deleted!" }
    end
  end

  private

  def params_opportunity
    params.require(:opportunity).permit( :user_id,
                                         :name,
                                         :stage_id,
                                         :account,
                                         :account_id,
                                         :probability,
                                         :amount,
                                         :description,
                                         :loss_reason,
                                         :close_date,
                                         :status,
                                         :document,
                                         documents_attributes: [ doc: [] ]
                                        )
  end

  def timeline_opportunity(param, old, latest)
    @opportunity.timelines.create!(
    action: "#{current_user.name} updated opportunity
    <strong>#{param}</strong> from <strong>#{old}</strong>
    to <strong>#{latest}</strong>",
    anchor: "opportunityDetails",
    user_id: current_user.id
    )
  end

  def find_opportunity
    @opportunity = Opportunity.includes(:user).find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Record not found!"
    redirect_to opportunities_path
  end

  def save_timeline_if_any_changes
    if @opportunity.name_previously_changed?
      timeline_opportunity("name", @old_name, @opportunity.name)
    end
    if @opportunity.probability_previously_changed?
      timeline_opportunity("probability", @old_probability, @opportunity.probability)
    end
    if @opportunity.amount_previously_changed?
      timeline_opportunity("amount", @old_amount, @opportunity.amount)
    end
    if @opportunity.description_previously_changed?
      timeline_opportunity("description", @old_amount, @opportunity.description)
    end
    if @opportunity.status_previously_changed?
      timeline_opportunity("status", @old_status, @opportunity.status)
    end
    if @opportunity.close_date_previously_changed?
      timeline_opportunity("close date", @old_close_date, @opportunity.close_date)
    end
    if @opportunity.loss_reason_previously_changed?
      timeline_opportunity("loss reason", @old_loss_reason, @opportunity.loss_reason)
    end

    if @opportunity.status == "Open" ||
      @opportunity.status == "In Progress"

      @opportunity.close_date = ""
      @opportunity.loss_reason = ""

    elsif @opportunity.status == "Close-Won" ||
      @opportunity.status == "Solved"

      @opportunity.loss_reason = ""
    end

    @opportunity.save
  end

end
