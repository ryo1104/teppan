class StripeAccountForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include StripeUtils

  attribute   :last_name_kanji, :string
  attribute   :last_name_kana, :string
  attribute   :first_name_kanji, :string
  attribute   :first_name_kana, :string
  attribute   :gender, :string
  attribute   :email, :string
  attribute   :dob, :datetime
  attribute   :postal_code, :string
  attribute   :kanji_state, :string
  attribute   :kana_state, :string
  attribute   :kanji_city, :string
  attribute   :kana_city, :string
  attribute   :kanji_town, :string
  attribute   :kana_town, :string
  attribute   :kanji_line1, :string
  attribute   :kanji_line2, :string
  attribute   :kana_line1, :string
  attribute   :kana_line2, :string
  attribute   :phone, :string
  attribute   :verification, :boolean, default: false

  validates   :last_name_kanji, presence: true
  validates   :last_name_kana, presence: true
  validates   :first_name_kanji, presence: true
  validates   :first_name_kana, presence: true
  validates   :gender, presence: true
  validates   :email, presence: true
  validate    :dob_check
  validates   :postal_code, presence: true
  validates   :kanji_state, presence: true
  validates   :kanji_city, presence: true
  validates   :kanji_town, presence: true
  validates   :kanji_line1, presence: true
  validates   :kana_line1, presence: true
  validates   :phone, telephone_number: { country: :jp, types: %i[fixed_line mobile] } # uses gem 'telephone_number'
  validates   :verification, presence: true

  def dob_check
    if dob.present?
      errors.add(:dob, '：１３歳未満はご利用できません。') if dob > Time.zone.today.prev_year(13)
    else
      errors.add(:dob, :blank)
    end
  end

  def international_phone_number
    phone_object = TelephoneNumber.parse(phone, :jp)
    phone_object.e164_number
  end

  def national_phone_number
    phone_object = TelephoneNumber.parse(phone, :jp)
    phone_object.national_number
  end

  def self.convert_to_date(stripe_date)
    return [false, 'year is blank'] if stripe_date['year'].blank?
    return [false, 'month is blank'] if stripe_date['month'].blank?
    return [false, 'day is blank'] if stripe_date['day'].blank?

    DateTime.new(stripe_date['year'], stripe_date['month'], stripe_date['day'], 0, 0, 0)
  end

  def convert_attributes(personal_info)
    personal_info['gender'] = StripeAccountForm.translate_gender(personal_info['gender'])
    personal_info['dob'] = StripeAccountForm.convert_to_date(personal_info['dob'])
    personal_info
  end

  def self.create_inputs(account_form, remote_ip, mode)
    ac_params = {
      business_type: 'individual',
      individual: account_form.create_stripe_individual
    }
    ac_params.merge!(type: 'custom', country: 'JP') if mode == 'create'
    if account_form.user_agreement
      ac_params.merge!(tos_acceptance: { date: Time.parse(Time.zone.now.to_s).to_i, ip: remote_ip.to_s })
    end
    ac_params.merge!(settings: { payouts: { schedule: { interval: 'manual' } } })
    ac_params
  end

  def create_stripe_individual
    indiv = {
      last_name: last_name_kanji.presence,
      last_name_kanji: last_name_kanji.presence,
      last_name_kana: last_name_kana.presence,
      first_name: first_name_kanji.presence,
      first_name_kanji: first_name_kanji.presence,
      first_name_kana: first_name_kana.presence,
      email: email.presence,
      gender: gender.presence,
      dob: create_stripe_dob,
      phone: phone.present? ? international_phone_number : nil,
    }
    indiv.merge!(create_stripe_address)
    indiv
  end

  def create_stripe_dob
    if dob.present?
      { year: dob.year.to_s, month: dob.month.to_s, day: dob.day.to_s }
    else
      {}
    end
  end

  def create_stripe_address
    if postal_code.present?
      {
        address_kanji: {
          postal_code: postal_code,
          state: kanji_state.presence,
          city: kanji_city.presence,
          town: kanji_town.presence,
          line1: kanji_line1.presence,
          line2: kanji_line2.presence,
        },
        address_kana: {
          line1: kana_line1.present? ? JpKana.hankaku(kana_line1) : nil,
          line2: kana_line2.present? ? JpKana.hankaku(kana_line2) : nil,
        },
      }
    else
      {}
    end
  end

  def self.parse_account_info(stripe_account_obj)
    check_results = StripeAccountForm.check_results(stripe_account_obj)
    return [false, check_results[1]] if check_results[0] == false

    personal_info = StripeAccountForm.parse_personal_info(stripe_account_obj['individual'])
    return [false, personal_info[1]] if personal_info[0] == false

    id = stripe_account_obj['id']
    tos_acceptance = if stripe_account_obj.key?('tos_acceptance')
                       stripe_account_obj['tos_acceptance']
                     else
                       { 'date' => nil, 'ip' => nil }
                     end

    payouts_enabled = (stripe_account_obj['payouts_enabled'] if stripe_account_obj.key?('payouts_enabled'))
    requirements = (stripe_account_obj['requirements'] if stripe_account_obj.key?('requirements'))
    bank_info = Bank.parse_bank_info(stripe_account_obj)
    bank_info[1] = { 'bank_name' => nil, 'branch_name' => nil, 'account_number' => nil, 'account_holder_name' => nil } unless bank_info[0]
    account_info = { 'id' => id, 'personal_info' => personal_info[1], 'tos_acceptance' => tos_acceptance,
                     'bank_info' => bank_info[1], 'payouts_enabled' => payouts_enabled, 'requirements' => requirements, }

    [true, account_info]
  end

  def self.check_results(stripe_obj)
    return [false, 'params for :object does not exist'] if stripe_obj.key?('object') == false

    case stripe_obj['object']
    when 'account'
      if stripe_obj.key?('id') == false
        [false, 'stripe id does not exist']
      elsif stripe_obj.key?('individual') == false
        [false, 'params for :individual does not exist']
      else
        [true, nil]
      end
    when 'balance' then
      return [false, 'params for :available does not exist'] if stripe_obj.key?('available') == false
      return [false, 'params for :pending does not exist'] if stripe_obj.key?('pending') == false

      if ENV['RAILS_ENV'] == 'production'
        return [false, 'livemode is set to false'] unless stripe_obj['livemode']
      end
      [true, nil]
    else
      [false, 'unknown stripe object type']
    end
  end

  def self.parse_personal_info(individual)
    personal_info = {}
    personal_info.merge!(StripeAccountForm.parse_person(individual))
    personal_info.merge!(StripeAccountForm.parse_address(individual))

    if individual.key?('phone')
      if individual['phone'].present?
        phone_object = TelephoneNumber.parse(individual['phone'])
        personal_info.merge!({ 'phone' => phone_object.national_number }) if phone_object.valid?
      end
    end
    personal_info.merge!({ 'verification' => individual['verification'] }) if individual.key?('verification')

    [true, personal_info]
  end

  def self.parse_dob(individual)
    if individual.key?('dob')
      { 'year' => individual['dob']['year'].presence,
        'month' => individual['dob']['month'].presence,
        'day' => individual['dob']['day'].presence }
    else
      {}
    end
  end

  def self.parse_person(individual)
    gender = StripeAccountForm.translate_gender(individual['gender']) if individual.key?('gender')
    dob = StripeAccountForm.parse_dob(individual)
    {
      'last_name_kanji' => individual['last_name_kanji'].presence,
      'last_name_kana' => individual['last_name_kana'].presence,
      'first_name_kanji' => individual['first_name_kanji'].presence,
      'first_name_kana' => individual['first_name_kana'].presence,
      'gender' => gender,
      'email' => individual['email'].presence,
      'dob' => dob,
    }
  end

  def self.parse_address(individual)
    address = {}
    if individual.key?('address_kanji')
      address.merge!({ 'postal_code' => JpKana.hankaku(individual['address_kanji']['postal_code']),
                       'kanji_state' => individual['address_kanji']['state'],
                       'kanji_city' => individual['address_kanji']['city'],
                       'kanji_town' => individual['address_kanji']['town'],
                       'kanji_line1' => individual['address_kanji']['line1'],
                       'kanji_line2' => individual['address_kanji']['line2'], })
    end
    if individual.key?('address_kana')
      address.merge!({ 'kana_state' => individual['address_kana']['state'],
                       'kana_city' => individual['address_kana']['city'],
                       'kana_town' => individual['address_kana']['town'],
                       'kana_line1' => JpKana.hankaku(individual['address_kana']['line1']),
                       'kana_line2' => JpKana.hankaku(individual['address_kana']['line2']) })
    end
    address
  end

  def self.translate_gender(word)
    case word
    when 'male'
      '男性'
    when 'female'
      '女性'
    when '男性'
      'male'
    when '女性'
      'female'
    else
      ''
    end
  end
end
