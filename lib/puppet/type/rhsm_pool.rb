require 'puppet/property/boolean'
require 'puppet/type'

Puppet::Type.newtype(:rhsm_pool) do
  @doc = <<EOD
An Entitlement Pool from which active subscriptions can be drawn.

This is also commonly called a subscription, RPM Pool or repository but
properly refers to the synthetic view of repositories created inside the server.

Example:

rhsm_pool { '1a2b3c4d5e6f1234567890abcdef12345':
  name              => 'Extra Packages for Enterprise Linux',
  ensure            => present,
  provides          => 'EPEL',
  sku               => 1234536789012,
  contract          => 'Fancy Widgets, LTD',
  account           => '1234-12-3456-0001',
  serial            => 1234567890123456789,
  id                => 1a2b3c4d5e6f1234567890abcdef12345,
  active            => true,
  quantity_used     => 1,
  service_level     => 'STANDARD',
  service_type      => 'EOL',
  status_details    => 'expired',
  subscription_type => 'permanent',
  starts            => 06/01/2015,
  ends              => 05/24/2045,
  system_type       => physical,
}
EOD

ensurable do

  newvalue(:present) do
    provider.create
  end

  newvalue(:absent) do
    provider.destroy
  end

  def insync?(is)

    @should.each do |should|
      case should
      when :present
        return true if is == :present
      when :absent
        return true if is == :absent
      end
    end
    return false
  end
  defaultto :present
end

  newparam(:id, :namevar => true) do
    desc "An Entitlement Pool to which the server is subscribed (Pool ID)"
    validate do |value|
     raise fail("Pool ID must be an number, was given #{value}") unless value =~ /^\h+$/
    end
  end

  newproperty(:provides) do
    desc "What does this pool provide?"
    end

  newproperty(:sku) do
    desc "Stockkeeping Unit identification for this item?"
    validate do |value|
     raise fail("SKU must be an number, was given #{value}") unless value.is_a? Numeric
    end
  end

  newproperty(:contract) do
    desc "Identification of the contract for the subscription to this pool"
  end

  newproperty(:account) do
    desc "Identification of the account for the subscription to this pool"
  end

  newproperty(:serial) do
    desc "Serial number on the server for this pool"
    validate do |value|
     raise fail("Serial number must be an number, was given #{value}") unless value.is_a? Numeric
    end
  end

  newproperty(:name) do
    desc "A locally unique idenification for this pool"
  end

  newproperty(:active) do
    desc "Is this pool active or inactive for this system"
    newvalues('True','False')
  end

  newproperty(:quantity_used) do
    desc "How many subscriptions are used for this pool (e.g. Sockets for per CPU licenses)"
    validate do |value|
     raise fail("Quantity Used must be an number, was given #{value}") unless value.is_a? Numeric
    end
  end

  newproperty(:service_level) do
    desc "The service level for this subscription to the pool"
  end

   newproperty(:service_type) do
    desc "The type of service provided"
   end

  newproperty(:status_details) do
    desc "Freeform details about the status of the pool subscription"
  end

  newproperty(:subscription_type) do
    desc "The type of subscription to this pool the server has"
  end


  newproperty(:starts) do
    desc "When does this subscription to the pool start?"
    validate do |value|
     raise fail("Starts must be a date, was given #{value}") unless value.is_a? Date
    end
  end

  newproperty(:ends) do
    desc "When does this subscription to the pool end?"
    validate do |value|
     raise fail("Ends must be a date, was given #{value}") unless value.is_a? Date
    end
  end

  newproperty(:system_type) do
    desc "Is this a physcial, virtual or container system"
    newvalues('physical', 'virtual', 'container')
  end

end
