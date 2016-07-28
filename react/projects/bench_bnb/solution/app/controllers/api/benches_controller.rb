class Api::BenchesController < ApplicationController
  before_action :require_logged_in, only: [:create]
  def index
    benches = Bench.all
    if(bounds)
      benches = Bench.in_bounds(bounds)
    end

    if (params[:minSeating] && params[:maxSeating])
      benches = benches.where(seating: seating_range)
    end
    @benches = benches.includes(:reviews, :favorite_users)
    render :index
  end

  def create
    @bench = Bench.create!(bench_params)
    render :show
  end

  private

  def seating_range
    (params[:minSeating]..params[:maxSeating])
  end

  def bench_params
    params.require(:bench).permit(
      :lat,
      :lng,
      :description,
      :seating,
      :picture_url
    )
  end

  def bounds
    params[:bounds]
  end
end