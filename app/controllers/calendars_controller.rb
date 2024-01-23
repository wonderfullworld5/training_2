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

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = plans.select { |plan| plan.date == @todays_date + x }.map(&:plan)
    
      wday_num = (@todays_date + x).wday
    
      if wday_num >= 7
        wday_num = wday_num - 7
      end
    
      days = { month: (@todays_date + x).month, date: (@todays_date + x).day, plans: today_plans, wday: Date::DAYNAMES[wday_num]}
      @week_days.push(days)
    end
  end
end
