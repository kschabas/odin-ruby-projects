#frozen_string_literal: true

class KnightNode
  attr_accessor :loc, :path

  def initialize(array, path)
    @loc = array
    @path = path
  end
end

class KnightMoves
  def initialize
  end

  def knight_moves(start, finish)
    queue = [KnightNode.new(start, [])]
    new_path = nil

    loop do
      node = queue.pop
      (node = queue.pop) until valid?(node.loc)
      new_path = Array.new(node.path) << node.loc
      break if node.loc == finish
      queue.prepend(KnightNode.new([node.loc[0] + 1, node.loc[1] + 2], new_path))
      queue.prepend(KnightNode.new([node.loc[0] + 2, node.loc[1] + 1], new_path))
      queue.prepend(KnightNode.new([node.loc[0] + 2, node.loc[1] - 1], new_path))
      queue.prepend(KnightNode.new([node.loc[0] + 1, node.loc[1] - 2], new_path))
      queue.prepend(KnightNode.new([node.loc[0] - 1, node.loc[1] - 2], new_path))
      queue.prepend(KnightNode.new([node.loc[0] - 2, node.loc[1] - 1], new_path))
      queue.prepend(KnightNode.new([node.loc[0] - 2, node.loc[1] + 1], new_path))
      queue.prepend(KnightNode.new([node.loc[0] - 1, node.loc[1] + 2], new_path))
    end
    print(new_path)
  end

  private

  def valid?(loc)
    return loc[0] >= 0 && loc[0] < 8 && loc[1] >= 0 && loc[1] < 8
  end

  def print(path)
    puts "You made it in #{path.size - 1} moves! Here's your path:"
    path.each {|coord| puts "[#{coord[0]},#{coord[1]}]"}
    puts "\n"
  end
end

test = KnightMoves.new
test.knight_moves([3,3], [0,7])