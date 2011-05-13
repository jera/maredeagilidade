class AddOrganizationFieldsToRegistration < ActiveRecord::Migration
  def self.up
    add_column(:registrations, :company_name, :string)
    add_column(:registrations, :document_number, :string)
  end

  def self.down
    remove_column(:registrations, :company_name)
    remove_column(:registrations, :document_number)
  end
end
