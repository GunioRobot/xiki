class Ruby
  def self.menu
    "
    - .classes/
    - .re_index_fast_ri/
    - .menu/
    - .docs/
      | Evaluate the ruby code on the following lines, until a '> ...' heading.
      @eval
    - @eval/
    "
  end

  def self.classes clazz=nil, method=nil

    # If no params, show list of classes

    if clazz.nil?
      result = []
      ObjectSpace.each_object(Class) do |c|
        name = c.to_s
        next if name =~ /^#/
        result << "- #{name}/\n"
      end
      return result.sort.join
    end

    # If just class, show methods

    if method.nil?
      result = ""
      result << Kernel.const_get(clazz).instance_methods(false).sort.
        collect {|i| "- #{i}/" }.join("\n")
      result << Kernel.const_get(clazz).methods(false).sort.
        collect {|i| "- ::#{i}/" }.join("\n")
      return result
    end

    # If method passed, lookup method's doc

    method = "##{method}" unless method =~ /^::/
    command = "qri #{clazz}#{method}"
    Console[command].gsub(/\C-[.+?m/, '').gsub(/^/, '| ').gsub(/^\| +$/, '|')
  end

  def self.re_index_fast_ri
    Console.run "fastri-server -b"
  end
end
