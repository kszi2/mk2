require "test_helper"

class SubmissionTest < ActiveSupport::TestCase
  def setup
    @student = students(:john_doe)
    @coursework = courseworks(:lab1)
    @group = groups(:group_lab1)
    @submission = Submission.new(student: @student, group: @group, coursework: @coursework)
  end

  test "Submission can be found by public id" do
    assert_respond_to Submission, :public_find
    assert_respond_to @submission, :public_id
  end

  test "valid submission should be valid" do
    assert @submission.valid?
  end

  test "should require a student_id" do
    @submission.student = nil
    refute @submission.valid?
    assert @submission.errors.added?(:student_id, :blank)
  end

  test "should require a coursework_id" do
    @submission.coursework = nil
    refute @submission.valid?
    assert @submission.errors.added?(:coursework_id, :blank)
  end

  test "should enforce uniqueness of coursework per student on create" do
    @submission.save!
    duplicate_submission = Submission.new(student: @student, group: @group, coursework: @coursework)
    refute duplicate_submission.valid?
    assert duplicate_submission.errors.added?(:coursework_id,
                                              :taken,
                                              value: @submission.coursework_id)
  end

  test "total_points should return coursework total points" do
    assert_equal 100, @submission.total_points
  end

  test "for_coursework should return coursework name" do
    assert_equal "Labor 1", @submission.for_coursework
  end

  test "marked_for should return total points if no failed criteria" do
    def @submission.marked_points
      []
    end

    assert_equal 100, @submission.marked_for
  end

  test "marked_for should return 0 if failed any criteria" do
    rp = rating_points(:lab1_crit)
    @submission.define_singleton_method :marked_points do
      mp = MarkedPoint.new(submission: @submission, rating_point: rp)
      mp.marking_notes << MarkingNote.new(marked_point: mp, points_cost: 1)

      [mp]
    end

    assert_equal 0, @submission.marked_for
  end

  test "marked_for should return reduced points if failed non-criteria" do
    rp = rating_points(:lab1_complete_rating)
    @submission.define_singleton_method :marked_points do
      mp = MarkedPoint.new(submission: @submission, rating_point: rp)
      mp.marking_notes << MarkingNote.new(marked_point: mp, points_cost: 42)

      [mp]
    end

    assert_equal 100 - 42, @submission.marked_for
  end

  test "criteria points without category returns all marked points for criteria" do
    rp = rating_points(:lab1_crit)
    mp = MarkedPoint.new(submission: @submission, rating_point: rp)
    mp.marking_notes << MarkingNote.create!(marked_point: mp, points_cost: 1)
    mp.save!
    @submission.marked_points << mp
    @submission.save!

    assert_equal [mp.id], @submission.criteria_points.map(&:id)
  end

  test "criteria points with category returns marked points in category for criteria" do
    rp = rating_points(:lab1_crit)
    mp = MarkedPoint.new(submission: @submission, rating_point: rp)
    mp.marking_notes << MarkingNote.create!(marked_point: mp, points_cost: 1)
    mp.save!
    @submission.marked_points << mp
    @submission.save!

    assert_equal [], @submission.criteria_points("invalid").map(&:id)
    assert_equal [mp.id], @submission.criteria_points("presence").map(&:id)
  end

  test "standard points without category returns all marked points for points" do
    rp = rating_points(:lab1_complete_rating)
    mp = MarkedPoint.new(submission: @submission, rating_point: rp)
    mp.marking_notes << MarkingNote.create!(marked_point: mp, points_cost: 1)
    mp.save!
    @submission.marked_points << mp
    @submission.save!

    assert_equal [mp.id], @submission.standard_points.map(&:id)
  end

  test "standard points with category returns marked points in category for points" do
    rp = rating_points(:lab1_complete_rating)
    mp = MarkedPoint.new(submission: @submission, rating_point: rp)
    mp.marking_notes << MarkingNote.create!(marked_point: mp, points_cost: 1)
    mp.save!
    @submission.marked_points << mp
    @submission.save!

    assert_equal [], @submission.standard_points("invalid").map(&:id)
    assert_equal [mp.id], @submission.standard_points("labor").map(&:id)
  end

  test "render_as should return formatted coursework and student name" do
    assert_equal "Labor 1 (John Doe)", @submission.render_as
  end

  test "render_as should return empty string if coursework or student is nil" do
    @submission.coursework = nil
    assert_equal "", @submission.render_as

    @submission.student = nil
    assert_equal "", @submission.render_as
  end
end
