module VpsAdmindCtl::Commands
  class Pause < VpsAdmindCtl::Command
    args '[ID]'
    description 'Pause execution of queued transactions'

    def validate
      if @args.size > 2
        raise VpsAdmindCtl::ValidationError.new('too many arguments')

      elsif specific?
        raise VpsAdmindCtl::ValidationError.new('invalid transaction id') unless @args[1] =~ /^\d+$/
      end
    end

    def prepare
      {:t_id => specific? ? @args[1].to_i : nil}
    end

    def process
      if specific?
        puts 'Pause scheduled'
      else
        puts 'Paused'
      end
    end

    def specific?
      @args.size == 2
    end
  end
end
