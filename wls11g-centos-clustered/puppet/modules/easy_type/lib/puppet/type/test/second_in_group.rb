# encoding: UTF-8

newproperty(:second_in_group) do
  include EasyType

  on_apply do | builder|
    'second in group'
  end
end
