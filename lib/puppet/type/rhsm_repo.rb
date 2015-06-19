require 'puppet/property/boolean'
require 'puppet/type'

Puppet::Type.newtype(:rhsm_pool) do
  @doc = "Subscribe to a specific subscription pool"

  ensurable

  newparam(:id, :namevar => true) do
    desc "The ID of the subscription pool to attach to."
  end

end
