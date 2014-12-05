require 'therubyracer'

cxt = V8::Context.new
p cxt.eval('7 * 6')
