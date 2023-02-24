# frozen_string_literal: true

# Node class
class Node
  attr_accessor :value, :left, :right

  def initialize
    @value = nil
    @left = nil
    @right = nil
  end

  def print
    puts "Node #{@value}"
    puts "Left Child: #{@left.value}" unless @left.nil?
    puts "Right Child: #{@right.value}" unless @right.nil?
    puts "\n"
  end
end

# tree class
class Tree
  def initialize(array)
    build_tree(array)
  end

  def build_tree(array)
    @root = recursive_tree_build(array.sort.uniq)
  end

  def recursive_tree_build(sorted_array)
    return nil if sorted_array.empty?

    index = sorted_array.size / 2
    new_node = Node.new
    new_node.value = sorted_array[index]
    new_node.left = recursive_tree_build(sorted_array[0...index])
    new_node.right = recursive_tree_build(sorted_array[index + 1..])
    new_node
  end

  def insert(value)
    # return unless find(value).nil?

    new_node = Node.new
    new_node.value = value

    return (@root = new_node) if @root.nil?

    recursive_insert_node(new_node, @root)
  end

  def find(value)
    recursive_find(value, @root)
  end

  def level_order
    queue = [@root]
    result_array = []

    until queue.empty?
      cur_node = queue.pop
      if block_given?
        yield(cur_node)
      else
        result_array.push(cur_node.value)
      end
      queue.prepend(cur_node.left) unless cur_node.left.nil?
      queue.prepend(cur_node.right) unless cur_node.right.nil?
    end
    result_array
  end

  def delete(value)
    return if find(value).nil?

    del_node = find(value)
    prev_del_node = find_predecessor(value)

    if del_node.left.nil? && del_node.right.nil?
      leaf_deletion(del_node, prev_del_node)
    elsif del_node.left.nil?
      right_deletion(del_node, prev_del_node)
    elsif del_node.right.nil?
      left_deletion(del_node, prev_del_node)
    else
      two_child_deletion(del_node)
    end
  end

  private

  def right_deletion(node, prev_node)
    return (@root = node.right) if prev_node.nil?

    if prev_node.left.value == node.value
      prev_node.left = node.right
    else
      prev_node.right = node.right
    end
  end

  def find_predecessor(value)
    recursive_find_predecssor(value, @root)
  end

  def left_deletion(node, prev_node)
    return (@root = node.left) if prev_node.nil?

    if prev_node.left.value == node.value
      prev_node.left = node.left
    else
      prev_node.right = node.left
    end
  end

  def two_child_deletion(node)
    successor = find_inorder_successor(node)

    new_value = successor.value
    delete(new_value)
    node.value = new_value
  end

  def find_inorder_successor(node) 
    cur_node_ptr = node.right # Assumes that there is a successor (i.e. node.right exists)
    cur_node_ptr = cur_node_ptr.left until cur_node_ptr.left.nil?
    cur_node_ptr
  end

  def leaf_deletion(node, prev_node)
    return (@root = nil) if prev_node.nil?

    if prev_node.left.value == node.value
      prev_node.left = nil
    else
      prev_node.right = nil
    end
  end

  def recursive_insert_node(new_node, node_ptr)
    if new_node.value < node_ptr.value
      if node_ptr.left.nil?
        node_ptr.left = new_node
      else
        recursive_insert_node(new_node, node_ptr.left)
      end
    else
      if node_ptr.right.nil?
        node_ptr.right = new_node
      else
        recursive_insert_node(new_node, node_ptr.right)
      end
    end
  end

  def recursive_find(value, node_ptr)
    return nil if node_ptr.nil?

    return node_ptr if node_ptr.value == value

    return recursive_find(value, node_ptr.left) if value < node_ptr.value

    recursive_find(value, node_ptr.right)
  end

  def recursive_find_predecssor(value, node_ptr)
    return nil if node_ptr.nil?

    return node_ptr if (!node_ptr.left.nil? && node_ptr.left.value == value) ||
                       (!node_ptr.right.nil? && node_ptr.right.value == value)

    return recursive_find_predecssor(value, node_ptr.left) if value < node_ptr.value

    recursive_find_predecssor(value, node_ptr.right)
  end
end

tree = Tree.new([1,2,3,4,5,6])
tree.delete(4)
tree.level_order { |node| node.print }

puts 'All done!'
