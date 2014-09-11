require File.expand_path('../test_helper', File.dirname(__FILE__))

class TestX509Name < TestCase

  def test_to_a_to_s
    dn = [
      ["DC", "org"],
      ["DC", "jruby", 22],
      ["CN", "Karol Bucek"],
      ["UID", "kares"],
      ["emailAddress", "jruby@kares-x.org"],
      ["serialNumber", "1234567890"],
      ["street", "Edelenyska"],
      ['2.5.4.44', 'X'],
      ['2.5.4.65', 'BUBS'],
      ['postalCode', '04801', 22],
      ['postalAddress', 'Edelenyska 1, Roznava'],
    ]
    name = OpenSSL::X509::Name.new
    dn.each { |attr| name.add_entry(*attr) }
    ary = name.to_a

    exp_to_a = [
      ["DC", "org", 22],
      ["DC", "jruby", 22],
      ["CN", "Karol Bucek", 12],
      ["UID", "kares", 12],
      ["emailAddress", "jruby@kares-x.org", 22],
      ["serialNumber", "1234567890", 19],
      ["street", "Edelenyska", 12],
      ['generationQualifier', 'X', 12],
      ['pseudonym', 'BUBS', 12],
      ['postalCode', '04801', 22],
      ['postalAddress', 'Edelenyska 1, Roznava', 12],
    ]

    assert_equal exp_to_a.size, ary.size
    exp_to_a.each_with_index do |el, i|
      assert_equal el, ary[i]
    end

    str = exp_to_a.map { |arr| "#{arr[0]}=#{arr[1]}" }.join('/')
    assert_equal "/#{str}", name.to_s
  end

  def test_raise_on_invalid_field_name
    name = OpenSSL::X509::Name.new
    name.add_entry 'invalidName', ''
    fail "expected to raise: #{name}"
  rescue OpenSSL::X509::NameError => e
    # #<OpenSSL::X509::NameError: invalid field name>
    assert e.message.start_with? 'invalid field name'
  end

end