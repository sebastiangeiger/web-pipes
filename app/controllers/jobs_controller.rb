class JobsController < ApplicationController
  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_create_params)
    if @job.save
      redirect_to @job
    else
      render :new
    end
  end

  def index
    @jobs = Job.all
  end

  def show
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])
    @job.update(job_update_params)
    redirect_to action: :show
  end

  private

  def job_create_params
    params.require(:job).permit(:name)
  end

  def job_update_params
    params.require(:job).permit(:code)
  end
end
