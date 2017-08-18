class CallsController < ApplicationController
  before_action :find_opportunity, except: :index
  before_action :find_call, only: [:update, :destroy, :update_call_status]

  def index
    @calls = Call.all.includes(:opportunity).page(params[:page]).per(10)

    if params[:opportunity_id]
    @opportunity = Opportunity.find(params[:opportunity_id])
    respond_to do |format|
      format.js
    end
  end

  end

  def show
    respond_to do |format|
      format.js
    end
  end

  def create
    @call = @opportunity.calls.build(params_call)

    respond_to do |format|
      if @call.save
        #timeline_call("created call log")
        format.js { flash.now[:success] = "Call log created!" }
      else
        format.js { flash.now[:danger] = "Failed to create call log!" }
      end
    end

  end

  def update
    respond_to do |format|
      if @call.update(params_call)
        #timeline_call("updated call log")
        format.js { flash.now[:success] = "Call entry updated!" }
      else
        format.js { flash.now[:danger] = "Failed to update call entry!" }
      end
    end

  end

  def destroy
    @call.destroy
    #timeline_call("deleted call log")
    respond_to do |format|
      format.js { flash.now[:success] = "Call log deleted!" }
    end
  end

  private
  def params_call
    params.require(:call).permit(:description, :call_datetime, :duration)
  end

  def find_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id])

  rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Can't find records!"
    redirect_to root_path
  end

  def find_call
    @call = Call.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Can't find records!"
    redirect_to root_path
  end
end
