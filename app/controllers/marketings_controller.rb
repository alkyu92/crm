class MarketingsController < ApplicationController
  def index
    if params[:status]
      @marketings = Marketing.includes(:account, :stages).where(
        status: params[:status]).page(params[:page]).per(10)
    else
      @marketings = Marketing.includes(:account, :stages).page(params[:page]).per(10)
    end

    @marketing = current_user.marketings.build

    # AJAX Account marketings
    # @stages = Stage.all
    # @accounts = Account.all
  end

  def show
    # for AJAX
    @subject = Marketing.find(params[:id])
    @marketing = @subject
    @accounts = Account.all

    @optask = @marketing.tasks.includes(:user).order('due_date').page(params[:task_page]).per(10)
    @opcall = @marketing.calls.includes(:user).order('created_at DESC').page(params[:call_page]).per(10)
    @opevent = @marketing.events.includes(:user).order('event_date').page(params[:event_page]).per(10)
  end

  def new
    if params[:account_id]
      @account = Account.find(params[:account_id])
      @marketing = @account.marketings.build
    else
      @marketing = Marketing.new
    end
  end

  def create
    if params[:account_id]
      @account = Account.find(params[:account_id])
      @marketing = @account.marketings.build(params_marketing)
    else
      @marketing = Marketing.new(params_marketing)
    end

    @marketing.user_id = @marketing.user_id || current_user.id

    # for AJAX
    @subject = @marketing if params[:marketing_id]
    @subject = @account if params[:account_id]
    @marketings = Marketing.page(params[:page]).per(10)
    @accop = Marketing.includes(:account, :stages).page(params[:acc_page]).per(10)


      if @marketing.save

        @acoptimeline = @marketing.account.timelines.create!(
        action: "#{current_user.name} created marketing entry",
        user_id: current_user.id
        )

        flash.now[:success] = "marketing entry created!"
        redirect_to marketing_path(@marketing)
      else
        flash.now[:danger] = "Failed to create marketing entry!"
        render 'new'
      end

  end

  def update
    @marketing = Marketing.includes(:user).find(params[:id])

    @old_name = @marketing.name
    @old_status = @marketing.status
    @old_description = @marketing.description
    @old_amount = @marketing.amount

    respond_to do |format|
      # for AJAX
      @subject = @marketing

      if @marketing.update(params_marketing)

          if params[:docs]
            params[:docs].each { |doc|
              @marketing.documents.create!(doc: doc)
            }
            # timeline
            @optimeline = @marketing.timelines.create!(
            action: "#{current_user.name} added attachment file to #{@marketing.name}",
            user_id: current_user.id
            )
          end

        if params[:attached]
          params[:attached].each { |attach|
            @marketing.documents.where(id: attach).destroy_all
          }
        end

        if params[:delete_all]
          @marketing.documents.destroy_all
        end

        if params[:assigned]
          @ctct = Contact.where(id: params[:assigned])
          @values = @ctct.map {|ct| "(#{ct.id}, #{@marketing.id}, 'Marketing', '#{ct.created_at}', '#{ct.updated_at}')"}.join(',')
          @sql = "INSERT INTO relationships ('contact_id', 'contactable_id', 'contactable_type', 'created_at', 'updated_at') VALUES #{@values}"
          ActiveRecord::Base.connection.execute(@sql)
          # timeline
          @marketing.timelines.create!(
          action: "#{current_user.name} assigned
          <strong>#{@ctct.map {|ct| ct.name}.join(' ,')}</strong>",
          user_id: current_user.id
          )
        end

        save_timeline_if_any_changes
        format.js { flash.now[:success] = "Marketing entry updated!" }
      else
        format.js { flash.now[:danger] = "Failed to update marketing!" }
      end
    end
  end

  def destroy
    @marketing = Marketing.includes(:user).find(params[:id])
    @marketing.destroy

    respond_to do |format|
      format.js { flash[:success] = "Marketing entry deleted!" }
      format.html {
        flash[:success] = "Marketing entry deleted!"
        redirect_to marketings_path
      }
    end

    @marketings = Marketing.includes(:account, :stages).page(params[:page]).per(10)
  end

  def delete_attachment
    respond_to do |format|
      @marketing = Marketing.find(params[:marketing_id])
      @marketing.documents.find(params[:id]).destroy

      @subject = @marketing

      # timeline
      @optimeline = @marketing.timelines.create!(
      action: "#{current_user.name} deleted attachment file from marketing #{@marketing.name}",
      user_id: current_user.id
      )
      format.js { flash.now[:success] = "Attachment deleted!" }
    end
  end

  private

  def params_marketing
    params.require(:marketing).permit( :user_id,
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

  def find_marketing
    @marketing = Marketing.includes(:user).find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Record not found!"
    redirect_to marketings_path
  end

  def timeline_marketing(param, old, latest)
    @optimeline = @marketing.timelines.create!(
    action: "#{current_user.name} updated marketing <strong>#{param}</strong>
    from <strong>#{old}</strong> to <strong>#{latest}</strong>",
    user_id: current_user.id
    )
  end

  def save_timeline_if_any_changes
    if @marketing.name_previously_changed?
      timeline_marketing("name", @old_name, @marketing.name)
    end
    if @marketing.amount_previously_changed?
      timeline_marketing("amount", sprintf('%.2f' % @old_amount), sprintf('%.2f' % @marketing.amount))
    end
    if @marketing.description_previously_changed?
      timeline_marketing("description", @old_description, @marketing.description)
    end
    if @marketing.status_previously_changed?
      timeline_marketing("status", @old_status, @marketing.status)
    end

    @marketing.save
  end
end
