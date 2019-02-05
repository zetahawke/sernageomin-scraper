class EntriesController < ApplicationController
  def Index
    result = Entry.all.page(params[:page] || 1).per(params[:per_page] || 25)
    render json: { number: result.size, data: result }, status: :ok
  end

  def init_scrap
    raise if params[:url].blank?
    if Entry.number_of_current_jobs > 0
      render json: { data: { status: 'There is some running process.' } }
    else
      Entry.scrap_more_results(params[:url], params[:region], params[:page])
      render json: { data: { status: 'Starting to scrap' } }, status: :ok
    end
  end

  def empty_records
    result = Entry.where(region: nil).page(params[:page] || 1).per(params[:per_page] || 25)
    render json: { number: result.size, data: result }, status: :ok
  end

  def completed_records
    result = Entry.where.not(region: nil).page(params[:page] || 1).per(params[:per_page] || 25)
    render json: { number: result.size, data: result }, status: :ok
  end
end
