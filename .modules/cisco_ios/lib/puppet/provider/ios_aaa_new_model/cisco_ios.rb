require_relative '../../util/network_device/cisco_ios/device'
require_relative '../../../puppet_x/puppetlabs/cisco_ios/utility'

# Configure aaa new model on the device
class Puppet::Provider::IosAaaNewModel::CiscoIos
  def self.commands_hash
    @commands_hash ||= PuppetX::CiscoIOS::Utility.load_yaml(File.expand_path(__dir__) + '/command.yaml')
  end

  def self.instances_from_cli(output)
    new_instance_fields = []
    new_instance = PuppetX::CiscoIOS::Utility.parse_resource(output, commands_hash)
    new_instance[:name] = 'default'
    new_instance[:enable] = if new_instance[:enable]
                              true
                            else
                              false
                            end
    new_instance.delete_if { |_k, v| v.nil? }
    new_instance_fields << new_instance
    new_instance_fields
  end

  def self.commands_from_instance(instance)
    commands = []
    instance[:enable] = if instance[:enable]
                          ''
                        else
                          'no '
                        end
    commands += PuppetX::CiscoIOS::Utility.build_commmands_from_attribute_set_values(instance, commands_hash)
    commands
  end

  def commands_hash
    Puppet::Provider::IosAaaNewModel::CiscoIos.commands_hash
  end

  def get(context)
    output = context.transport.run_command_enable_mode(PuppetX::CiscoIOS::Utility.get_values(commands_hash))
    return [] if output.nil?
    return_value = Puppet::Provider::IosAaaNewModel::CiscoIos.instances_from_cli(output)
    PuppetX::CiscoIOS::Utility.enforce_simple_types(context, return_value)
  end

  def set(context, changes)
    changes.each do |name, change|
      should = change[:should]
      context.updating(name) do
        update(context, name, should)
      end
    end
  end

  def update(context, _name, should)
    array_of_commands_to_run = Puppet::Provider::IosAaaNewModel::CiscoIos.commands_from_instance(should)
    array_of_commands_to_run.each do |command|
      context.transport.run_command_conf_t_mode(command)
    end
  end
end
