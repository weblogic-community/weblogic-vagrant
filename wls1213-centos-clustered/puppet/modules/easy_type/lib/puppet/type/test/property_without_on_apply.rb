# encoding: UTF-8

newproperty(:property_without_on_apply) do
  include EasyType

  on_create do | command_builder|
    'on_create called'
  end

  on_modify do | command_builder|
    'on_modify called'
  end

end
