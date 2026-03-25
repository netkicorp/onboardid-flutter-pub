enum AdditionalDataField {
  investorType('investor_type'),
  isAccreditedInvestor('is_accredited_investor'),
  isPhoneValidated('is_phone_validated'),
  firstName('first_name'),
  lastName('last_name'),
  middleName('middle_name'),
  alias('alias'),
  clientGuid('client_guid'),
  gender('gender'),
  countryCode('country_code'),
  birthDate('birth_date'),
  deathDate('death_date'),
  birthLocation('birth_location'),
  phoneNumber('phone_number'),
  email('email'),
  medicalLicense('medical_license'),
  ssn('ssn'),
  tin('tin'),
  duiNumber('dui_number');

  const AdditionalDataField(this.value);
  final String value;
}
