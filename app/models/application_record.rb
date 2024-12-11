# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  default_scope { where(id: 0..) }

  def self.id_prefix
    raise ArgumentError, "id_prefix must be defined on models"
  end

  def public_id
    ApplicationRecord.encode_id(self.class, self.id)
  end

  def public_id=(pid)
    self.id = ApplicationRecord.decode_id(self.class, pid)
  end

  def self.encode_id(model, id)
    Crockford32.encode(ApplicationRecord.wrap_id(model.id_prefix, id), check: true)
  end

  def self.decode_id(model, pid)
    ApplicationRecord.unwrap_id(Crockford32.decode(pid, check: true, into: :string),
                                model.id_prefix)
  end

  #private

  # Wraps the id in the dynamic class's name, allowing different types of objects
  # to have different public ids even if their db id is the same integer.
  def self.wrap_id(prefix, id)
    id_s = id.to_s
    xor_s(id_s, lengthen_prefix(prefix, id_s))
  end

  # Unwraps a packaged id and returns the integer id used by the db for this
  # given object.
  def self.unwrap_id(wrapped, prefix)
    Integer(xor_s(wrapped, lengthen_prefix(prefix, wrapped)), 10)
  end

  def self.xor_s(a, b)
    a.unpack('C*').zip(b.unpack('C*')).map { |x, y| x ^ y }.pack('C*')
  end

  def self.lengthen_prefix(prefix, to_encode)
    times = to_encode.length / prefix.length
    extra = to_encode.length % prefix.length
    pad = ""
    pad = prefix[..extra - 1] unless extra.zero?
    prefix * times + pad
  end
end
