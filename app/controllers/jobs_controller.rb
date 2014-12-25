class JobsController < ApplicationController
  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
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

  private

  def job_params
    params.require(:job).permit(:name)
  end
end
