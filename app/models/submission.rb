# frozen_string_literal: true

# == Schema Information
#
# Table name: submissions
#
#  id                  :bigint           not null, primary key
#  archived_at         :datetime
#  expire_at           :datetime
#  name                :text
#  preferences         :text             not null
#  slug                :string           not null
#  source              :string           not null
#  submitters_order    :string           not null
#  template_fields     :text
#  template_schema     :text
#  template_submitters :text
#  variables           :text
#  variables_schema    :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  account_id          :bigint           not null
#  created_by_user_id  :bigint
#  template_id         :bigint
#
# Indexes
#
#  index_submissions_on_account_id_and_id                           (account_id,id)
#  index_submissions_on_account_id_and_template_id_and_id           (account_id,template_id,id) WHERE (archived_at IS NULL)
#  index_submissions_on_account_id_and_template_id_and_id_archived  (account_id,template_id,id) WHERE (archived_at IS NOT NULL)
#  index_submissions_on_created_by_user_id                          (created_by_user_id)
#  index_submissions_on_slug                                        (slug) UNIQUE
#  index_submissions_on_template_id                                 (template_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_by_user_id => users.id)
#  fk_rails_...  (template_id => templates.id)
#
# frozen_string_literal: true

class Submitter < ApplicationRecord
  belongs_to :submission
  belongs_to :account
  has_one :template, through: :submission
  has_one :search_entry, as: :record, inverse_of: :record, dependent: :destroy if SearchEntry.table_exists?
  has_many :submitter_versions, dependent: :destroy

  attribute :values, :string, default: -> { {} }
  attribute :preferences, :string, default: -> { {} }
  attribute :metadata, :string, default: -> { {} }
  attribute :slug, :string, default: -> { SecureRandom.base58(14) }

  serialize :values, coder: JSON
  serialize :preferences, coder: JSON
  serialize :metadata, coder: JSON

  has_many_attached :documents
  has_many_attached :attachments
  has_many_attached :preview_documents
  has_many :template_accesses, through: :submission
  has_many :email_events, as: :emailable, dependent: (Docuseal.multitenant? ? nil : :destroy)

  has_many :document_generation_events, dependent: :destroy
  has_many :submission_events, dependent: :destroy
  has_many :start_form_submission_events, -> { where(event_type: :start_form) },
           class_name: 'SubmissionEvent', dependent: :destroy, inverse_of: :submitter

  scope :completed, -> { where.not(completed_at: nil) }

  after_destroy :anonymize_email_events, if: -> { Docuseal.multitenant? }

  # 1. Validación de dominio @ucm.es
  validates :email, format: { 
    with: /\A[\w+\-.]+@ucm\.es\z/i, 
    message: "solo se permiten correos institucionales de la Complutense (@ucm.es)" 
  }, if: -> { email.present? }

  # 2. Validación de voto único online
  validates :email, uniqueness: { 
    scope: :submission_id, 
    case_sensitive: false, 
    message: "ya ha firmado este documento. No se permite duplicar el voto." 
  }, if: -> { email.present? }  

  # 3. Validación de mesa física
  validate :no_haya_votado_en_mesa, on: :create, if: -> { email.present? }

  # --- MÉTODOS PÚBLICOS ---

  def status
    if declined_at?
      'declined'
    elsif completed_at?
      'completed'
    elsif opened_at?
      'opened'
    elsif sent_at?
      'sent'
    else
      'awaiting'
    end
  end

  def application_key
    external_id
  end

  def friendly_name
    if name.present? && email.present? && email.exclude?(',')
      %("#{name.delete('"')}" <#{email}>)
    else
      email
    end
  end

  def first_name
    name&.split(/\s+/, 2)&.first
  end

  def last_name
    name&.split(/\s+/, 2)&.last
  end

  def status_event_at
    declined_at || completed_at || opened_at || sent_at || created_at
  end

  def with_signature_fields?
    @with_signature_fields ||= begin
      fields = submission.template_fields || template.fields
      signature_field_types = %w[signature initials]
      fields.any? { |f| f['submitter_uuid'] == uuid && signature_field_types.include?(f['type']) }
    end
  end

  # --- MÉTODOS PRIVADOS ---
  private

  def no_haya_votado_en_mesa
    return if persisted?
    begin
      exists = ActiveRecord::Base.connection.select_value(
        ActiveRecord::Base.sanitize_sql_array([
          "SELECT 1 FROM votos_presenciales WHERE LOWER(email) = LOWER(?) LIMIT 1", 
          email.strip
        ])
      )
      if exists
        errors.add(:email, "ya ha ejercido su voto de forma presencial en una mesa.")
      end
    rescue => e
      Rails.logger.error "CENSO ERROR: #{e.message}"
    end
  end

  def anonymize_email_events
    email_events.each do |event|
      event.update!(email: Digest::MD5.base64digest(event.email))
    end
  end
end
