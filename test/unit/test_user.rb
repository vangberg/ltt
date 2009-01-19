require File.join(File.dirname(__FILE__), '..', 'helpers')

class TestUser < Test::Unit::TestCase
  before do
    @user = User.create(:login => 'Coltrane', :password => 'Olatunji')
    @project = @user.projects.create(:name => 'Different Class')
  end

  test 'a user has many projects' do
    @user.projects << Project.create(:name => 'Blue Train')
    assert_equal @user.projects.last.name, 'Blue Train'
  end

  test 'a user has many entries' do
    @project.entries.create
    assert @user.entries.length > 0, 'user has no entries'
  end

  test 'a user can be tracking one entry' do
    @user.tracking = e = Entry.create
    @user.save
    assert_equal @user.reload.tracking, e
  end

  test 'a user can track a project' do
    @user.track!(@project)
    assert_equal @project, @user.reload.tracking.project
  end

  test "can't start tracking if already tracking" do
    @user.track!(@project)

    other_project = @user.projects.create(:name => 'Other')
    assert_raise RuntimeError do
      @user.track!(other_project)
    end
  end

  test 'a user can stop tracking' do
    @user.track!(@project)
    @user.stop!
    assert_equal nil, @user.reload.tracking
  end

  test 'a user can stop tracking w/ description' do
    @user.track!(@project)
    @user.stop!('deploying stuff')
    assert_equal 'deploying stuff', @project.entries.all.last.description
  end

  test 'stopping while not tracking fails' do
    assert_raise RuntimeError do
      @user.stop!
    end
  end

  test 'tracking duration' do
    now = Time.now
    past = now - 10 * 60

    stub(Time).now {past}
    @user.track!(@project)

    stub(Time).now {now}
    @user.stop!

    assert_equal 10 * 60, Entry.all.last.duration
  end
end
