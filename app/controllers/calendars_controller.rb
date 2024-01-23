class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private
  def plan_params
    params.require(:calendars).permit(:date, :plan)
  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']
    def japanese_weekday_name(wday_num)
      weekday_names = ["日", "月", "火", "水", "木", "金", "土"]
      weekday_names[wday_num]
    end

    @todays_date = Date.today

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = plans.select { |plan| plan.date == @todays_date + x }.map(&:plan)

      wday_num = (@todays_date + x).wday
      wday_num = 0 if wday_num == 7 # wdayが7の場合、0に修正する

      days = { month: (@todays_date + x).month, date: (@todays_date + x).day, plans: today_plans, wday:japanese_weekday_name(wday_num)}
      @week_days.push(days)
    end
  end
end
