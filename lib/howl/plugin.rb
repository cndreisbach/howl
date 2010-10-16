# Adapted from Jekyll's Plugin class.

module Howl
  class Plugin
    PRIORITIES = { :lowest => -100,
                   :low => -10,
                   :normal => 0,
                   :high => 10,
                   :highest => 100 }

    # Install a hook so that subclasses are recorded. This method is only
    # ever called by Ruby itself.
    #
    # base - The Class subclass.
    #
    # Returns nothing.
    def self.inherited(base)
      subclasses << base
      subclasses.sort!
    end

    # The list of Classes that have been subclassed.
    #
    # Returns an Array of Class objects.
    def self.subclasses
      @subclasses ||= []
    end

    # Get or set the priority of this plugin. When called without an
    # argument it returns the priority. When an argument is given, it will
    # set the priority.
    #
    # priority - The Symbol priority (default: nil). Valid options are:
    #            :lowest, :low, :normal, :high, :highest
    #
    # Returns the Symbol priority.
    def self.priority(priority = nil)
      if priority && PRIORITIES.has_key?(priority)
        @priority = priority
      end
      @priority || :normal
    end

    def <=>(other)
      other.priority <=> self.priority
    end
  end

end
