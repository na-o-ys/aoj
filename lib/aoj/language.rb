module AOJ
  module Language
    @languages = [
      :c, :cpp, :cpp11, :java, :ruby, :csharp, 
      :d, :python, :python3, :php, :javascript
    ]

    # TODO: config overwrite
    @map_extname_label = {
      ".c"    => :c,
      ".cpp"  => :cpp,
      ".cc"   => :cpp,
      ".C"    => :cpp,
      ".java" => :java,
      ".rb"   => :ruby,
      ".cs"   => :csharp,
      ".d"    => :d,
      ".py"   => :python,
      ".php"  => :php,
      ".js"   => :javascript
    }

    @map_label_submit_name = {
      :c          => "C",
      :cpp        => "C++",
      :java       => "JAVA",
      :ruby       => "Ruby",
      :cpp11      => "C++11",
      :csharp     => "C#",
      :d          => "D",
      :python     => "Python",
      :php        => "PHP",
      :javascript => "JavaScript"
    }

    class << self
      attr_reader :languages, :map_extname_label, :map_label_submit_name
    end
  end
end
