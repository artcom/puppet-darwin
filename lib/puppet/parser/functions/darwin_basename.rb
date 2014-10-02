module Puppet::Parser::Functions
  newfunction(:darwin_basename, :type => :rvalue, :doc => <<-EOS
    Returns the basename of a path.
    EOS
  ) do |arguments|
    return File.send(:basename, *arguments)
  end
end

# vim: set ts=2 sw=2 et :

