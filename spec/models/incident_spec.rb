# == Schema Information
#
# Table name: incidents
#
#  id            :integer          not null, primary key
#  student_id    :integer
#  user_id       :integer
#  institution   :integer
#  description   :text
#  date_incident :date
#  soluction     :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  course_id     :integer
#  time_incident :time
#  assistant_id  :integer
#  signed_in     :datetime
#  is_resolved   :integer
#  type_student  :integer
#  sanction      :integer
#  school_group  :integer
#

require 'rails_helper'

RSpec.describe Student::Incident, type: :model do
  before(:each) do
    @incident = FactoryBot.create :incident
  end

  # Validations
  it { should validate_presence_of :user  }
  it { should validate_presence_of :institution  }
  it { should validate_presence_of :course  }
  it { should validate_presence_of :description  }
  it { should validate_presence_of :assistant  }
  it { should validate_presence_of :date_incident  }
  it { should validate_presence_of :time_incident  }

  # Columns
  it { should have_db_column :id }
  it { should have_db_column :student_id }
  it { should have_db_column :user_id }
  it { should have_db_column :assistant_id }
  it { should have_db_column :course_id }
  it { should have_db_column :institution }
  it { should have_db_column :date_incident }
  it { should have_db_column :time_incident }
  it { should have_db_column :soluction }
  it { should have_db_column :description }

  # Indexes
  it { should have_db_index ["student_id"] }
  it { should have_db_index ["user_id"] }
  it { should have_db_index ["institution"] }
  it { should have_db_index ["date_incident"] }

  # Associations
  it { should belong_to(:student) }
  it { should belong_to(:assistant) }
  it { should belong_to(:user) }
  it { should belong_to(:course) }

  # Enums
  it { should define_enum_for(:institution).with(["Ifms", "Ufms", "Cemid"]) }
  it { should define_enum_for(:is_resolved).with(["no_", "yes_"]) }
  it { should define_enum_for(:type_student).with(['non_resident', 'resident']) }
  it { should define_enum_for(:sanction).with(['verbal_warning', 'written_warning', 'suspension', 'quitting_school']) }

  # Methods
  describe '#search' do

    context "find with one param" do
      it "find incident by student" do
        conditionals = {}
        conditionals[:student] = @incident.student.id
        expect(Student::Incident.search(conditionals)).to eq([@incident])
      end

      it "find incident by course" do
        conditionals = {}
        conditionals[:course] = @incident.course.id
        expect(Student::Incident.search(conditionals)).to eq([@incident])
      end

      it "find incident by institution" do
        conditionals = {}
        conditionals[:institution] = 0
        expect(Student::Incident.search(conditionals)).to eq([@incident])
      end

      it "find incident by type_student" do
        conditionals = {}
        conditionals[:type_student] = 1
        expect(Student::Incident.search(conditionals)).to eq([@incident])
      end

      it "find incident by range date" do
        conditionals = {}
        range_date = "date_incident >= #{@incident.date_incident - 1.day} AND date_incident <= #{@incident.date_incident + 1.day}"
        expect(Student::Incident.search(conditionals).search(range_date)).to eq([@incident])
      end
    end

    context "find with all params" do
      it "find incident " do
        conditionals = {}
        conditionals[:student] = @incident.student.id
        conditionals[:course] = @incident.course.id
        conditionals[:institution] = 0
        conditionals[:type_student] = 1
        range_date = "date_incident >= #{@incident.date_incident - 1.day} AND date_incident <= #{@incident.date_incident + 1.day}"
        expect(Student::Incident.search(conditionals).search(range_date)).to eq([@incident])
      end
    end
  end

  describe '#student_name' do
    let(:subject){ FactoryBot.create(:incident) }

    context 'When student are present' do
      it 'Returns student name' do
        expect(subject.student_name).to eq(subject.student.name)
      end
    end

    context 'When student are not present' do
      before do
        allow(subject).to receive(:student).and_return(nil)
      end

      it "Returns ' ---- ' string" do
        expect(subject.student_name).to eq(' ---- ')
      end
    end
  end

  describe '#course_initial' do
    let(:subject){ FactoryBot.create(:incident) }

    context 'When course are present' do
      it 'Returns course name' do
        expect(subject.course_initial).to eq(subject.course.initial)
      end
    end

    context 'When course are not present' do
      before do
        allow(subject).to receive(:course).and_return(nil)
      end

      it "Returns ' ---- ' string" do
        expect(subject.course_initial).to eq(' ---- ')
      end
    end
  end

  describe '#signed_by_student_in' do
    let(:subject){ FactoryBot.create(:incident) }

    context 'When signed_in field is present' do
      before do
        allow(subject).to receive(:signed_in).and_return(Time.new(2017, 10, 3))
      end

      it 'Returns formated signed_in date' do
        expect(subject.signed_by_student_in).to eq('03/10/2017')
      end
    end

    context 'When signed_in field is not present' do
      before do
        allow(subject).to receive(:signed_in).and_return(nil)
      end

      it 'Returns nil' do
        expect(subject.signed_by_student_in).to eq(nil)
      end
    end
  end

  describe ".ordenation_attributes" do
    ordenation_attributes = Student::Incident.ordenation_attributes

    it "should return an array" do
      expect(ordenation_attributes).to be_an_instance_of(Array)

      ordenation_attributes.each do |attribute|
        expect(attribute).to be_an_instance_of(Array)
      end
    end

    ordenation_attributes.each do |attribute|
      it "should return user attribute #{attribute}" do
        if attribute.last != 'student_name'
          expect(Student::Incident.attribute_names.include?(attribute.last)).to be true
        end
      end
    end
  end
end
