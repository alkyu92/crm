class OpportunitiesController < ApplicationController

  def index
    if params[:status] && params[:type]
      @opportunities = Opportunity.includes(
        :account, :stages).where(
        status: params[:status], business_type: params[:type]).page(
        params[:page]).per(10)
    elsif params[:type]
      @opportunities = Opportunity.includes(
        :account, :stages).where(
        business_type: params[:type]).page(
        params[:page]).per(10)
    else
      @opportunities = Opportunity.includes(:account, :stages).page(params[:page]).per(10)
    end

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

        @acoptimeline = @opportunity.account.timelines.create!(
        tactivity: "",
        nactivity: @opportunity.name,
        action: "created #{@opportunity.business_type.downcase}",
        user_id: current_user.id)

        timeline_opportunity("#", @opportunity.name, "created #{@opportunity.business_type.downcase}")

        flash.now[:success] = "#{@opportunity.business_type.downcase} entry created!"
        redirect_to opportunity_path(@opportunity)
      else
        flash.now[:danger] = "Failed to create #{@opportunity.business_type.downcase} entry!"
        render 'new'
      end

  end

  def update
    @opportunity = Opportunity.includes(:user).find(params[:id])
    @old_name = @opportunity.name
    respond_to do |format|
      # for AJAX
      @subject = @opportunity

      if @opportunity.update(params_opportunity)

          if params[:docs]
            params[:docs].each { |doc|
              @opportunity.documents.create!(doc: doc)
            }
            timeline_opportunity("relatedDocs", @opportunity.name,
            "added attachment file to #{@opportunity.business_type.downcase}")
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
          timeline_opportunity("relatedContacts", @ctct.map {|ct| "#{ct.name}"}.join(','), "added association")
          # params[:assigned].each { |ct_id|
          #   @ctct = Contact.find(ct_id)
          #   @opportunity.relationships.create!(contact: @ctct)
          # }
        end

        save_timeline_if_any_changes(@old_name)
        format.js { flash.now[:success] = "#{@opportunity.business_type.downcase} entry updated!" }
      else
        format.js { flash.now[:danger] = "Failed to update #{@opportunity.business_type.downcase}!" }
      end
    end
  end

  def destroy
    @opportunity = Opportunity.includes(:user).find(params[:id])
    @opportunity.destroy

    respond_to do |format|
      format.js { flash[:success] = "#{@opportunity.business_type.downcase} entry deleted!" }
      format.html {
        flash[:success] = "#{@opportunity.business_type.downcase} entry deleted!"
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

      timeline_opportunity("relatedDocs", @opportunity.name,
      "deleted attachment file from #{@opportunity.business_type.downcase}")
      format.js { flash.now[:success] = "Attachment deleted!" }
    end
  end

  private

  def timeline_opportunity(tactivity, nactivity, action)
    @optimeline = @opportunity.timelines.create!(
    tactivity: tactivity,
    nactivity: nactivity,
    action: action,
    user_id: current_user.id
    )

    notify_user(@optimeline.id)
  end

  def params_opportunity
    params.require(:opportunity).permit( :user_id,
                                         :name,
                                         :stage_id,
                                         :account,
                                         :account_id,
                                         :business_type,
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

  def find_opportunity
    @opportunity = Opportunity.includes(:user).find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Record not found!"
    redirect_to opportunities_path
  end

  def save_timeline_if_any_changes(old_name)
    if @opportunity.name_previously_changed?
      timeline_opportunity("opportunityDetails",
      old_name, "updated #{@opportunity.business_type.downcase} name from")
    end
    if @opportunity.business_type_previously_changed?
      timeline_opportunity("opportunityDetails",
      @opportunity.business_type, "updated type to")
    end
    if @opportunity.probability_previously_changed?
      timeline_opportunity("opportunityDetails",
      @opportunity.probability, "updated opportunity probability to")
    end
    if @opportunity.amount_previously_changed?
      timeline_opportunity("opportunityDetails",
      sprintf('%.2f' % @opportunity.amount),
      "updated #{@opportunity.business_type.downcase} amount to RM")
    end
    if @opportunity.description_previously_changed?
      timeline_opportunity("opportunityDetails",
      "", "updated #{@opportunity.business_type} description")
    end
    if @opportunity.status_previously_changed?
      timeline_opportunity("opportunityDetails",
      @opportunity.status, "updated #{@opportunity.business_type.downcase} status to")
    end
    if @opportunity.close_date_previously_changed?
      timeline_opportunity("opportunityDetails",
      @opportunity.close_date.strftime('%d %b %Y'),
      "updated #{@opportunity.business_type.downcase} #{
      @opportunity.business_type == "Opportunity" ? 'closed' : 'solved'
      } date to")
    end
    if @opportunity.loss_reason_previously_changed?
      timeline_opportunity("opportunityDetails",
      @opportunity.loss_reason, "updated opportunity loss reason to")
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
