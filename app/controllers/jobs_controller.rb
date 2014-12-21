class JobsController < ApplicationController
  def new
    @job = Job.new
  end

  def create
    @job = Job.create(job_params)
    redirect_to root_path
  end

  def index
    @jobs = Job.all
  end

  private

  def job_params
    params.require(:job).permit(:name)
  end
end
