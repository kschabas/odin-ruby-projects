def stock_picker(prices)
    max_profit = 0
    buy_index = -1
    sell_index = -1
    len = prices.length
    prices.each_index do |index|
        profit = prices[index...len].max - prices[index]
        if profit > max_profit
            max_profit = profit
            buy_index = index
            sell_index = prices[index...len].find_index(profit+prices[index]) + index
        end
    end
    result = [buy_index, sell_index]
end
