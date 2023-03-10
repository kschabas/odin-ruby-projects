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
  attr_reader :root

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

  def height(node)
    return -1 if node.nil?

    1 + [height(node.left), height(node.right)].max
  end

  def depth(node)
    recursive_depth(@root, node, 0)
  end

  def balanced?
    result = true
    inorder { |node| result &&= ((height(node.left) - height(node.right)).abs <= 1) }
    result
  end

  def rebalance
    new_array = inorder
    build_tree(new_array)
  end

  def level_order(&block)
    queue = [@root]
    result_array = []

    until queue.empty?
      cur_node = queue.pop
      yield_node(cur_node, result_array, block)
      queue.prepend(cur_node.left) unless cur_node.left.nil?
      queue.prepend(cur_node.right) unless cur_node.right.nil?
    end
    result_array
  end

  def inorder(&block)
    recursive_inorder(@root, [], block)
  end

  def preorder(&block)
    recursive_preorder(@root, [], block)
  end

  def postorder(&block)
    recursive_postorder(@root, [], block)
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

  def yield_node(node, result_array, block)
    if block.nil?
      result_array.push(node.value)
    else
      block.call(node)
    end
  end

  def find_predecessor(value)
    recursive_find_predecessor(value, @root)
  end

  def recursive_depth(node, target, level)
    return -1 if node.nil?
    return level if node.value == target.value

    [recursive_depth(node.left, target, level + 1), recursive_depth(node.right, target, level + 1)].max
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

  def recursive_inorder(node, result_array, block)
    return if node.nil?

    recursive_inorder(node.left, result_array, block)
    yield_node(node, result_array, block)
    recursive_inorder(node.right, result_array, block)
    result_array
  end

  def recursive_preorder(node, result_array, block)
    return if node.nil?

    yield_node(node, result_array, block)
    recursive_preorder(node.left, result_array, block)
    recursive_preorder(node.right, result_array, block)
    result_array
  end

  def recursive_postorder(node, result_array, block)
    return if node.nil?

    recursive_postorder(node.left, result_array, block)
    recursive_postorder(node.right, result_array, block)
    yield_node(node, result_array, block)
    result_array
  end

  def leaf_deletion(node, prev_node)
    return (@root = nil) if prev_node.nil?

    if !prev_node.left.nil? && prev_node.left.value == node.value
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

  def recursive_find_predecessor(value, node_ptr)
    return nil if node_ptr.nil?

    return node_ptr if (!node_ptr.left.nil? && node_ptr.left.value == value) ||
                       (!node_ptr.right.nil? && node_ptr.right.value == value)

    return recursive_find_predecessor(value, node_ptr.left) if value < node_ptr.value

    recursive_find_predecessor(value, node_ptr.right)
  end
end

tree = Tree.new([4, 12, 10, 18, 24, 22, 15, 31, 44, 35, 66, 90, 70, 50, 25])
#tree.postorder { |node| node.print }
# result =  tree.inorder

array = (Array.new(15) { rand(1..100) })
tree = Tree.new(array)
puts tree.balanced?
puts tree.level_order
puts tree.preorder
puts tree.postorder
puts tree.inorder
tree.insert(110)
tree.insert(120)
tree.insert(130)
tree.insert(140)
tree.insert(150)
tree.insert(160)
tree.insert(170)
puts tree.balanced?
tree.rebalance
puts tree.level_order
puts tree.preorder
puts tree.postorder
puts tree.inorder
