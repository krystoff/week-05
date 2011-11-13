# 
# Here is where you will write the class Quotes
# 
# For more information about classes I encourage you to review the following:
# 
# @see http://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Classes
# @see Programming Ruby, Chapter 3
# 
# 
# For this exercise see if you can employ the following techniques:
# 
# Use class convenience methods: attr_reader; attr_writer; and attr_accessor.
# 
# Try using alias_method to reduce redundancy.
# 
# @see http://rubydoc.info/stdlib/core/1.9.2/Module#alias_method-instance_method
# 
class Quotes
  
  ## setup static class methods    
  attr_accessor :missing_quote
  ## below defines an override 'reader' method for the above general attr_accessor methods
  def self.missing_quote
    ## returns @val (if it is set) -OR- "the default value"
    ## @val || "default value"
    @missing_quote || "Could not find a quote at this time"
  end
  
 def self.missing_quote=(message)
    @missing_quote = message
  end
  
  ## setup a new method to 'load' in filename (replacement for the passed in param ":file => filename")
  def self.load(filename)
    self.new :file => filename
  end

  attr_reader :file, :all, :quotes
  def initialize(params = {}) ## capture any named parameters passed in via var = {}
    @file = params.delete(:file)
    
    params.each do |key,value| ## iterate over passed in params
      ## if class responds to the method named by 'key', then set 'key,value' pair via send
      ## requires that the method named by 'key' is defined within your class
      send("#{key}=",value) if respond_to? "#{key}="
    end

    @quotes = all_quotes(@file) || []
    #@quotes = []  ## setup empty instance-variable array
  
  end
  
  attr_accessor :file, :quotes
  ## alias reader methods
  alias_method :all, :quotes  ## links :new to :existing
  
  ## alias writer methods
  #alias_method :all=, :quotes=  ## links :new= to :existing=
  
  
  def find(line)
    unless File.exists? @file
      Quotes.missing_quote
    else  
      #@line = line
      @quotes[line] || @quotes[0]
    end
  end
  
  def search(params = {})
    @quotes.map do |quote|
      #quote
      params.empty? ? quote : params.map {|key,value| quote if quote.send("#{key}?",value) }.uniq
    end.flatten.compact.uniq
  end
  

  ## alias :[] to :find above
  alias_method :[], :find
  
  #def find(line)
  #  unless File.exists? @file
  #    "Could not find a quote at this time"
  #  else  
  #    @line = line
  #  end    
  #end
  
  #@quotes = @quotes(@line)
  #@quotes = all_quotes(@file) unless @quotes
end

def all_quotes(filename)
  # readlines will return an array of lines but includes the newline character "\n"
  # here we strip that off of all the quotes.
  if File.exists? filename
    File.readlines(filename).map {|quote| quote.strip }
  else
    #[]
    #["Could not find a quote at this time"]
  end
end
