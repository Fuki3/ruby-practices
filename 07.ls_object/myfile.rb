# frozen_string_literal: true

class MyFile
  attr_reader :files

  def initialize(params)
    @files = params[:a] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    @files = params[:r] ? @files.sort.reverse : @files.sort
  end

  def count_bytesize(array_element)
    array_element.encode('EUC-JP').bytesize
  end

  def count_size_max
    @files.map { |file| count_bytesize(file) }.max
  end

  def slice(first, final, element_count)
    @files[first..final].each_slice(element_count).to_a
  end
end
