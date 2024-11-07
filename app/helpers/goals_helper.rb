module GoalsHelper
  def client_application_options
    ClientApplication.all.pluck(:name, :id)
  end
end
