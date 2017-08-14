class CallsController < ApplicationController
  before_action :find_opportunity, except: :index
  before_action :find_call, only: [:update, :destroy, :update_call_status]

  def index
    @calls = Call.all
  end

  def create
    @call = @opportunity.calls.build(params_call)

    respond_to do |format|
      if @call.save
        @opportunity.timelines.create!(tactivity: "call log",
        nactivity: @call.description, action: "created call log", user_id: current_user.id)
        format.js { flash.now[:success] = "Call log created!" }
      else
        format.js { flash.now[:danger] = "Failed to create call log!" }
      end
    end

  end

  def update
    respond_to do |format|
      if @call.update(params_call)
        @opportunity.timelines.create!(tactivity: "call log",
        nactivity: @call.description, action: "updated call log", user_id: current_user.id)
        format.js { flash.now[:success] = "Call entry updated!" }
      else
        format.js { flash.now[:danger] = "Failed to update call entry!" }
      end
    end

  end

  def destroy
    @call.destroy
    @opportunity.timelines.create!(tactivity: "call log",
    nactivity: @call.description, action: "deleted call log", user_id: current_user.id)
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
