# == Schema Information
#
# Table name: role_documents
#
#  id          :bigint(8)        not null, primary key
#  role_id     :bigint(8)
#  document_id :bigint(8)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_role_documents_on_document_id  (document_id)
#  index_role_documents_on_role_id      (role_id)
#

FactoryBot.define do
  factory :role_step do
    role { Role.random }
    document { Step.random }
  end
end
