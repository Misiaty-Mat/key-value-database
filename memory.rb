# frozen_string_literal: true

class Memory
  def initialize
    @objects_in_memory = {}
    @versions = []
  end

  def set(name, value)
    @versions.last[name] = @objects_in_memory[name] if in_transaction?
    @objects_in_memory[name] = value
    self
  end

  def get(name)
    @objects_in_memory.fetch(name, 'NULL')
  end

  def delete(name)
    @versions.last[name] = @objects_in_memory[name] if in_transaction?
    @objects_in_memory.delete(name)
    self
  end

  def count(value)
    @objects_in_memory.values.tally.fetch(value, 0)
  end

  def begin
    @versions << {}
    self
  end

  def rollback
    return 'NO TRANSACTION' unless in_transaction?

    @objects_in_memory = @objects_in_memory.merge(@versions.last).compact
    @versions.pop
    self
  end

  def commit
    return 'NO TRANSACTION' unless in_transaction?

    @versions = []
    self
  end

  private

  def in_transaction?
    !@versions.empty?
  end
end
