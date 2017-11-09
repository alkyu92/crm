class CasesController < ApplicationController
  def index
    if params[:status] && params[:type]
      @cases = Case.includes(
        :account, :stages).where(
        status: params[:status], business_type: params[:type]).page(
        params[:page]).per(10)
    elsif params[:type]
      @cases = Case.includes(
        :account, :stages).where(
        business_type: params[:type]).page(
        params[:page]).per(10)
    else
      @cases = Case.includes(:account, :stages).page(params[:page]).per(10)
    end

    @case = current_user.cases.build

    # AJAX Account cases
    # @stages = Stage.all
    # @accounts = Account.all
  end

  def show
    # for AJAX
    @subject = Case.find(params[:id])
    @case = @subject
    @accounts = Account.all

    @optask = @case.tasks.includes(:user).order('due_date').page(params[:task_page]).per(10)
    @opcall = @case.calls.includes(:user).order('created_at DESC').page(params[:call_page]).per(10)
    @opevent = @case.events.includes(:user).order('event_date').page(params[:event_page]).per(10)
  end

  def new
    if params[:account_id]
      @account = Account.find(params[:account_id])
      @case = @account.cases.build
    else
      @case = Case.new
    end
  end

  def create
    if params[:account_id]
      @account = Account.find(params[:account_id])
      @case = @account.cases.build(params_case)
    else
      @case = Case.new(params_case)
    end

    @case.user_id = @case.user_id || current_user.id

    # for AJAX
    @subject = @case if params[:case_id]
    @subject = @account if params[:account_id]
    @cases = Case.page(params[:page]).per(10)
    @accop = Case.includes(:account, :stages).page(params[:acc_page]).per(10)


      if @case.save

        @acoptimeline = @case.account.timelines.create!(
        tactivity: "",
        nactivity: @case.name,
        action: "created #{@case.business_type.downcase}",
        user_id: current_user.id)

        timeline_case("#", @case.name, "created #{@case.business_type.downcase}")

        flash.now[:success] = "#{@case.business_type.downcase} entry created!"
        redirect_to case_path(@case)
      else
        flash.now[:danger] = "Failed to create #{@case.business_type.downcase} entry!"
        render 'new'
      end

  end

  def update
    @case = Case.includes(:user).find(params[:id])
    @old_name = @case.name
    respond_to do |format|
      # for AJAX
      @subject = @case

      if @case.update(params_case)

          if params[:docs]
            params[:docs].each { |doc|
              @case.documents.create!(doc: doc)
            }
            timeline_case("relatedDocs", @case.name,
            "added attachment file to #{@case.business_type.downcase}")
          end

        if params[:attached]
          params[:attached].each { |attach|
            @case.documents.where(id: attach).destroy_all
          }
        end

        if params[:delete_all]
          @case.documents.destroy_all
        end

        if params[:assigned]
          @ctct = Contact.where(id: params[:assigned])
          @values = @ctct.map {|ct| "(#{ct.id}, #{@case.id}, 'Case', '#{ct.created_at}', '#{ct.updated_at}')"}.join(',')
          @sql = "INSERT INTO relationships ('contact_id', 'contactable_id', 'contactable_type', 'created_at', 'updated_at') VALUES #{@values}"
          ActiveRecord::Base.connection.execute(@sql)
          timeline_case("relatedContacts", @ctct.map {|ct| "#{ct.name}"}.join(','), "added association")
          # params[:assigned].each { |ct_id|
          #   @ctct = Contact.find(ct_id)
          #   @case.relationships.create!(contact: @ctct)
          # }
        end

        save_timeline_if_any_changes(@old_name)
        format.js { flash.now[:success] = "#{@case.business_type.downcase} entry updated!" }
      else
        format.js { flash.now[:danger] = "Failed to update #{@case.business_type.downcase}!" }
      end
    end
  end

  def destroy
    @case = Case.includes(:user).find(params[:id])
    @case.destroy

    respond_to do |format|
      format.js { flash[:success] = "#{@case.business_type.downcase} entry deleted!" }
      format.html {
        flash[:success] = "#{@case.business_type.downcase} entry deleted!"
        redirect_to cases_path
      }
    end

    @cases = Case.includes(:account, :stages).page(params[:page]).per(10)
  end

  def delete_attachment
    respond_to do |format|
      @case = Case.find(params[:case_id])
      @case.documents.find(params[:id]).destroy

      @subject = @case

      timeline_case("relatedDocs", @case.name,
      "deleted attachment file from #{@case.business_type.downcase}")
      format.js { flash.now[:success] = "Attachment deleted!" }
    end
  end

  private

  def timeline_case(tactivity, nactivity, action)
    @optimeline = @case.timelines.create!(
    tactivity: tactivity,
    nactivity: nactivity,
    action: action,
    user_id: current_user.id
    )

    notify_user(@optimeline.id)
  end

  def params_case
    params.require(:case).permit( :user_id,
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

  def find_case
    @case = Case.includes(:user).find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Record not found!"
    redirect_to cases_path
  end

  def save_timeline_if_any_changes(old_name)
    if @case.name_previously_changed?
      timeline_case("caseDetails",
      old_name, "updated #{@case.business_type.downcase} name from")
    end
    if @case.business_type_previously_changed?
      timeline_case("caseDetails",
      @case.business_type, "updated type to")
    end
    if @case.probability_previously_changed?
      timeline_case("caseDetails",
      @case.probability, "updated case probability to")
    end
    if @case.amount_previously_changed?
      timeline_case("caseDetails",
      sprintf('%.2f' % @case.amount),
      "updated #{@case.business_type.downcase} amount to RM")
    end
    if @case.description_previously_changed?
      timeline_case("caseDetails",
      "", "updated #{@case.business_type} description")
    end
    if @case.status_previously_changed?
      timeline_case("caseDetails",
      @case.status, "updated #{@case.business_type.downcase} status to")
    end
    if @case.close_date_previously_changed?
      timeline_case("caseDetails",
      @case.close_date.strftime('%d %b %Y'),
      "updated #{@case.business_type.downcase} #{
      @case.business_type == "Case" ? 'closed' : 'solved'
      } date to")
    end
    if @case.loss_reason_previously_changed?
      timeline_case("caseDetails",
      @case.loss_reason, "updated case loss reason to")
    end

    if @case.status == "Open" ||
      @case.status == "In Progress"

      @case.close_date = ""
      @case.loss_reason = ""

    elsif @case.status == "Close-Won" ||
      @case.status == "Solved"

      @case.loss_reason = ""
    end

    @case.save
  end
end
