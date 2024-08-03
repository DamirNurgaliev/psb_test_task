require "spec_helper"

describe Authors::Destroy do
  describe "#call" do
    subject(:call) { described_class.call(author: author) }

    let(:author) { create(:author) }
    let!(:another_author) { create(:author) }
    let!(:course1) { create(:course, author: author) }
    let!(:course2) { create(:course, author: author) }

    context "when there is another author available" do
      it "reassigns the courses to another author and deletes the original author" do
        expect(call).to be_success
        expect(course1.reload.author).to eq(another_author)
        expect(course2.reload.author).to eq(another_author)
      end
    end

    context "when there is no other author available" do
      let!(:another_author) { nil }

      it "doesn't delete the last author" do
        expect(call).to be_failure
        expect(call.message).to eq("Can't delete last author")
        expect(author.reload).to be_present
      end
    end

    context "when author cannot be deleted" do
      before do
        allow(author).to receive(:destroy).and_return(false)
      end

      it "fails and does not delete the author" do
        expect(call).to be_failure
        expect(course1.reload.author).to eq(author)
        expect(course2.reload.author).to eq(author)
        expect(author.reload).to be_present
      end
    end
  end
end
