require "spec_helper"

require "csv"

describe '#calculate_basic_sales' do
  it 'should calculate exempt tax items' do
    sales = CSV.parse("quantity,name,price\n,2,book at,12.49")
    expect do
      calculate_basic_sales(sales).to output('2 book:  24.98').to_stdout
    end
  end

  it 'should calculate imported tax items' do
    sales = CSV.parse("quantity,name,price\n,1,imported box of chocolates at,10.00")
    expect do
      calculate_basic_sales(sales).to output('1 imported box of chocolates: 10.50').to_stdout
    end
  end
end