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
  attribute   :birthdate, :datetime
  attribute   :postal_code, :string
  attribute   :state, :string
  attribute   :city, :string
  attribute   :town, :string
  attribute   :kanji_line1, :string
  attribute   :kanji_line2, :string
  attribute   :kana_line1, :string
  attribute   :kana_line2, :string
  attribute   :phone, :string
  attribute   :user_agreement, :boolean, default: false

  validates   :last_name_kanji, presence: true
  validates   :last_name_kana, presence: true
  validates   :first_name_kanji, presence: true
  validates   :first_name_kana, presence: true
  validates   :gender, presence: true
  validates   :email, presence: true
  validate    :birthdate_check
  validates   :postal_code, presence: true
  validates   :state, presence: true
  validates   :city, presence: true
  validates   :town, presence: true
  validates   :kanji_line1, presence: true
  validates   :kanji_line2, presence: true
  validates   :kana_line1, presence: true
  validates   :kana_line2, presence: true
  validates   :phone, telephone_number: { country: :jp, types: %i[fixed_line mobile] } # uses gem 'telephone_number'
  validates   :user_agreement, presence: true

  def birthdate_check
    if birthdate.present?
      if birthdate > Time.zone.today.prev_year(13)
        errors.add(:birthdate, '：１３歳未満はご利用できません。') 
      end
    else
      errors.add(:birthdate, :blank)
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
  
  def self.set_date(stripe_date)
    if stripe_date['year'].present?
      year = stripe_date['year']
      if stripe_date['month'].present?
        month = stripe_date['month'] 
        if stripe_date['day'].present?
          day = stripe_date['day']
          return DateTime.new(year, month, day, 0, 0, 0)
        end
      end
    end
    return nil
  end
  
  def set_info(account_info)
    self.last_name_kanji = account_info['personal_info']['last_name_kanji']
    self.last_name_kana = account_info['personal_info']['last_name_kana']
    self.first_name_kanji = account_info['personal_info']['first_name_kanji']
    self.first_name_kana = account_info['personal_info']['first_name_kana']
    self.gender = StripeAccountForm.translate_gender(account_info['personal_info']['gender'])
    self.birthdate = StripeAccountForm.set_date(account_info['personal_info']['dob'])
    self.postal_code = account_info['personal_info']['postal_code']
    self.state = account_info['personal_info']['kanji_state']
    self.city = account_info['personal_info']['kanji_city']
    self.town = account_info['personal_info']['kanji_town']
    self.kanji_line1 = account_info['personal_info']['kanji_line1']
    self.kanji_line2 = account_info['personal_info']['kanji_line2']
    self.kana_line1 = account_info['personal_info']['kana_line1']
    self.kana_line2 = account_info['personal_info']['kana_line2']
    self.phone = account_info['personal_info']['phone']
    self.user_agreement = account_info['personal_info']['verification']
  end
  
  def stripe_inputs_individual
    indiv = {
      last_name: last_name_kanji.present? ? last_name_kanji : nil,
      last_name_kanji: last_name_kanji.present? ? last_name_kanji : nil,
      last_name_kana: last_name_kana.present? ? last_name_kana : nil,
      first_name: first_name_kanji.present? ? first_name_kanji : nil,
      first_name_kanji: first_name_kanji.present? ? first_name_kanji : nil,
      first_name_kana: first_name_kana.present? ? first_name_kana : nil,
      gender: gender.present? ? gender : nil,
      dob: birthdate.present? ? { year: birthdate.year.to_s, month: birthdate.month.to_s, day: birthdate.day.to_s } : nil,
      address_kanji: {
        postal_code: postal_code.present? ? postal_code : nil,
        state: state.present? && postal_code.present? ? state : nil,
        city: city.present? && postal_code.present? ? city : nil,
        town: town.present? && postal_code.present? ? town : nil,
        line1: kanji_line1.present? && postal_code.present? ? kanji_line1 : nil,
        line2: kanji_line2.present? && postal_code.present? ? kanji_line2 : nil
      },
      address_kana: {
        line1: kana_line1.present? && postal_code.present? ? StripeAccount.hankaku(kana_line1) : nil,
        line2: kana_line2.present? && postal_code.present? ? StripeAccount.hankaku(kana_line2) : nil
      },
      phone: phone.present? ? international_phone_number : nil,
      email: email.present? ? email : nil
    }
    
    indiv
  end

  def self.parse_personal_info(individual)
    last_name_kanji = (individual['last_name_kanji'] if individual.key?('last_name_kanji'))
    last_name_kana = (individual['last_name_kana'] if individual.key?('last_name_kana'))
    first_name_kanji = (individual['first_name_kanji'] if individual.key?('first_name_kanji'))
    first_name_kana = (individual['first_name_kana'] if individual.key?('first_name_kana'))

    gender = StripeAccountForm.translate_gender(individual['gender']) if individual.key?('gender')

    email = (individual['email'] if individual.key?('email'))

    if individual.key?('dob')
      year = (individual['dob']['year'] if individual['dob']['year'].present?)
      month = (individual['dob']['month'] if individual['dob']['month'].present?)
      day = (individual['dob']['day'] if individual['dob']['day'].present?)
    else
      year = nil
      month = nil
      day = nil
    end

    personal_info = {}
    personal_info.merge!({ 'last_name_kanji' => last_name_kanji })
    personal_info.merge!({ 'last_name_kana' => last_name_kana })
    personal_info.merge!({ 'first_name_kanji' => first_name_kanji })
    personal_info.merge!({ 'first_name_kana' => first_name_kana })
    personal_info.merge!({ 'gender' => gender })
    personal_info.merge!({ 'email' => email })
    personal_info.merge!({ 'dob' => { 'year' => year, 'month' => month, 'day' => day } })
    if individual.key?('address_kanji')
      personal_info.merge!({ 'postal_code' => hankaku(individual['address_kanji']['postal_code']) })
      personal_info.merge!({ 'kanji_state' => individual['address_kanji']['state'] })
      personal_info.merge!({ 'kanji_city'  => individual['address_kanji']['city'] })
      personal_info.merge!({ 'kanji_town'  => individual['address_kanji']['town'] })
      personal_info.merge!({ 'kanji_line1' => individual['address_kanji']['line1'] })
      personal_info.merge!({ 'kanji_line2' => individual['address_kanji']['line2'] })
    end
    if individual.key?('address_kana')
      personal_info.merge!({ 'kana_state' => individual['address_kana']['state'] })
      personal_info.merge!({ 'kana_city' => individual['address_kana']['city'] })
      personal_info.merge!({ 'kana_town' => individual['address_kana']['town'] })
      personal_info.merge!({ 'kana_line1' => StripeAccount.hankaku(individual['address_kana']['line1']) })
      personal_info.merge!({ 'kana_line2' => StripeAccount.hankaku(individual['address_kana']['line2']) })
    end
    if individual.key?('phone')
      if individual['phone'].present?
        phone_object = TelephoneNumber.parse(individual['phone'])
        personal_info.merge!({ 'phone' => phone_object.national_number }) if phone_object.valid?
      end
    end
    personal_info.merge!({ 'verification' => individual['verification'] }) if individual.key?('verification')

    [true, personal_info]
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