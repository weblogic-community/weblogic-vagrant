# encoding: UTF-8

newproperty(:first_in_group) do
  include EasyType

  on_apply do | builder|
    'first in group'
  end
end
