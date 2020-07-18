class Tree
  attr_reader :root

  def initialize(arr)
    @root = build_tree(arr)
  end

  def build_tree(arr)
    return if arr.length == 0

    arr = arr.uniq.sort
    middle = arr[arr.length / 2]
    root = Node.new(middle)

    return root if arr.length == 1

    root.left = build_tree(arr[0..(arr.length / 2) - 1])
    root.right = build_tree(arr[(arr.length / 2) + 1..-1])

    root
  end

  def insert(value)
    node = @root
    return @root = Node.new(value) unless node

    while node do
      return node if node.value == value
      if node.value > value
        if node.left
          node = node.left
        else
          node.left = Node.new(value)
          return node.left
        end
      elsif node.value < value
        if node.right
          node = node.right
        else
          node.right = Node.new(value)
          return node.right
        end
      end
    end
  end

  def delete(value)
    node = find(value)
    return unless node

    successor = find_next(value)
    return change_parent(node, nil) unless successor

    if node.right == successor
      successor.left = node.left
    elsif node.left != successor
      successor_parent = find_parent(successor)
      successor_parent.left = successor.right
      successor.left = node.left
      successor.right = node.right
    end

    change_parent(node, successor)
  end

  def find(value)
    node = @root
    return unless node

    while node do
      return node if node.value == value
      node = node.value > value ? node.left : node.right
    end
  end

  def level_order
    return unless @root
    order = []
    queue = []
    queue << @root

    while !queue.empty? do
      node = queue.first
      order << node.value
      queue << node.left if node.left
      queue << node.right if node.right
      queue.shift
    end

    order
  end

  def preorder(node = @root)
    return unless node
    order = []
    order << node.value
    order << preorder(node.left) if node.left
    order << preorder(node.right) if node.right
    order.flatten
  end

  def inorder(node = @root)
    return unless node
    order = []
    order << inorder(node.left) if node.left
    order << node.value
    order << inorder(node.right) if node.right
    order.flatten
  end

  def postorder(node = @root)
    return unless node
    order = []
    order << postorder(node.left) if node.left
    order << postorder(node.right) if node.right
    order << node.value
    order.flatten
  end

  def depth(node = @root)
    return -1 unless node
    left = depth(node.left)
    right = depth(node.right)
    return [left, right].max + 1
  end

  def balanced?
    return depth - shortest_depth > 1 ? false : true
  end

  def rebalance
    arr = self.level_order
    @root = build_tree(arr)
  end

  def pretty_print(node = @root, prefix = "", is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? "│ " : " "}", false) if node.right
    puts "#{prefix}#{is_left ? "└── " : "┌── "}#{node.value.to_s}"
    pretty_print(node.left, "#{prefix}#{is_left ? " " : "│ "}", true) if node.left
  end

  private

  def find_next(value)
    node = find(value)
    return unless node
    return node.left unless node.right

    node = node.right
    return node if node.value == value
    
    while node.left do
      node = node.left
    end
    node
  end

  def find_parent(child_node)
    node = @root
    return unless node

    while node do
      return node if node.left == child_node || node.right == child_node
      node = node.value > child_node.value ? node.left : node.right
    end
  end

  def change_parent(old_node, new_node)
    parent = find_parent(old_node)
    if parent
      if parent.left == old_node
        parent.left = new_node
      else
        parent.right = new_node
      end
    else
      @root = new_node
    end
  end

  def shortest_depth(node = @root)
    return -1 unless node
    left = shortest_depth(node.left)
    right = shortest_depth(node.right)
    return [left, right].min + 1
  end

end

class Node
  attr_accessor :left, :right
  attr_reader :value

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end

end

arr = Array.new(15) { rand(1..100) }
tree = Tree.new(arr)

puts "Balanced: #{tree.balanced?}"

puts "Level order:"
p tree.level_order
puts "Preorder:"
p tree.preorder
puts "Postorder:"
p tree.postorder
puts "Inorder:"
p tree.inorder

puts "Insert 110"
tree.insert(110)
puts "Insert 115"
tree.insert(115)
puts "Insert 120"
tree.insert(120)
puts "Insert 125"
tree.insert(125)
puts "Insert 130"
tree.insert(130)

puts "Balanced: #{tree.balanced?}"

puts "Rebalancing..."
tree.rebalance

puts "Balanced: #{tree.balanced?}"

puts "Level order:"
p tree.level_order
puts "Preorder:"
p tree.preorder
puts "Postorder:"
p tree.postorder
puts "Inorder:"
p tree.inorder