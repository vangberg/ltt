require File.join(File.dirname(__FILE__), '..', 'helpers')

class TestUser < Test::Unit::TestCase
  # stupid hack to avoid datamapper lameness
  test 'set default duration' do
    entry = Entry.create
    assert_equal 0, entry.duration
  end

  test "don't set default duration if already set" do
    entry = Entry.create(:duration => 60)
    assert_equal 60, entry.duration
  end

  context "translate duration to seconds from" do
    test "minutes" do
      entry = Entry.create(:duration_as_string => '10m')
      assert_equal 10 * 60, entry.duration
    end

    test "hours" do
      entry = Entry.create(:duration_as_string => '2h')
      assert_equal 2 * 3600, entry.duration
    end

    test "hours and minutes" do
      entry = Entry.create(:duration_as_string => '2h10m')
      assert_equal (2 * 3600) + (10 * 60), entry.duration
    end

    test "hours and minutes with spaces" do
      entry = Entry.create(:duration_as_string => '2h 10m')
      assert_equal (2 * 3600) + (10 * 60), entry.duration
    end
  end

  context 'duration is written' do
    test 'as minutes' do
      entry = Entry.create(:duration => 10 * 60)
      assert_equal '10m', entry.duration.to_human
    end

    test 'as hours' do
      entry = Entry.create(:duration => 60 * 60)
      assert_equal '1h0m', entry.duration.to_human
    end

    test 'as hours and minutes' do
      entry = Entry.create(:duration => 60 * 60 + 10 * 60)
      assert_equal '1h10m', entry.duration.to_human
    end
  end
end
