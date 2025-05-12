class PlansController < ApplicationController
  def index
    @plans = current_user.plans
  end

  def show
    @plan = Plan.find(params[:id])
  end

  def new
    @plan = Plan.new
  end

  def edit
    @plan = Plan.find(params[:id])
  end

  def create
    @plan = current_user.plans.build(plan_params)

    respond_to do |format|
      if @plan.save
        format.html { redirect_to plan_url(@plan), notice: 'Plan was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    @plan = Plan.find(params[:id])

    respond_to do |format|
      if @plan.update(post_params)
        format.html { redirect_to plan_url(@plan), notice: 'Plan was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @plan.destroy

    respond_to do |format|
      format.html { redirect_to plans_url, notice: 'Plan was successfully destroyed.' }
    end
  end

  private

  def plan_params
    params.require(:plan).permit(:name)
  end
end
