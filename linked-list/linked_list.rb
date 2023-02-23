# frozen_string_literal: true

# Node for a linked list
class Node
  attr_accessor :value, :next_node

  def initialize
    @value = nil
    @next_node = nil
  end
end

# Linked list class for assignment
class LinkedList
  attr_reader :head, :tail

  def initialize
    @head = nil
    @tail = nil
  end

  def new_node(value)
    node = Node.new
    node.value = value
    node
  end

  def append(value)
    new_node = new_node(value)
    @tail.next_node = new_node unless @tail.nil?
    @tail = new_node
    @head = new_node if @head.nil?
  end

  def prepend(value)
    new_node = new_node(value)
    new_node.next_node = @head
    @head = new_node
    @tail = new_node if @tail.nil?
  end

  def size
    result = 0
    cur_ptr = @head
    until cur_ptr.nil?
      result += 1
      cur_ptr = cur_ptr.next_node
    end
    result
  end

  def at(index)
    cur_index = 0
    cur_ptr = @head
    until cur_index == index
      cur_ptr = cur_ptr.next_node
      cur_index += 1
    end
    cur_ptr
  end

  def pop
    if @head == @tail
      @head = nil
      @tail = nil
    else
      cur_ptr = @head
      cur_ptr = cur_ptr.next_node until cur_ptr.next_node == @tail
      @tail = cur_ptr
      @tail.next_node = nil
    end
  end

  def contains?(value)
    cur_ptr = @head
    until cur_ptr.nil?
      return true if cur_ptr.value == value

      cur_ptr = cur_ptr.next_node
    end
    false
  end

  def find(value)
    cur_ptr = @head
    index = 0

    until cur_ptr.nil?
      return index if cur_ptr.value == value

      index += 1
      cur_ptr = cur_ptr.next_node
    end
    nil
  end

  def to_s
    cur_ptr = @head
    until cur_ptr.nil?
      print "(#{cur_ptr.value}) -> "
      cur_ptr = cur_ptr.next_node
    end
    print "nil\n"
  end

  def insert_at(value, index)
    if index.zero?
      prepend(value)
    elsif index == size
      append(value)
    else
      new_node = Node.new
      new_node.value = value
      prev_node = at(index - 1)
      cur_node = at(index)
      prev_node.next_node = new_node
      new_node.next_node = cur_node
    end
  end

  def remove_at(index)
    if index.zero?
      @head = @head.next_node
    else
      prev_node = at(index - 1)
      cur_node = at(index)
      prev_node.next_node = cur_node.next_node
      @tail = prev_node if @tail == cur_node
    end
  end
end
