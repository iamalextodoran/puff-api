class UserSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :picture, :dark_mode, :selected_at, :danger, :total_expenses, :total_incomes

  has_many :transactions

  def total_expenses
    expenses = object.transactions.where(type_of_t: 'expense')
    this_month_expenses = expenses.where("date > ? AND date < ?", Time.now.beginning_of_month, Time.now.end_of_month)

    this_month_expenses_total = 0
    this_month_expenses.each do |expense|
      this_month_expenses_total += expense.amount.to_f 
    end

    travel = expenses.where(category: 'travel')
    savings = expenses.where(category: 'savings')

    travel_total = 0
    travel.each do |expense|
      travel_total += expense.amount.to_f
    end

    savings_total = 0
    savings.each do |expense|
      savings_total += expense.amount.to_f
    end
    all_savings = savings_total+travel_total

    this_month_expenses_total=1 if this_month_expenses_total==0
    
    travel_percentage = travel_total/ all_savings.to_f
    savings_percentage = savings_total/all_savings.to_f

    travel_percentage =0 if travel_percentage<0
    travel_percentage =1 if travel_percentage>1

    savings_percentage =0 if savings_percentage<0
    savings_percentage =1 if savings_percentage>1

    return {
      total: this_month_expenses_total,
      emergency: all_savings,
      travel: travel_percentage,
      savings: savings_percentage
    }
  end

  def total_incomes
    incomes = object.transactions.where(type_of_t: 'income')
    this_month_incomes = incomes.where("date > ? AND date < ?", Time.now.beginning_of_month, Time.now.end_of_month)

    this_month_incomes_total = 0
    this_month_incomes.each do |income|
      this_month_incomes_total += income.amount.to_f 
    end

    work = this_month_incomes.where(category: 'work')
    freelance = this_month_incomes.where(category: 'freelance')
    scolarship = this_month_incomes.where(category: 'scolarship')
    
    work_total = 0
    work.each do |income|
      work_total += income.amount.to_f
    end

    freelance_total = 0
    freelance.each do |income|
      freelance_total += income.amount.to_f
    end

    scolarship_total = 0
    scolarship.each do |income|
      scolarship_total += income.amount.to_f
    end

    this_month_incomes_total=1 if this_month_incomes_total==0

    work_percentage = work_total/this_month_incomes_total
    freelance_percentage = freelance_total/this_month_incomes_total
    scolarship_percentage = scolarship_total/this_month_incomes_total

    return {
      total: this_month_incomes_total,
      work: work_percentage,
      freelance: freelance_percentage,
      scolarship: scolarship_percentage
    }
  end

end