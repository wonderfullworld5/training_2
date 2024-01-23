def create
  binding.pry
  Plan.create(plan_params)
  redirect_to action: :index
end
