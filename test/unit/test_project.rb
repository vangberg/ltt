require File.join(File.dirname(__FILE__), '..', 'helpers')

class TestProject < Test::Unit::TestCase
  before do
    @project = Project.create(:name => 'The Stone Roses')
  end

  test "has many entries" do
    @project.entries << e = Entry.create
    assert_equal @project.entries.last, e
  end

  test "must have a name" do
    project = Project.create
    assert !project.save
  end

  test "generate a short url if not specified" do
    project = Project.create(:name => 'Analog Africa')
    assert_equal 'analog-africa', project.short_url
  end

  test "don't generate a short url if specified" do
    project = Project.create(:name => 'Ethiopiques 1', :short_url => 'africabeat')
    assert_equal 'africabeat', project.short_url
  end
end
