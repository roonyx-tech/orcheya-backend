class ApplicationService
  # :nocov:
  def self.call(*args, &block)
    new(*args, &block).call
  end
  # :nocov:
end
