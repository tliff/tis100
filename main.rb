require './lib/tis100.rb'
require 'pp'


machine = TIS100::Machine.new do
  i = input
  o = output

  mynode = node([
    'mov up acc',
    'add 1',
    'mov acc down',
    ])

  connect(i, mynode[:up])
  connect(mynode[:down], o)
end

out = machine.run([[1, 2, 3]])
pp out