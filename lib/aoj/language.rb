module AOJ
  module Language
    @languages = [
      :c, :cpp, :cpp11, :java, :ruby
    ].freeze

    @map_extname_label = {
      ".c"    => :c,
      '.cpp'  => :cpp,
      '.cc'   => :cpp,
      '.C'    => :cpp,
      '.java' => :java,
      '.rb'   => :ruby
    }.freeze

    @map_label_submit_name = {
      :c     => "C",
      :cpp   => "C++",
      :java  => "JAVA",
      :ruby  => "Ruby",
      :cpp11 => "C++11"
    }.freeze

    class << self
      attr_reader :languages, :map_extname_label, :map_label_submit_name
    end
  end
end
