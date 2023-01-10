#!/usr/bin/env ruby

require "csv"

BASIC_SALES_RATE = 0.1
IMPORTED_RATE = 0.05

sales = CSV.parse(File.read(ARGV[0]), headers: true)

Item = Struct.new(:quantity, :name, :price) do
    def exempt?
        ["book", "pills", "chocolate", "chocolates"].any? { |word| name.include?(word) }
    end

    def imported?
        name.include?("imported")
    end

    def imported_tax
        return 0.0 unless imported?

        normalized_price * IMPORTED_RATE 
    end

    def basic_sales_tax
        return 0.0 if exempt?

        normalized_price * BASIC_SALES_RATE
    end

    def total
        return (normalized_price * normalized_quantity) if exempt? && !imported?

        if exempt? && imported?
            ((imported_tax + normalized_price) * normalized_quantity).round(2)
        else
            ((imported_tax + basic_sales_tax + normalized_price) * normalized_quantity).round(2)
        end
    end

    def output_name
        name.gsub(/\b at\b/, ": ")
    end

    def normalized_price
        price.to_f
    end

    def normalized_quantity
        quantity.to_f
    end
end

def calculate_basic_sales(sales)
    taxes = []
    totals = []

    sales.each do |sale|
        item = Item.new(sale["quantity"], sale["name"], sale["price"])
        taxes << item.imported_tax + item.basic_sales_tax
        totals << item.total
        puts "#{item.quantity} #{item.output_name} #{item.total}"
    end

    puts "Sales Taxes: #{taxes.sum.round(2)}"
    puts "Total: #{totals.sum.round(2)}"
end

if $0 == __FILE__
    calculate_basic_sales(sales)
end
